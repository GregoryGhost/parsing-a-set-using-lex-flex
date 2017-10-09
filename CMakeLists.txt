cmake_minimum_required(VERSION 3.9)
project(RPN)

enable_testing()

include_directories(include)

#if(BUILD_TESTING)
#    message("BUILD_ON")
#    add_subdirectory(test)
#else()
#    message("BUILD_OFF")
#    add_subdirectory(src)
#endif()
add_subdirectory(src)
#add_subdirectory(test)