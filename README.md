# ЛиПОСАПР: лабораторная работа №3
Калькулятор обратной польской записи.
Поддерживает работу с вещественными и целыми числами, а также операции (+, -, *, /) по работе с ними.
Дополнительный функционал - работа с множествами.
Поддерживаемые операции над множествами (в польской записи):
* множество множество + → объединение множеств;
* множество число ? → отвечает на вопрос входит ли число в множество (в результате 1 - входит, 0 - не входит);
* множество множество * → пересечение множеств.

# Использование сборочного скрипта
Для запуска тестировочного скрипта ``runMe.sh``:
```sh
$ bash ./runMe.sh
```
Тестировочный скрипт произведет следующие действия:
* соберёт проект;
* сообщит о результате сравнения тестового лога ``test_output.log`` и заданного лога-вывода ``true_output.log``;
* удалит все промежуточные файлы (объектные, исполняемые и т.д.).

# Примечание
* Написано в [VS Code](https://code.visualstudio.com/)
* Сборочные скрипты на базе [CMake](https://cmake.org/)
* Тестировочный скрипт был написан на ``BASH``
* Для лексического анализа входного текста использован ``FLEX``/``LEX``
