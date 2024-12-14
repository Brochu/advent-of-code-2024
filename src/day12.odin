package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day12.ex" when EXAMPLE else "../data/day12.in"

@(private="file")
DIM := 0;

@(private="file")
Region :: struct {
    char: u8,
    area: int,
    peri: int,
    plots: [dynamic]int,
};

d12run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    lines := strings.split_lines(input);
    grid := transmute([]u8)strings.join(lines, "");
    DIM = len(lines);

    regions := make([dynamic]Region);
    visited := make(map[int]Phantom);
    append(&regions, flood_fill(99, grid, &visited));
    append(&regions, flood_fill(21, grid, &visited));
    print_state(regions[:], visited);

    strings.write_string(p1, "Upcoming...");
    strings.write_string(p2, "Upcoming...");

    xoff := 250 when EXAMPLE else 10;
    yoff := 250 when EXAMPLE else 10;
    spacing := 50 when EXAMPLE else 7;
    font := c.int(25) when EXAMPLE else c.int(5);
    sb, _ := strings.builder_make_none();
    rl.InitWindow(1000, 1000, strings.to_cstring(&title));
    rl.SetTargetFPS(60);
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();

        rl.ClearBackground(rl.BLACK);
        for y in 0..<DIM {
            for x in 0..<DIM {
                idx := (y * DIM) + x;
                col := rl.WHITE;
                if _, ok := visited[idx]; ok {
                    col = rl.BLUE;
                }

                fmt.sbprintf(&sb, "%c", grid[idx]);
                rl.DrawText(strings.to_cstring(&sb),
                    c.int(x * spacing + xoff), c.int(y * spacing + yoff),
                    font, col);
                strings.builder_reset(&sb);
            }
        }
        rl.EndDrawing();
    }
    rl.CloseWindow();
}

print_state :: proc(regions: []Region, visited: map[int]Phantom) {
    fmt.println("REGIONS:");
    for r in regions {
        fmt.printfln("    [%c] -> %v", r.char, r.plots);
    }
    fmt.println("VISITED:");
    fmt.print("    ");
    for v in visited {
        fmt.printf("%v, ", v);
    }
    fmt.println();
    fmt.println();
}

grid_get :: proc(grid: []u8, pos: Vec2) -> u8 {
    if (pos.x < 0 || pos.x >= DIM) || (pos.y < 0 || pos.y >= DIM) { return 0; }
    else do return grid[(pos.y * DIM) + pos.x];
}

flood_fill :: proc(sidx: int, grid: []u8, visited: ^map[int]Phantom) -> Region {
    DIRS := DIRS;
    region: Region = {
        grid[sidx],
        0,
        0,
        make([dynamic]int, 0, len(grid)),
    }
    stack := make([dynamic]int, 0, len(grid));
    append(&stack, sidx);

    for len(stack) > 0 {
        i := pop_front(&stack);
        if _, ok := visited[i]; ok do continue;

        append(&region.plots, i);
        visited[i] = {};
        curr := Vec2 { i % DIM, i / DIM };

        fmt.printfln("VISITING [%2.v] -> %v : %v", i, grid_get(grid, curr), curr);
        for d in Dir {
            pos := curr + DIRS[d];
            if letter := grid_get(grid, pos); letter == region.char {
                nidx := (pos.y * DIM) + pos.x;
                fmt.printfln("    N [%2.v] -> %v : %v", nidx, grid_get(grid, pos), pos);
                append(&stack, nidx);
            }
        }
    }
    return region;
}
