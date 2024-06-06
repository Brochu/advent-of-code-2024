#include "darray.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void *_arr_init(size_t it_size, size_t cap) {
    void *ptr = 0;

    size_t size = (it_size * cap) + sizeof(header);
    header *h = malloc(size);
    if (h) {
        h->size = 0;
        h->cap = cap;
        h->item_size = it_size;
        ptr = h + 1;
    }

    return ptr;
}

void _arr_adapt(void **arr, size_t count) {
    header *h = arr_header(*arr);
    size_t target_cap = h->size + count;
    //printf("[ARR] Adapting array (count = %lld; item size = %lld)\n", count, h->item_size);

    if (h->cap < target_cap) {
        size_t new_cap = h->cap * 2;
        while (new_cap < target_cap) {
            new_cap *= 2;
        }

        size_t new_size = (new_cap * h->item_size) + sizeof(header);
        header *new_h = malloc(new_size); //TODO: Replace with realloc?
        if (new_h) {
            size_t old_size = (h->size * h->item_size) + sizeof(*h);
            memcpy(new_h, h, old_size);
            free(h);

            new_h->cap = new_cap;
            *arr = (header*)new_h + 1;
        } else {
            *arr = NULL;
        }
    }
}

void _arr_popback(void *arr) {
    arr_header(arr)->size--;
}

void _arr_erase(void *arr, size_t i, void *from, void *to) {
    header *h = arr_header(arr);
    if (i == h->size - 1 || h->size == 1) {
        arr_popback(arr);
        return;
    }
    //printf("[ARR] Erase element at %lld, elem = %f, %f\n", i, *(double*)from, *(double*)to);
    size_t size = (h->size - (i + 1)) * h->item_size;

    memmove(to, from, size);
    h->size--;
}

void _arr_free(void *arr) {
    free(arr_header(arr));
}

void _arr_tests() {
    // Dynamic Array tests
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

    arr_erase(myArray, 0);
    size = arr_size(myArray);
    cap = arr_cap(myArray);
    printf("[MAIN] myArray { size: %lld; cap: %lld }\n", size, cap);
    for (int i = 0; i < arr_size(myArray); i++) {
        printf("%f, ", myArray[i]);
    }
    printf("\n");

    arr_free(myArray);
}
