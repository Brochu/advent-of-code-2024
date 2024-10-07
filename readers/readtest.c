#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int dimension;
    int length;
    int *grid;
} input_t;

int main(void) {
    printf("[MAIN] Test reading from PERL output\n");

    input_t in = { 0 };
    in.grid = malloc(sizeof(int) * in.length);

    fread(&in, sizeof(int), 2, stdin); 
    fread(in.grid, sizeof(int), in.length, stdin);

    printf("[MAIN] Read from stdin:\n");
    printf("[MAIN] Dimension: %i\n", in.dimension);
    printf("[MAIN] length: %i\n", in.length);
    for (int i = 0; i < in.dimension; ++i) {
        for (int j = 0; j < in.dimension; ++j) {
            size_t idx = (i * in.dimension) + j;
            printf("'%i'", in.grid[idx]);
        }
        printf("\n");
    }
    printf("[MAIN] done!\n");

    free(in.grid);
    return 0;
}
