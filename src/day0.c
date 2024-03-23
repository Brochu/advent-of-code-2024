#include "day.h"
#include "darray.h"
#include "parsing.h"
#include "strview.h"

#include <stdio.h>
#include <stdlib.h>

#define DEMO 1
#if DEMO == 1 // ------------------------------------
#define FILE_PATH ".\\inputs\\day0_demo.txt"
#else // ------------------------------------
#define FILE_PATH ".\\inputs\\day0.txt"
#endif // ------------------------------------

size_t stride = 0;
int *grid = 0;

int part1(char *out) {
    sprintf_s(out, RES_MAX_LENGTH, "%d", 0);
    return 0;
}

int part2(char *out) {
    sprintf_s(out, RES_MAX_LENGTH, "%d", 0);
    return 0;
}


int run(char *part1_out, char *part2_out) {
    char *in = read_file(FILE_PATH);

    strview *lines = chr_split(in, "\n");
    stride = arr_size(lines);
    grid = calloc(stride * stride, sizeof(int));

    for (int i = 0; i < arr_size(lines); i++) {
        strview *nodes = str_split(lines[i], ", ");
        for (int j = 0; j < arr_size(nodes); j++) {
            printf("'%.*s'", (int)nodes[j].size, nodes[j].ptr);
            grid[j + (i * stride)] = atoi(nodes[j].ptr);
        }
        printf("\n");
    }

    for (int i = 0; i < stride * stride; i++) {
        printf("arr[%i] = %i\n", i, grid[i]);
    }

    part1(part1_out);
    part2(part2_out);

    free(grid);
    free(in);
    return 0;
}
