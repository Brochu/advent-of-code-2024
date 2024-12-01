package main
import "core:fmt"
import "core:math"
import "core:slice"
import "core:slice/heap"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

when EXAMPLE {
    @(private="file") input_file :: "../data/day01.ex"
}
else {
    @(private="file") input_file :: "../data/day01.in"
}

d1run :: proc () {
    input := strings.trim(string(#load(input_file)), "\r\n");

    lines, _ := strings.split_lines(input);
    defer delete(lines);

    first := make([]int, len(lines));
    second := make([]int, len(lines));
    defer delete(first);
    defer delete(second);

    for line, i in lines {
        pos := 0;
        l, _ := strconv.parse_int(line[pos:], 10, &pos);
        r, _ := strconv.parse_int(line[pos+3:], 10, &pos);

        first[i] = l;
        second[i] = r;
    }
    heap.make(first, comp);
    heap.make(second, comp);

    total := 0;
    last := len(first)-1;
    for last >= 0 {
        heap.pop(first[:last], comp);
        heap.pop(second[:last], comp);

        l := first[last];
        r := second[last];
        diff := math.abs(l - r);
        total += diff;
        //fmt.printfln("'%v' - '%v' = '%v'", l, r, diff);

        last -= 1;
    }
    fmt.printfln("\tPART 1 = %v", total);

    // Reset the heaps
    heap.make(first, comp);
    heap.make(second, comp);

    curr := len(second)-1;
    for !slice.is_empty(first) {
        heap.pop(first, comp);
        l := first[len(first)-1];
        first = first[:len(first)-1];

        fmt.printfln("l = %v", l);
        //TODO: Find matching and count, when done, next l value
    }

    p2 := 0;
    fmt.printfln("\tPART 2 = %v", p2);
}

@(private="file")
comp :: proc (a: int, b: int) -> bool {
    return a > b;
}
