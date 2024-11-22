package main
import "core:fmt"
import "core:strings"

d3run :: proc (p1, p2: ^strings.Builder) {
    when 2 == 1 { input :: #load("../data/day3.example") }
    else { input :: #load("../data/day3.input") }
    lines := strings.split_lines(string(input));
    defer delete(lines);

    part1(lines, p1);
    part2(lines, p2);

    // Cleanup
}

@(private="file")
part1 :: proc (lines: []string, out: ^strings.Builder) {
    total := 0;
    for l in lines {
        str := transmute([]byte)l;
        set := make([]bool, ('z'+1));
        defer delete(set);

        for i in 0..=len(str)/2-1 {
            set[str[i]] = true;
        }


        res := 0;
        for i in len(str)/2..=len(str) {
            if set[str[i]] {
                res = i;
                break;
            }
        }
        if str[res] <= 'Z' {
            total += int((str[res] - 'A') + 27);
            //fmt.printfln("index = %v -> %v | %v", res, rune(str[res]), (str[res] - 'A') + 27);
        } else {
            total += int(str[res] - ('a' - 1));
            //fmt.printfln("index = %v -> %v | %v", res, rune(str[res]), str[res] - ('a' - 1));
        }
    }

    strings.write_int(out, total, 10);
}

@(private="file")
part2 :: proc (lines: []string, out: ^strings.Builder) {
    strings.write_int(out, 15, 16);
}
