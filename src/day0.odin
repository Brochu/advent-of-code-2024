package main
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

when EXAMPLE {
    @(private="file") input_file :: "../data/day0.example"
}
else {
    @(private="file") input_file :: "../data/day0.input"
}

d0run :: proc () {
    //input := #load(input_file);
    // INIT

    rl.InitWindow(800, 600, strings.to_cstring(&title));
    rl.SetTargetFPS(60);

    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);
        // ANIMS
        rl.EndDrawing();
    }

    rl.CloseWindow();
}
