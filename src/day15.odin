package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day15.ex" when EXAMPLE else "../data/day15.in"

@(private="file")
DIM := 0;

@(private="file")
Colors: map[u8]rl.Color = {
    '#' = rl.SKYBLUE,
    'O' = rl.YELLOW,
    '@' = rl.GREEN,
    '.' = rl.GRAY,
};

d15run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    elems := strings.split(input, "\n\n");

    lines := strings.split_lines(elems[0]);
    DIM = len(lines);
    grid := transmute([]u8)strings.join(lines, "");

    strings.write_int(p1, 15);
    strings.write_int(p2, 15);

    xoff, yoff: c.int : 2, 2;
    spacing: c.int : 80 when EXAMPLE else 16;
    rl.InitWindow(800, 800, strings.to_cstring(&title));
    rl.SetTargetFPS(60);
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        for y in 0..<DIM do for x in 0..<DIM {
            idx := (y * DIM) + x;
            xpos, ypos := c.int(x) * spacing, c.int(y) * spacing;
            char := grid[idx];

            rl.DrawRectangleLines(xpos + xoff, ypos + yoff, spacing-5, spacing-5, Colors[grid[idx]]);
        }

        rl.EndDrawing();
    }
    rl.CloseWindow();
}
