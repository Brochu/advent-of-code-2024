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
        heap.pop(first[:last+1], comp);
        heap.pop(second[:last+1], comp);

        l := first[last];
        r := second[last];
        diff := math.abs(l - r);
        total += diff;
        //fmt.printfln("'%v' - '%v' = '%v'", l, r, diff);

        last -= 1;
    }
    fmt.printfln("\tPART 1 = %v", total);

    // ---------------------------------------------------
    hash, _ := make(map[int]int);
    for r in second {
        hash[r] += 1;
    }
    //fmt.printfln("%v", hash);

    simlevel := 0
    for l in first {
        simlevel += hash[l] * l;
    }
    fmt.printfln("\tPART 2 = %v", simlevel);
}

@(private="file")
comp :: proc (a: int, b: int) -> bool {
    return a > b;
}
