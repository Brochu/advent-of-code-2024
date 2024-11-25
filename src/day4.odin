package main
import "core:c"
import "core:fmt"
import "core:strings"
import "core:strconv"
import rl "vendor:raylib"

when EXAMPLE {
    @(private="file") input_file :: "../data/day4.example"
}
else {
    @(private="file") input_file :: "../data/day4.input"
}

@(private="file")
Pair :: struct {
    e0min : int,
    e0max : int,
    e1min : int,
    e1max : int,
}

d4run :: proc () {
    input :: string(#load(input_file));

    lines := strings.split_lines(input[:len(input)-1]); // ARK
    defer delete(lines);

    pairs := make([]Pair, len(lines));
    defer delete(pairs);

    for line, i in lines {
        mid := strings.index(line, ",");
        fmid := strings.index(line[:mid], "-");
        pairs[i].e0min = strconv.atoi(line[:fmid]);
        pairs[i].e0max = strconv.atoi(line[fmid+1:mid]);

        smid := strings.index(line[mid+1:], "-");
        pairs[i].e1min = strconv.atoi(line[mid+1:][:smid]);
        pairs[i].e1max = strconv.atoi(line[mid+1:][smid+1:]);
    }

    yoffset := 25;
    yspace := 65;
    zoom := 10;
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        for pair, i in pairs {
            y := c.int(yoffset + (i*yspace));
            width := c.int(pair.e0max*zoom - pair.e0min*zoom) + 1;
            height := c.int(15);
            rl.DrawRectangle(c.int(pair.e0min*zoom), y, width, height, rl.RED);

            width = c.int(pair.e1max*zoom - pair.e1min*zoom) + 1;
            rl.DrawRectangle(c.int(pair.e1min*zoom), y+16, width, height, rl.GREEN);
        }

        rl.EndDrawing();
    }
}
