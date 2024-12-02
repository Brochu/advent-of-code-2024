package main
import "core:c"
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

d1run :: proc (p1, p2: ^strings.Builder) {
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
    strings.write_int(p1, total);

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
    strings.write_int(p2, simlevel);

    heap.make(first, comp);
    heap.sort(first, comp);
    slice.reverse(first);
    heap.make(second, comp);
    heap.sort(second, comp);
    slice.reverse(second);

    time := 1;
    fnum := 0;
    rl.InitWindow(800, 600, strings.to_cstring(&title));
    rl.SetTargetFPS(60);

    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);
        curr := fnum/time;

        for vi, i in curr..<len(lines) {
            y := c.int(25 + (i * 25));
            rl.DrawText(rl.TextFormat("%v -- %v", first[vi], second[vi]), 100, y, 20, rl.BLUE);
        }

        if curr > 0 {
            rl.DrawText(rl.TextFormat("%v -- %v", first[curr-1], second[curr-1]), 350, 25, 40, rl.GREEN);
            rl.DrawText(rl.TextFormat("%v", math.abs(first[curr-1] - second[curr-1])), 350, 75, 40, rl.RED);
        }

        rl.DrawText(rl.TextFormat("%v", fnum), 25, 575, 5, rl.WHITE);

        rl.EndDrawing();
        fnum = math.clamp(fnum+1, 0, time*len(lines));
    }
    rl.CloseWindow();
}

@(private="file")
comp :: proc (a: int, b: int) -> bool {
    return a > b;
}
