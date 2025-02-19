#import "../template/main.typ": *

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
#lorem(50)

== Пример работы с листингами
Здесь можно увидеть как добавить листинг программы из файла
#listing(
  caption: "asd",
  file: "./examples/script.go",
)
