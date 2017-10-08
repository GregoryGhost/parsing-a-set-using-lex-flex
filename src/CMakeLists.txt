cmake_minimum_required(VERSION 3.9)
project(lexCalc)				# Название проекта

find_package(FLEX)

FLEX_TARGET(rpn calc.l ${CMAKE_CURRENT_BINARY_DIR}/main.cpp)

add_executable(${PROJECT_NAME} ${FLEX_rpn_OUTPUTS})	# Создает исполняемый файл с именем lexCalc