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

@(private="file")
Guard :: struct {
    pos: Vec2,
    dir: Dir,
}

Phantom :: struct {};

d6run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    lines := strings.split_lines(input);
    grid := transmute([]u8)strings.join(lines, "");
    DIM = len(lines);

    g := find_guard(grid);
    //fmt.printfln("%v", g);

    visited := make(map[int]Phantom, DIM*DIM);
    //grid[63] = 'O';
    //for y in 0..<DIM {
    //    for x in 0..<DIM {
    //        idx := (y * DIM) + x;
    //        fmt.printf("%v ", rune(grid[idx]));
    //    }
    //    fmt.println();
    //}
    sim_guard(grid, g, &visited);
    //fmt.printfln("[OK=%v][%v] VISITED:", ok, len(visited));
    //for k in visited {
    //    fmt.printfln("  %v", k);
    //}

    loop_count := 0;
    throwaway := make(map[int]Phantom, DIM*DIM); // Better way to ignore visited for part 2?
    for idx, _ in visited {
        grid[idx] = 'O';
        if ok := sim_guard(grid, g, &throwaway); !ok {
            loop_count += 1;
        }
        grid[idx] = '.';
    }

    strings.write_int(p1, len(visited));
    strings.write_int(p2, loop_count);

    /*
    rl.InitWindow(800, 600, strings.to_cstring(&title));
    rl.SetTargetFPS(120);

    for !rl.WindowShouldClose() {
    }
    rl.CloseWindow();
    */
}

@(private="file")
find_guard :: proc(grid: []u8) -> Guard {
    for cell, i in grid {
        if cell == '^' do return { { i%DIM, i/DIM }, Dir.Up };
    }
    return {};
}

@(private="file")
guard_char :: proc(dir: Vec2) -> u8 {
    switch dir {
    case DIRS[Dir.Up]: return '^';
    case DIRS[Dir.Left]: return '<';
    case DIRS[Dir.Right]: return '>';
    case DIRS[Dir.Down]: return 'v';
    case: return '*';
    }
}

@(private="file")
guard_turn :: proc(current: Dir) -> Dir {
    switch current {
    case .Up: return .Right;
    case .Right: return .Down;
    case .Down: return .Left;
    case .Left: return .Up;
    case: return .Up;
    }
}

@(private="file")
sim_guard :: proc(grid: []u8, g: Guard, visited: ^map[int]Phantom) -> bool {
    DIRS := DIRS;
    g := g;
    loop_check := make(map[i64]Phantom, DIM*DIM);

    for {
        idx := (g.pos.y * DIM) + g.pos.x;
        visited[idx] = {};

        //fmt.printfln("pos: %v; dir: %v (%v)", g.pos, g.dir, int(g.dir));
        loop_key := i64(g.dir) << 40;
        //fmt.printfln("look_key (dir) : %v", loop_key);
        loop_key += i64(idx);
        //fmt.printfln("look_key (idx) : %v", loop_key);
        if _, ok := loop_check[loop_key]; ok {
            //fmt.println("[LOOP] Found loop, invalid path");
            return false;
        }
        loop_check[loop_key] = {};

        t : Vec2;
        tidx := -1;
        for {
            t = g.pos + DIRS[g.dir];
            if (t.x < 0 || t.x >= DIM) || (t.y < 0 || t.y >= DIM) do return true;

            tidx = (t.y * DIM) + t.x;
            if grid[tidx] == '#' || grid[tidx] == 'O' {
                g.dir = guard_turn(g.dir);
            } else {
                break;
            }
        }
        g.pos += DIRS[g.dir];
    }
    return true;
}
