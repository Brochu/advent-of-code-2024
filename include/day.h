#pragma once
#define RES_MAX_LENGTH 1024
#define print_res(out, fmt, ...) sprintf_s(out, RES_MAX_LENGTH, fmt, __VA_ARGS__)

int run(char *part1_out, char *part2_out);
