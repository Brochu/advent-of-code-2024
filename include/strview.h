#pragma once

typedef struct {
    const char *ptr;
    size_t size;
} strview;

#define STR_FMT "%.*s"
#define STR_ARG(view) (int)view.size, view.ptr

strview FromLitteral(const char *lit);
strview FromCString(char *str);
