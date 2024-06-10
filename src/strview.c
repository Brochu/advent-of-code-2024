#include "strview.h"

#include <stddef.h>
#include <string.h>

strview FromLitteral(const char *lit) {
    strview out = { .ptr = NULL, .size = strlen(lit) };
    return out;
}
strview FromCString(char *str) {
    strview out = { .ptr = str, .size = strlen(str) };
    return out;
}
