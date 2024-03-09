#include "darray.h"

#include <stdint.h>
#include <stdio.h>

int main(int argc, char **argv) {
    printf("[MAIN] Trying my hand at C??\n");

    printf("[MAIN] Creating a dynamic array ...\n");
    uint64_t *myArray = arr_init(uint64_t);

    size_t size = arr_size(myArray);
    size_t cap = arr_cap(myArray);
    printf("[MAIN] myArray { size: %lld; cap: %lld }\n", size, cap);
    for (int i = 0; i < 8; i++) {
        arr_push(myArray, 9);
    }
    size = arr_size(myArray);
    cap = arr_cap(myArray);
    printf("[MAIN] myArray { size: %lld; cap: %lld } -> %lld\n", size, cap, myArray[0]);

    arr_free(myArray);
    return 0;
}
