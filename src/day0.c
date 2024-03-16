#include "day.h"
#include "darray.h"
#include "parsing.h"
#include "strview.h"

#include <stdio.h>
#include <stdlib.h>

#define DEMO 1
#if DEMO == 1 // ------------------------------------
//#define FILE_PATH ".\\inputs\\day0_demo1.txt"
#define FILE_PATH ".\\inputs\\file.txt"
#else // ------------------------------------
#define FILE_PATH ".\\inputs\\day0.txt"
#endif // ------------------------------------

int part1(char *out) {
    sprintf_s(out, 1024, "NotCompleted : %d", 42);
    return 0;
}

int part2(char *out) {
    sprintf_s(out, 1024, "NotCompleted : %d", 69);
    return 0;
}


int run(char *part1_out, char *part2_out) {
    char *in = read_file(FILE_PATH);
    printf("%s\n", in);

    strview *lines = chr_split(in, "\n");
    for (int i = 0; i < arr_size(lines); i++) {
        strview first;
        strview rest;
        str_split_once(lines[i], ": ", &first, &rest);
        printf("Contents '%.*s':\n", (int)first.size, first.ptr);

        strview *elems = str_split(rest, "; ");
        for (int j = 0; j < arr_size(elems); j++) {
            printf("- '%.*s'\n", (int)elems[j].size, elems[j].ptr);
        }
        printf("\n");
    }

    part1(part1_out);
    part2(part2_out);

    free(in);
    return 0;
}
