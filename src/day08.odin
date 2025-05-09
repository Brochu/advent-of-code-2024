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
    antis_p1 := make(map[int]Phantom);
    antis_p2 := make(map[int]Phantom);

    parse_grid(grid, &nodes, &antis_p2);
    //fmt.printfln("[%v] NODES", len(nodes));
    for k, v in nodes {
        //fmt.printfln("[%v] - %v", rune(k), v);

        for i in 0..<len(v) {
            for j in i+1..<len(v) {
                diff := v[j] - v[i];

                valid_0 := true;
                valid_1 := true;
                for mult := 1; valid_0 || valid_1; mult += 1 {
                    a0 := v[i] - (diff * mult);
                    valid_0 = (a0.x >= 0 && a0.x < DIM) && (a0.y >= 0 && a0.y < DIM);
                    if valid_0 {
                        if mult == 1 do antis_p1[(a0.y * DIM) + a0.x] = {};
                        antis_p2[(a0.y * DIM) + a0.x] = {}
                    }
                    a1 := v[j] + (diff * mult);
                    valid_1 = (a1.x >= 0 && a1.x < DIM) && (a1.y >= 0 && a1.y < DIM);
                    if valid_1 {
                        if mult == 1 do antis_p1[(a1.y * DIM) + a1.x] = {};
                        antis_p2[(a1.y * DIM) + a1.x] = {}
                    }
                    //fmt.printfln(" - %v vs. %v = %v -> %v ; %v", v[i], v[j], diff, a0, a1);
                }
                //REMINDER: Store placed antis per node combo for visuals
            }
        }
    }

    strings.write_int(p1, len(antis_p1));
    strings.write_int(p2, len(antis_p2));

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
parse_grid :: proc (grid: []u8, nodes: ^map[u8][dynamic]Vec2, antis_p2: ^map[int]Phantom) {
    for c, i in grid {
        x := i % DIM;
        y := i / DIM;
        if c != '.' {
            if _, ok := nodes[c]; !ok do nodes[c] = make([dynamic]Vec2);
            append(&nodes[c], Vec2{ x, y });
            antis_p2[i] = {};
        }
    }
}
