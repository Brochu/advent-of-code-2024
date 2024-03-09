#pragma once
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    size_t size;
    size_t cap;
} header;

#define _ARR_INIT_CAP 8
#define arr_init(T) (_arr_init(sizeof(T), _ARR_INIT_CAP))
#define arr_header(a) ((header *)a - 1)
#define arr_size(a) (arr_header(a)->size)
#define arr_cap(a) (arr_header(a)->cap)
#define arr_push(a, v) _arr_adapt(); a[arr_size(a)]=v; arr_header(a)->size++
#define arr_free(a) (_arr_free(a))

void *_arr_init(size_t it_size, size_t cap) {
    void *ptr = 0;

    size_t size = (it_size * cap) + sizeof(header);
    header *h = malloc(size);
    if (h) {
        h->size = 0;
        h->cap = cap;
        ptr = h + 1;
    }

    return ptr;
}

void _arr_adapt() {
    printf("[ARR] TEST!!\n");
}

void _arr_free(void *arr) {
    free(arr_header(arr));
}
