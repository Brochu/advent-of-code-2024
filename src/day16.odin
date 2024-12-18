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
};

@(private="file")
Node :: struct {
    pos: Vec2,
    score: int,
};

d16run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    lines := strings.split_lines(input);
    DIM = len(lines)
    grid := transmute([]u8)strings.join(lines, "");

    start, end: Vec2;
    for cell, i in grid {
        if cell == 'S' do start = { i%DIM, i/DIM };
        else if cell == 'E' do end = { i%DIM, i/DIM };
    }
    fmt.printfln("From %v to %v", start, end);

    parents := make(map[Vec2]Vec2, len(grid));
    parents[start] = { -1, -1 };
    scores := make(map[Vec2]int, len(grid));
    scores[start] = 0;

    q: pq.Priority_Queue(Node);
    pq.init(&q, proc (l, r: Node) -> bool {
        return l.score < r.score;
    }, pq.default_swap_proc(Node));
    pq.push(&q, Node { start, scores[start] });

    for pq.len(q) > 0 {
        curr := pq.pop(&q);
        fmt.printfln("    %v", curr);
    }

    strings.write_int(p1, 16);
    strings.write_int(p2, 16);

    /*
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
    */
}
