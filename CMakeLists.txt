cmake_minimum_required (VERSION 3.10)

project (AoC2024 C)
set (CMAKE_EXPORT_COMPILE_COMMANDS ON)

message(" -=- Creating build folder for Day : ${DAY} -=- ")

set (headers
    ${CMAKE_CURRENT_LIST_DIR}/include/day.h
    ${CMAKE_CURRENT_LIST_DIR}/include/darray.h
    ${CMAKE_CURRENT_LIST_DIR}/include/parsing.h
    ${CMAKE_CURRENT_LIST_DIR}/include/strview.h
)
set (source
    ${CMAKE_CURRENT_LIST_DIR}/src/day${DAY}.c
    ${CMAKE_CURRENT_LIST_DIR}/src/darray.c
    ${CMAKE_CURRENT_LIST_DIR}/src/parsing.c
    ${CMAKE_CURRENT_LIST_DIR}/src/main.c
    ${CMAKE_CURRENT_LIST_DIR}/src/strview.c
)

set (libs
    raylib.lib
    WinMM.lib
)

message(" -=- Headers generated: ${headers} -=- ")
message(" -=- Source generated: ${source} -=- ")

add_executable (AoC2024 ${source} ${headers})

target_include_directories(AoC2024
    PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}/include
        ${CMAKE_CURRENT_LIST_DIR}/include/raylib
)
target_link_directories(AoC2024
    PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}/libs
)
set_target_properties(AoC2024
    PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY       "${CMAKE_CURRENT_LIST_DIR}/"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_CURRENT_LIST_DIR}/"
)
target_compile_definitions(AoC2024
    PRIVATE
    DAY=${DAY}
)
target_link_libraries(AoC2024 ${libs})
