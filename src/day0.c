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

strview part1() {
    return (strview) { "NotCompleted", 12 };
}

strview part2() {
    return (strview) { "NotCompleted", 12 };
}


int run(strview *part1_out, strview *part2_out) {
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

    *part1_out = part1();
    *part2_out = part2();

    free(in);
    return 0;
}
