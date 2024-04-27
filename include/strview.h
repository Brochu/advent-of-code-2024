#pragma once

typedef struct {
    const char *ptr;
    size_t size;
} strview;

#define STR_ARG(view) (int)view.size, view.ptr
