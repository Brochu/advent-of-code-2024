package main
import "core:c"
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day03.ex" when EXAMPLE else "../data/day03.in"

d3run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(string(#load(input_file)), "\r\n");
    lines := strings.split_lines(input);
    fmt.printfln("[%v]\n%v", len(lines), lines);

    /*
    rl.InitWindow(800, 600, strings.to_cstring(&title));
    rl.SetTargetFPS(60);

    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        rl.EndDrawing();
    }
    rl.CloseWindow();
    */

    strings.write_string(p1, "In progress...");
    strings.write_string(p2, "In progress...");
}
