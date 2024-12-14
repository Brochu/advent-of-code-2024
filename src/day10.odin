package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day10.ex" when EXAMPLE else "../data/day10.in"

@(private="file")
DIM := 0;

d10run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    lines := strings.split_lines(input);
    grid := transmute([]u8)strings.join(lines, "");
    DIM = len(lines);

    strings.write_int(p1, 0);
    strings.write_int(p2, 0);

    xoff := 300 when EXAMPLE else 30;
    yoff := 300 when EXAMPLE else 30;
    spacing := 50 when EXAMPLE else 19;
    font := c.int(25) when EXAMPLE else c.int(10);
    sb, _ := strings.builder_make_none();
    rl.InitWindow(1000, 1000, strings.to_cstring(&title));
    rl.SetTargetFPS(60);
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);
        for y in 0..<DIM {
            for x in 0..<DIM {
                idx := (y * DIM) + x;

                fmt.sbprintf(&sb, "%c", grid[idx]);
                rl.DrawText(strings.to_cstring(&sb),
                    c.int(x * spacing + xoff), c.int(y * spacing + yoff),
                    font, rl.WHITE);
                strings.builder_reset(&sb);
            }
        }

        rl.EndDrawing();
    }
    rl.CloseWindow();
}
