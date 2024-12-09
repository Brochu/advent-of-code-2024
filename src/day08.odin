package main
import "core:c"
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day08.ex" when EXAMPLE else "../data/day08.in"

d8run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    fmt.println(input);

    rl.InitWindow(800, 600, strings.to_cstring(&title));
    rl.SetTargetFPS(60);

    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        rl.EndDrawing();
    }
    rl.CloseWindow();

    strings.write_int(p1, 1);
    strings.write_int(p2, 2);
}
