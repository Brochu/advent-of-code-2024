#pragma once
#include "strview.h"

char *read_file(const char *path);

strview *chr_split(const char *str, const char *sep);
strview *str_split(const strview str, const char *sep);

void chr_split_once(const char *str, const char *sep, strview *first, strview *rest);
void str_split_once(strview str, const char *sep, strview *first, strview *rest);
