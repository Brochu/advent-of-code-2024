package main
import "core:c"
import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day15.ex" when EXAMPLE else "../data/day15.in"

@(private="file")
DIM := 0;

@(private="file")
Colors: map[u8]rl.Color = {
    '#' = rl.SKYBLUE,
    'O' = rl.YELLOW,
    '@' = rl.GREEN,
    '.' = rl.GRAY,
};

@(private="file")
Dirs: map[u8]Vec2 = {
    '^' = DIRS[1],
    '<' = DIRS[3],
    '>' = DIRS[4],
    'v' = DIRS[6],
};

d15run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    elems := strings.split(input, "\n\n");

    lines := strings.split_lines(elems[0]);
    DIM = len(lines);
    grid := transmute([]u8)strings.join(lines, "");
    robot: Vec2;
    for cell, i in grid do if cell == '@' {
        robot = { i % DIM, i / DIM };
        break;
    }
    //fmt.printfln("Starting pos = %v", robot);

    chars, alloc := strings.replace_all(elems[1], "\n", "");
    moves := make([]Vec2, len(chars));
    for char, i in transmute([]u8)chars do moves[i] = Dirs[char];

    steps := make([][]u8, len(moves)+1);
    steps[0] = slice.clone(grid);
    for move, i in moves {
        if ok := sim_move(grid, robot, move); ok {
            robot += move;
        }
        steps[i+1] = slice.clone(grid);
    }

    res_p1 := 0;
    for grid, i in grid {
        if grid == 'O' {
            pos := Vec2 { i % DIM, i / DIM };
            gps := (pos.y * 100) + pos.x;
            res_p1 += gps;
        }
    }

    strings.write_int(p1, res_p1);
    strings.write_int(p2, 15);

    xoff, yoff: c.int : 2, 2;
    spacing: c.int : 80 when EXAMPLE else 16;
    time :: 5 when EXAMPLE else 1;
    fnum := 0;
    rl.InitWindow(800, 800, strings.to_cstring(&title));
    rl.SetTargetFPS(60);
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        for y in 0..<DIM do for x in 0..<DIM {
            idx := (y * DIM) + x;
            xpos, ypos := c.int(x) * spacing, c.int(y) * spacing;
            char := steps[fnum/time][idx];

            rl.DrawRectangleLines(xpos + xoff, ypos + yoff, spacing-5, spacing-5, Colors[char]);
            rl.DrawText(rl.TextFormat("%i", fnum/time), 10, 780, 15, rl.SKYBLUE);
        }
        rl.EndDrawing();
        fnum = math.clamp(fnum+1, 0, time*len(steps)-1);
    }
    rl.CloseWindow();
}

sim_move :: proc (grid: []u8, pos: Vec2, move: Vec2) -> bool {
    target := pos + move;
    tidx := (target.y * DIM) + target.x;
    //fmt.printfln("[SIM] from %v to %v (%v)", pos, target, move);

    if grid[tidx] == '#' {
        // hit a wall, no movement
        //fmt.printfln("[SIM] Hit wall at %v, stop", target);
        return false;
    }
    else if grid[tidx] == '.' {
        // found empty spot, move
        //fmt.printfln("[SIM] found empty spot at %v, swap", target);
        sidx := (pos.y * DIM) + pos.x;
        slice.swap(grid, sidx, tidx);
        return true;
    }
    else if grid[tidx] == 'O' {
        // hit a box, recursive check
        if ok := sim_move(grid, target, move); ok {
            sidx := (pos.y * DIM) + pos.x;
            slice.swap(grid, sidx, tidx);
            return true;
        }
    }
    else {
        fmt.printfln("[SIM] Invalid case, what tile is this? %c", grid[tidx]);
        unimplemented();
    }

    return false;
}
