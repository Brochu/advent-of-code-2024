package main
import "core:c"
import pq"core:container/priority_queue"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day18.ex" when EXAMPLE else "../data/day18.in";

@(private="file")
bytes: [dynamic]Vec2;

@(private="file")
grid: map[Vec2]Phantom;

@(private="file")
check := make(map[int]Phantom);

@(private="file")
DIM :: 7 when EXAMPLE else 71;

@(private="file")
FALL_P1 :: 12 when EXAMPLE else 1024;

d18run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    for b in strings.split_lines_after(input) {
        elems := strings.split(b, ",");
        append(&bytes, Vec2 { strconv.atoi(elems[0]), strconv.atoi(elems[1]) });
    }
    //fmt.printfln("%v", bytes);

    grid := make(map[Vec2]Phantom);
    for b in bytes[0:FALL_P1] do grid[b] = {};
    for i in 0..<(DIM*DIM) do check[i] = {};
    start := 0;
    end := (DIM*DIM) - 1;

    dist := make([]int, len(grid));
    prev := make([]int, len(grid));
    slice.fill(prev, -1);
    slice.fill(dist, max(int));
    dist[start] = 0;

    context.user_ptr = &dist;
    q: pq.Priority_Queue(int);
    pq.init(&q, less_proc, pq.default_swap_proc(int));
    pq.push(&q, start);

    for pq.len(q) > 0 {
        idx := pq.pop(&q);
        //fmt.printfln("[Q] visiting %v -> %v", idx, pos);
        delete_key(&check, idx);

        for n in find_next(idx) {
            alt := dist[idx] + 1; // 1 for now, check turns later
            if alt < dist[n] {
                dist[n], prev[n] = alt, idx;
                pq.push(&q, n);
            }
        }
    }
    //fmt.printfln("COMPLETE! %v ; Score = %v", Vec2 { end % DIM, end / DIM }, dist[end]);

    strings.write_string(p1, "D18 - P1");
    strings.write_string(p2, "D18 - P2");

    spacing: c.int : 114 when EXAMPLE else 10;
    diff: c.int : 5 when EXAMPLE else 1;
    off: c.int : 2 when EXAMPLE else 40;
    rl.InitWindow(800, 800, strings.to_cstring(&title));
    rl.SetTargetFPS(60);
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        for y in 0..<DIM do for x in 0..<DIM {
            xpos := (c.int(x) * spacing) + off;
            ypos := (c.int(y) * spacing) + off;

            pos := Vec2 { x, y };
            idx := (y * DIM) + x;
            col := rl.WHITE;
            if pos in grid do col = rl.BLUE;
            if idx == 0 do col = rl.GREEN;
            if idx == (DIM*DIM)-1 do col = rl.RED;

            rl.DrawRectangleLines(xpos, ypos, spacing-diff, spacing-diff, col);
        }

        rl.EndDrawing();
    }
    rl.CloseWindow();
}

@(private="file")
find_next :: proc(idx: int) -> []int {
    res := make([dynamic]int, 0, 4);
    return res[:];
}
