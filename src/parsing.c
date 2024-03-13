#include "parsing.h"
#include "darray.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

const char *strviewstr(strview str, const char *sep) {
    size_t sep_size = strlen(sep);

    for (int i = 0; i < str.size; i++) {
        if (str.ptr[i] == sep[0] && memcmp(&str.ptr[i], sep, sep_size) == 0) {
            return &str.ptr[i];
        }
    }
    return 0;
}

char *read_file(const char *path) {
    FILE *f = 0;
    fopen_s(&f, path, "rb");

    fseek(f, 0, SEEK_END);
    size_t fsize = ftell(f);
    fseek(f, 0, SEEK_SET);  /* same as rewind(f); */
    char *contents = malloc(fsize + 1);
    fread(contents, fsize, 1, f);
    fclose(f);

    contents[fsize] = 0;
    return contents;
}

strview *chr_split(const char *str, const char *sep) {
    strview *splits = arr_init(strview);

    size_t sep_size = strlen(sep);
    const char *start = str;
    const char *found = str;

    while ((found = strstr(start, sep))) {
        size_t size = (found - start) - sep_size;
        if (size > 0) {
            strview cur = (strview) {start, size};
            arr_push(splits, cur);
        }

        start = found + sep_size;
    }
    return splits;
}
strview *str_split(const strview str, const char *sep) {
    //TODO: Test needed
    strview *splits = arr_init(strview);

    size_t sep_size = strlen(sep);
    strview start = str;
    const char *found = str.ptr;

    while ((found = strviewstr(start, sep))) {
        size_t size = (found - start.ptr);
        if (size > 0) {
            strview cur = (strview) {start.ptr, size};
            arr_push(splits, cur);
        }

        start.ptr = found + sep_size;
        start.size -= size + sep_size;
    }

    if (start.size > 0) {
        arr_push(splits, start);
    }

    return splits;
}

void chr_split_once(const char *str, const char *sep, strview *first, strview *rest) {
    //TODO: Test needed
    size_t sep_size = strlen(sep);
    size_t str_size = strlen(str);

    if (first != NULL) {
        *first = (strview) {str, 0};
    }
    if (rest != NULL) {
        *rest = (strview) {str, 0};
    }

    char *found = strstr(str, sep);
    size_t diff = found - str;
    if (found != NULL) {
        if (first != NULL) {
            *first = (strview) { str, diff };
        }
        if (rest != NULL) {
            *rest = (strview) { &str[diff + sep_size], str_size - diff - sep_size };
        }
    }
}
void str_split_once(strview str, const char *sep, strview *first, strview *rest) {
    size_t sep_size = strlen(sep);

    if (first != NULL) {
        *first = str;
    }
    if (rest != NULL) {
        *rest = str;
    }

    const char *found = strviewstr(str, sep);
    size_t diff = found - str.ptr;
    if (found != NULL) {
        if (first != NULL) {
            *first = (strview) { str.ptr, diff };
        }
        if (rest != NULL) {
            *rest = (strview) { &str.ptr[diff + sep_size], str.size - diff - sep_size };
        }
        return;
    }
}

/*
std::vector<char*> split_char(char *str, const std::string &separator) {
    std::vector<char*> tokens;
    char *found = str;

    while((found = strstr(str, separator.c_str()))) {
        tokens.push_back(str);
        str = found;
        for (int i = 0; i < separator.size(); i++) {
            found[i] = '\0';
            str++;
        }
    }

    tokens.push_back(str);

    auto end = std::remove_if(tokens.begin(), tokens.end(), [](char *val){ return strlen(val) == 0; });
    return { tokens.begin(), end };
}

void split_once(char *str, const std::string &separator, char **first, char **rest) {
    *first = strtok_s(str, separator.c_str(), rest);
    for (int i = 0; i < separator.size() - 1; i++) { (*rest)++; }
}

}
*/
