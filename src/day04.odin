package main
import "core:c"
import "core:container/queue"
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day04.ex" when EXAMPLE else "../data/day04.in"

Vec2 :: [2]int;

Letters :: enum  u8 { X = 'X', M = 'M', A = 'A', S = 'S' };
LSet :: bit_set[Letters];

Node :: struct {
    start: Vec2,
    dir: Vec2,
    progress: LSet,
}

DIM := 0;
get_idx :: proc(pos: Vec2) -> int {
    return (pos.y * DIM) + pos.x;
}
get_coords :: proc(idx: int) -> Vec2 {
    return Vec2 {
        idx % DIM,
        idx / DIM,
    };
}

d4run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    lines := strings.split_lines(input);
    DIM = len(lines);

    grid := transmute([]u8)strings.join(lines, "");
    for y in 0..<DIM {
        for x in 0..<DIM {
            idx := get_idx(Vec2 {x, y});
            //fmt.printf("%2v ", idx);
            fmt.printf("%v ", transmute(Letters)grid[idx]);
        }
        fmt.println();
    }

    Q: queue.Queue(u8);
    queue.init(&Q, DIM * DIM);
    for queue.len(Q) > 0 {
    }

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

    strings.write_int(p1, 4);
    strings.write_int(p2, 4);
}
