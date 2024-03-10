#include "darray.h"

#include <stdint.h>
#include <stdio.h>

int main(int argc, char **argv) {
    printf("[MAIN] Trying my hand at C??\n");

    printf("[MAIN] Creating a dynamic array ...\n");
    uint64_t *myArray = arr_init(uint64_t);

    size_t size = arr_size(myArray);
    size_t cap = arr_cap(myArray);
    size_t it_size = arr_itemsize(myArray);
    printf("[MAIN] myArray { size: %lld; cap: %lld; item: %lld }\n", size, cap, it_size);
    for (int i = 0; i < 10; i++) {
        arr_push(myArray, i);
    }
    size = arr_size(myArray);
    cap = arr_cap(myArray);
    printf("[MAIN] myArray { size: %lld; cap: %lld }\n", size, cap);
    for (int i = 0; i < arr_size(myArray); i++) {
        printf(" - %lld \n", myArray[i]);
    }

    arr_free(myArray);
    return 0;
}
