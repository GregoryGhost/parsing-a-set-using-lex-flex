cmake_minimum_required(VERSION 3.9)
project(lexCalc)				# Название проекта


set(SOURCE main.cpp)		# Установка переменной со списком исходников для исполняемого файла

add_executable(${PROJECT_NAME} ${SOURCE})	# Создает исполняемый файл с именем lexCalc

#target_link_libraries(${PROJECT_NAME} PARSER)