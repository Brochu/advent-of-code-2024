#include "parsing.h"
#include "darray.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>


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
    //TODO: Impl split str at each instance of sep
    return 0;
}

void chr_split_once(const char *str, const char *sep, strview *first, strview *rest) {
    //TODO: Impl split on first instance of sep in str
    first = 0;
    rest = 0;
}
void str_split_once(strview str, const char *sep, strview *first, strview *rest) {
    size_t sep_size = strlen(sep);

    if (first != NULL) {
        *first = str;
    }
    if (rest != NULL) {
        *rest = str;
    }

    for (int i = 0; i < str.size; i++) {
        if (str.ptr[i] == sep[0] && memcmp(&str.ptr[i], sep, sep_size) == 0) {
            if (first != NULL) {
                *first = (strview) { str.ptr, i };
            }
            if (rest != NULL) {
                *rest = (strview) { &str.ptr[i + sep_size], str.size - i - sep_size };
            }
            return;
        }
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
