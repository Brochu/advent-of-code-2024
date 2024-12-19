package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day19.ex" when EXAMPLE else "../data/day19.in"

d19run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    elems := strings.split(input, "\n\n");

    towels := make([dynamic]string, 0, 512);
    for towel in strings.split_iterator(&elems[0], ", ") do append(&towels, towel);
    fmt.printfln("TOWELS: %v", towels);

    designs := make([dynamic]string, 0, 512);
    for design in strings.split_lines_iterator(&elems[1]) do append(&designs, design);
    fmt.println("DESIGNS:");
    for d in designs {
        fmt.printfln("    '%v'", d);
    }

    //TODO: Implement TRIE structure to find possible continuations
    strings.write_string(p1, "D19 - P1");
    strings.write_string(p2, "D19 - P2");

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
