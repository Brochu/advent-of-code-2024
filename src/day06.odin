package main
import "core:c"
import "core:fmt"
import "core:math"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day06.ex" when EXAMPLE else "../data/day06.in"

@(private="file")
DIM := 0;

Dir :: enum u8 {
    Up    = 1,
    Left  = 3,
    Right = 4,
    Down  = 6,
};

Phantom :: struct {};

@(private="file")
guard_char :: proc(dir: Vec2) -> u8 {
    if dir == DIRS[Dir.Up] do return '^';
    else if dir == DIRS[Dir.Left] do return '<';
    else if dir == DIRS[Dir.Right] do return '>';
    else if dir == DIRS[Dir.Down] do return 'v';
    return '*';
}

@(private="file")
guard_turn :: proc(current: Dir) -> Dir {
    if current == .Up do return .Right;
    if current == .Right do return .Down;
    if current == .Down do return .Left;
    if current == .Left do return .Up;

    return .Up;
}

@(private="file")
find_dir :: proc(grid: []u8, pos: Vec2, dir: Dir) -> (Dir, bool) {
    DIRS := DIRS;
    dir := dir;

    t := (pos + DIRS[dir])
    if (t.x < 0 || t.x >= DIM) || (t.y < 0 || t.y >= DIM) do return .Up, false;

    tidx := (t.y * DIM) +  t.x;
    for grid[tidx] == '#' {
        dir = guard_turn(dir);
        t = (pos + DIRS[dir])
        if (t.x < 0 || t.x >= DIM) || (t.y < 0 || t.y >= DIM) do return .Up, false;

        tidx = (t.y * DIM) +  t.x;
    }
    return dir, true;
}

d6run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    //fmt.printfln("%v", input);
    lines := strings.split_lines(input);
    grid := transmute([]u8)strings.join(lines, "");
    DIM = len(lines);

    pos : Vec2;
    dir := Dir.Up;
    for cell, i in grid {
        if cell == '^' {
            pos = { i%DIM, i/DIM };
            break;
        }
    }
    //fmt.printfln("%v: %v", dir, pos);

    visited := make(map[int]Phantom, DIM*DIM);
    fnum := 0;
    time := 10 when EXAMPLE else 1;

    spacing := c.int(600/DIM);
    offset := c.int(100) when EXAMPLE else c.int(150);
    off := c.int(0) when EXAMPLE else c.int(25);
    rl.InitWindow(800, 600, strings.to_cstring(&title));
    rl.SetTargetFPS(120);

    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        for cell, i in grid {
            x, y := c.int(i%DIM), c.int(i/DIM);
            col : rl.Color;
            if x == c.int(pos.x) && y == c.int(pos.y) do col = rl.RED;
            else if i in visited do col = rl.GREEN;
            else if cell == '.' do col = rl.BLACK;
            else if cell == '#' do col = rl.GRAY;

            rl.DrawRectangle(offset + (spacing * x), off + (spacing * y), spacing, spacing, col);
            when EXAMPLE {
                rl.DrawRectangleLines(offset + (spacing * x), spacing * y, spacing, spacing, rl.WHITE);
            }
        }

        rl.EndDrawing();

        if (fnum % time) == 0 {
            //TODO: NEED to decouple this from frame rate, tooooo slow
            DIRS := DIRS;
            visited[(pos.y * DIM) + pos.x] = {};

            if new_dir, ok := find_dir(grid, pos, dir); ok {
                dir = new_dir;
                pos += DIRS[dir];
            }
            else {
                break;
            }
        }
        fnum += 1;
    }
    rl.CloseWindow();

    strings.write_int(p1, len(visited));
    strings.write_int(p2, 0);
}
