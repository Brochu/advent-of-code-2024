package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day20.ex" when EXAMPLE else "../data/day20.in"

@(private="file")
DIM := 0;

@(private="file")
Colors: map[u8]rl.Color = {
    'S' = rl.RED,
    'E' = rl.GREEN,
    '#' = rl.SKYBLUE,
    '.' = rl.GRAY,
    '*' = rl.YELLOW,
};

/*
Code is basically the same for both parts. I use dfs to calcualte the original path and number of steps
from start to finish at each point along the way. I then walk the path and find the number of cheats to
other points in the path within a given manhattan distance between the two points. I then calculate the
savings for each pair of points by applying the cheat. I then count the number of cheats that achieve a
savings above the given threshold, 100. For Part 1, the manhattan distance is fixed at 2. For Part 2,
I loop from 2 to 20 and accumulate the number of cheats for a potential diamond of points for the given
manhattan distance of each iteration.
*/
d20run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    lines := strings.split_lines(input);
    DIM = len(lines);
    grid := transmute([]u8)strings.join(lines, "");

    start, end := 0, 0;
    for cell, i in grid {
        if cell == 'S' do start = i;
        else if cell == 'E' do end = i;
    }
    //fmt.printfln("[START] (%v) %v", start, Vec2 { start % DIM, start / DIM });
    //fmt.printfln("[END]   (%v) %v", end, Vec2 { end % DIM, end / DIM });

    strings.write_int(p1, 20);
    strings.write_int(p2, 20);

    off: c.int : 5 when EXAMPLE else 50;
    spacing: c.int : 53 when EXAMPLE else 5;
    minus: c.int : 5 when EXAMPLE else 1;
    time :: 5 when EXAMPLE else 1;
    fnum := 0;
    rl.InitWindow(800, 800, strings.to_cstring(&title));
    rl.SetTargetFPS(60);
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        for y in 0..<DIM do for x in 0..<DIM {
            xpos := off + (spacing * c.int(x));
            ypos := off + (spacing * c.int(y));
            idx := (y * DIM) + x;

            rl.DrawRectangleLines(xpos, ypos, spacing-minus, spacing-minus, Colors[grid[idx]]);
        }

        rl.EndDrawing();
    }
    rl.CloseWindow();
}
