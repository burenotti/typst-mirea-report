#import "template/template.typ": *

#show: project.with(
  title: "Отчёт по практической работе №1",
  theme: "Основы языка Python",
  department: "Математического обеспечения и стандартизации информационных технологий",
  course: "Программирование на Python",
  authors: (
    "Иванов И. И.",
    "Пупкин В. В.",
  ),
  lecturer: "Иванов П. F.",
  group: "ИКБО-11-22",
  date: datetime.today(),
  add_toc: true,
)

= Ход работы
== Введение
Этот шаблон подходит для любых мирэашных отчетов, в т.ч. курсовых. Если что-то работает неправильно, пишите в тг #link("https://t.me/burenin-a")[#text(fill: blue)[\@burenin-a]]

== Пример работы с картинками
С помощью функции `picture` можно добавить картинку с подписью в документ, таким образом, был добавлен @example-picture

#picture(
  caption: "Так называемый мем",
  path: "./docs/picture.jpg",
  width: 50%,
) <example-picture>

== Пример работы с листингами

=== Простые листинги
Для создания листинга можно использовать функцию `listing`
#listing(
  caption: "Программа выводит hello world в консоль",
  body: "print('Hello, world!')",
)

=== Листинг с подсветкой
Для создания листинга можно использовать функцию `listing`
#listing(
  caption: "Программа выводит hello world в консоль",
  body: ```py
  print("Hello, world")
  ```,
)

=== листинг из файла
Здесь можно увидеть как добавить листинг программы из файла
#listing(
  caption: "Некоторая прогрмма на языке python",
  file: "docs/script.py",
)

=== Частичное цитирование файла

На листинге #ref(<code-partial>, supplement: "листинге") можно увидеть, каким образом вставить только часть содежримого файла
#listing(
  caption: "Абстрактная функция square",
  file: "docs/script.py",
  from: 11,
  to: 21,
) <code-partial>

== Таблицы

#mytable(
  caption: "Простая таблица",
  head: ([x], [y], [z]),
  [1], [2], [3],
  [4], [5], [6],
  [7], [8], [9],
  [10], [11], [12],
)
Для создания таблиц используется функция mytable, она позволяет создавать таблицы с правильными подписями и хедерами
#mytable(
  caption: "Более сложная таблица",
  columns: (1fr, 1fr, 1fr, 1fr),
  head: (
    table.cell(rowspan: 2, align: horizon)[Ученик],
    table.cell(colspan: 3, align: center)[Оценки],
    [Русский язык],
    [Математика],
    [Литература],
  ),
  [Иванов И.И.],
  [86],
  [90],
  [54],
  [Пупки В.А.],
  [42],
  [12],
  [64],
  [Афанасьев А.О.],
  [86],
  [80],
  [76],
  ..(range(1, 30).map(i => ([Иванов И.И. #i], [86], [90], [54])).flatten()),
)
