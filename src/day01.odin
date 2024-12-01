package main
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

when EXAMPLE {
    @(private="file") input_file :: "../data/day1.ex"
}
else {
    @(private="file") input_file :: "../data/day1.in"
}

d1run :: proc () {
    //input := #load(input_file);

    rl.InitWindow(800, 600, strings.to_cstring(&title));
    rl.SetTargetFPS(60);

    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        rl.EndDrawing();
    }
    rl.CloseWindow();
}
