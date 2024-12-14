package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day10.ex" when EXAMPLE else "../data/day10.in"

@(private="file")
DIM := 0;

@(private="file")
TrailState :: struct {
    num: u8,
    idx: int,
    root: int,
    cells: [dynamic]int,
};

@(private="file")
Trail :: struct {
    start: int,
    cells: [dynamic]int,
};

d10run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    lines := strings.split_lines(input);
    grid := transmute([]u8)strings.join(lines, "");
    DIM = len(lines);

    stack := make([dynamic]TrailState, 0, len(grid));
    for cell, i in grid {
        if cell == '0' {
            append(&stack, TrailState { '0', i, i, {i} });
            break;
        }
    }
    //fmt.printfln("STACK: %v", stack);

    trails := make([dynamic]Trail, 0, len(grid));
    for len(stack) > 0 {
        DIRS := DIRS;
        state := pop_front(&stack);
        pos := Vec2 { state.idx % DIM, state.idx / DIM };
        fmt.printfln("-> %v (%c)", state, state.num);
        fmt.printfln("    POS %v", pos);
        for d in Dir {
            curr := pos + DIRS[d];
            idx := (curr.y * DIM) + curr.x;
            fmt.printfln("    CURR [%v] %v -> %c", d, curr, grid_get(grid, curr));

            if grid_get(grid, curr) == state.num + 1 {
                ts := TrailState { state.num + 1, idx, state.root, state.cells };
                append(&ts.cells, idx);
                append(&stack, ts);
            }
        }
        break;
    }
    fmt.println("STACK:");
    for s in stack {
        fmt.printfln("    -%v", s);
    }
    fmt.println("TRAILS:");
    for trail in trails {
        fmt.printfln("    -%v", trail);
    }

    strings.write_int(p1, 0);
    strings.write_int(p2, 0);

    /*
    xoff := 300 when EXAMPLE else 30;
    yoff := 300 when EXAMPLE else 30;
    spacing := 50 when EXAMPLE else 19;
    font := c.int(25) when EXAMPLE else c.int(10);
    sb, _ := strings.builder_make_none();
    rl.InitWindow(1000, 1000, strings.to_cstring(&title));
    rl.SetTargetFPS(60);
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);
        for y in 0..<DIM {
            for x in 0..<DIM {
                idx := (y * DIM) + x;

                fmt.sbprintf(&sb, "%c", grid[idx]);
                rl.DrawText(strings.to_cstring(&sb),
                    c.int(x * spacing + xoff), c.int(y * spacing + yoff),
                    font, rl.WHITE);
                strings.builder_reset(&sb);
            }
        }

        rl.EndDrawing();
    }
    rl.CloseWindow();
    */
}

@(private="file")
grid_get :: proc(grid: []u8, pos: Vec2) -> u8 {
    if (pos.x < 0 || pos.x >= DIM) || (pos.y < 0 || pos.y >= DIM) { return 0; }
    else do return grid[(pos.y * DIM) + pos.x];
}
