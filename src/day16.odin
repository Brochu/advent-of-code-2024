package main
import "core:c"
import pq"core:container/priority_queue"
import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

MAX_INT :: 9223372036854775807;

@(private="file")
input_file :: "../data/day16.ex" when EXAMPLE else "../data/day16.in"

@(private="file")
DIM := 0;

@(private="file")
Colors: map[u8]rl.Color = {
    'S' = rl.RED,
    'E' = rl.GREEN,
    '#' = rl.SKYBLUE,
    '.' = rl.GRAY,
    '*' = rl.YELLOW,
};

Direction :: enum { Up, Left, Right, Down };
Dirs: [Direction]Vec2 = {
    .Up = DIRS[1],
    .Left = DIRS[3],
    .Right = DIRS[4],
    .Down = DIRS[6],
};

@(private="file")
check := make(map[int]Phantom);

d16run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    lines := strings.split_lines(input);
    DIM = len(lines)
    grid := transmute([]u8)strings.join(lines, "");

    start, end: int;
    vel: Vec2 = { 0, 0 };
    for cell, i in grid {
        if cell == 'S' do start = i;
        else if cell == 'E' do end = i;

        check[i] = {};
    }
    //fmt.printfln("From %v to %v", start, end);
    //fmt.printfln("[%v] check %v", len(check), check);

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
        pos := Vec2 { idx % DIM, idx / DIM };
        //fmt.printfln("[Q] visiting %v -> %v", idx, pos);
        delete_key(&check, idx);

        for n in find_next(grid, idx) {
            alt := dist[idx] + 1; // 1 for now, check turns later
            if alt < dist[n] {
                dist[n] = alt;
                prev[n] = idx;

                pq.push(&q, n);
            }
        }
    }
    fmt.printfln("COMPLETE! %v ; Score = %v", Vec2 { end % DIM, end / DIM }, dist[end]);

    curr := end;
    for prev[curr] != start {
        grid[prev[curr]] = '*';
        curr = prev[curr];
    }

    strings.write_int(p1, 16);
    strings.write_int(p2, 16);

    off: c.int : 2 when EXAMPLE else 25;
    spacing: c.int : 60 when EXAMPLE else 6;
    minus: c.int : 5 when EXAMPLE else 1;
    time :: 5 when EXAMPLE else 1;
    fnum := 0;
    rl.InitWindow(900, 900, strings.to_cstring(&title));
    rl.SetTargetFPS(60);
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        for y in 0..<DIM do for x in 0..<DIM {
            idx := (y * DIM) + x;
            xpos, ypos := c.int(x) * spacing, c.int(y) * spacing;
            char := grid[idx];

            rl.DrawRectangleLines(xpos + off, ypos + off, spacing-minus, spacing-minus, Colors[char]);
        }

        rl.EndDrawing();
    }
    rl.CloseWindow();
}

@(private="file")
less_proc :: proc (l, r: int) -> bool {
    dist := (cast(^[]int)context.user_ptr)^;
    return dist[l] < dist[r];
}

@(private="file")
find_next :: proc(grid: []u8, idx: int) -> []int {
    res := make([dynamic]int, 0, 4);

    pos := Vec2 { idx % DIM, idx / DIM };
    for d in Dirs {
        target := pos + d;
        tidx := (target.y * DIM) + target.x;

        if _, ok := check[tidx]; ok && grid[tidx] != '#' {
            append(&res, tidx);
        }
    }
    return res[:];
}
