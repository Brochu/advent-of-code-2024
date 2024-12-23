package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day23.ex" when EXAMPLE else "../data/day23.in"

d23run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    fmt.println(input);

    strings.write_string(p1, "Upcoming...");
    strings.write_string(p2, "Upcoming...");

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
}
