package main
import "core:c"
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day09.ex" when EXAMPLE else "../data/day09.in"

d9run :: proc (p1, p2: ^strings.Builder) {
    input := transmute([]u8)strings.trim(#load(input_file, string) or_else "", "\r\n");
    for c, i in input {
        // This needs to store values higher for actual inputs, more than 255 files?
        id := rune('.') if i % 2 == 1 else rune('0'+(i/2));
        size := c - '0';

        for _ in 0..<size {
            fmt.printf("%v", id);
        }
    }
    //Reminder: store free spaces in some sort of queue? want to easily get the next empty spot
    // Probably something similar for file blocks
    fmt.println("\n-----------");

    strings.write_int(p1, 1);
    strings.write_int(p2, 2);

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
