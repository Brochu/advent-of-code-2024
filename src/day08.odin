package main
import "core:c"
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day08.ex" when EXAMPLE else "../data/day08.in"

@(private="file")
DIM := 0;

d8run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    lines := strings.split_lines(input);
    DIM = len(lines);

    grid := transmute([]u8)strings.join(lines, "");
    nodes := make(map[u8][dynamic]Vec2);
    antis := make(map[int]Phantom);

    parse_grid(grid, &nodes);
    fmt.printfln("[%v] NODES", len(nodes));
    for k, v in nodes {
        fmt.printfln("[%v] - %v", rune(k), v);

        for i in 0..<len(v) {
            for j in i+1..<len(v) {
                fmt.printfln(" - %v vs. %v", v[i], v[j]);
            }
        }
    }

    strings.write_int(p1, len(antis));
    strings.write_string(p2, "Upcoming");

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

@(private="file")
show_grid :: proc (grid: []u8, anti: map[int]Phantom) {
    for y in 0..<DIM {
        for x in 0..<DIM {
            idx := (y * DIM) + x;
            if grid[idx] == '.' && idx in anti {
                fmt.print("# ");
            }
            else {
                fmt.printf("%v ", rune(grid[idx]));
            }
        }
        fmt.println();
    }
}

@(private="file")
parse_grid :: proc (grid: []u8, nodes: ^map[u8][dynamic]Vec2) {
    show_grid(grid, {});
    for c, i in grid {
        x := i % DIM;
        y := i / DIM;
        if c != '.' {
            if _, ok := nodes[c]; !ok do nodes[c] = make([dynamic]Vec2);
            append(&nodes[c], Vec2{ x, y });
        }
    }
}
