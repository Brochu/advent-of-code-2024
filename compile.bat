cmake -S . -B build -G Ninja -DDAY=%1 -DCMAKE_BUILD_TYPE=Debug
ninja -C build
