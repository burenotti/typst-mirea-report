func (a *App) GetDependencyGraph(ctx context.Context, packageName string) ([]models.Edge, error) {

	// tasksWg counts remaining tasks, not goroutines
	tasksWg := &sync.WaitGroup{}

	// graph with all package dependencies
	var result []models.Edge
	resMutex := &sync.Mutex{}

	// A set of visited dependencies
	visited := make(map[string]struct{})
	visMutex := &sync.Mutex{}

	// channel with fetching tasks
	taskChan := make(chan fetchTask, _defaultConcurrency)

	// may contain first caught error
	var firstErr error
	var once sync.Once

	tasksWg.Add(1)
	taskChan <- fetchTask{packageName: packageName}
	ctx2, cancel := context.WithCancel(ctx)
	for i := 0; i < _defaultConcurrency; i++ {
		go func(ctx context.Context) {
			for {
				select {
				case <-ctx.Done():
					return
				case task, ok := <-taskChan:
					if !ok {
						return
					}
					if ok := pushIfNotExist(visited, visMutex, task.packageName); !ok {
						tasksWg.Done()
						return
					}

					deps, err := a.DepsProvider.FetchPackageDeps(ctx, task.packageName)

					if err != nil {
						tasksWg.Done()
						if errors.Is(err, context.Canceled) {
							return
						}

						once.Do(func() {
							firstErr = err
							cancel()
						})
						return
					}
					resMutex.Lock()
					for _, dep := range deps {
						result = append(result, models.Edge{From: task.packageName, To: dep})
					}
					resMutex.Unlock()

					tasksWg.Add(len(deps))
					for _, dep := range deps {
						taskChan <- fetchTask{dep}
					}
					tasksWg.Done()
				}
			}
		}(ctx2)
	}

	tasksWg.Wait()
	close(taskChan)
	cancel()
	if firstErr != nil {
		return nil, firstErr
	}
	return result, nil
}

func (a *App) Run(ctx context.Context, packageName string, output io.Writer) error {
	graph, err := a.GetDependencyGraph(ctx, packageName)
	if err != nil {
		return fmt.Errorf("can't receive dependency graph: %w", err)
	}

	if err := a.Serializer.Serialize(graph, output); err != nil {
		return fmt.Errorf("can't write output: %w", err)
	}
	return nil
}