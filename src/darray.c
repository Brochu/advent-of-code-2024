#include "darray.h"

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
        header *new_h = malloc(new_size);
        if (new_h) {
            size_t old_size = (h->size * h->item_size) + sizeof(*h);
            memcpy(new_h, h, old_size);
            free(h);

            new_h->cap = new_cap;
            *arr = (header*)new_h + 1;
        } else {
            *arr = 0;
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

    memcpy(to, from, size);
    h->size--;
}

void _arr_free(void *arr) {
    free(arr_header(arr));
}
