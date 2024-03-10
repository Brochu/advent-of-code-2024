#include "darray.h"
#include <stdio.h>

int main(int argc, char **argv) {
    printf("[MAIN] Trying my hand at C??\n");

    printf("[MAIN] Creating a dynamic array ...\n");
    double *myArray = arr_init(double);

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
        printf("%f, ", myArray[i]);
    }
    printf("\n");

    arr_erase(myArray, 4);
    size = arr_size(myArray);
    cap = arr_cap(myArray);
    printf("[MAIN] myArray { size: %lld; cap: %lld }\n", size, cap);
    for (int i = 0; i < arr_size(myArray); i++) {
        printf("%f, ", myArray[i]);
    }
    printf("\n");

    arr_popback(myArray);
    size = arr_size(myArray);
    cap = arr_cap(myArray);
    printf("[MAIN] myArray { size: %lld; cap: %lld }\n", size, cap);
    for (int i = 0; i < arr_size(myArray); i++) {
        printf("%f, ", myArray[i]);
    }
    printf("\n");

    arr_free(myArray);
    return 0;
}
