cmake -S . -B build -G Ninja -DDAY=%1 -DCMAKE_BUILD_TYPE=Release
ninja -C build
