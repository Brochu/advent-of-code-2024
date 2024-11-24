package main
import "core:fmt"
import "core:strings"
import "core:strconv"

Pair :: struct {
    e0min : int,
    e0max : int,
    e1min : int,
    e1max : int,
}

d4run :: proc (p1, p2: ^strings.Builder) {
    when 1 == 1 { input :: #load("../data/day4.example") }
    else { input :: #load("../data/day4.input") }

    pairs := make([dynamic]Pair);
    defer delete(pairs);

    strin := string(input);
    lines := strings.split_lines(strin[:len(strin)-1]); // ARK
    defer delete(lines);

    for line in lines {
        p : Pair;
        mid := strings.index(line, ",");
        fmid := strings.index(line[:mid], "-");
        p.e0min = strconv.atoi(line[:fmid]);
        p.e0max = strconv.atoi(line[fmid+1:mid]);

        smid := strings.index(line[mid+1:], "-");
        p.e1min = strconv.atoi(line[mid+1:][:smid]);
        p.e1max = strconv.atoi(line[mid+1:][smid+1:]);
        append(&pairs, p);
    }

    part1(pairs[:], p1);
    part2(pairs[:], p2);
}

@(private="file")
part1 :: proc (pairs: []Pair, out: ^strings.Builder) {
    fmt.printfln("%v", pairs);
    strings.write_u64(out, 1);
}

@(private="file")
part2 :: proc (pairs: []Pair, out: ^strings.Builder) {
    strings.write_u64(out, 2);
}
