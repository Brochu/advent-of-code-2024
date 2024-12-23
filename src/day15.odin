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
    '[' = rl.BLUE,
    ']' = rl.RED,
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
    grid_p2 := make([dynamic]u8, 0, 2*len(grid));
    robot, robot_p2: Vec2;
    for cell, i in grid {
        if cell == '@' {
            robot = { i % DIM, i / DIM };
            robot_p2 = { i % DIM, i / DIM };
            robot_p2.x *= 2;
            append(&grid_p2, cell);
            append(&grid_p2, '.');
        }
        else if cell == 'O'{
            append_elems(&grid_p2, '[');
            append_elems(&grid_p2, ']');
        }
        else {
            append_elems(&grid_p2, cell);
            append_elems(&grid_p2, cell);
        }
    }
    //fmt.printfln("Starting pos = %v ; %v", robot, robot_p2);
    //fmt.printfln("grid len: %v ; grid_p2 len: %v", len(grid), len(grid_p2));

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

    steps_p2 := make([][]u8, len(moves)+1);
    steps_p2[0] = slice.clone(grid_p2[:]);
    for move, i in moves {
        if ok := sim_move_p2(grid_p2[:], robot_p2, move); ok {
            robot_p2 += move;
        }
        steps_p2[i+1] = slice.clone(grid_p2[:]);
    }

    res_p2 := 0;
    for cell, i in grid_p2 {
        if cell == '[' {
            pos := Vec2 { i % DIM, i / DIM };
            gps := (pos.y * 100) + pos.x;
            res_p2 += gps;
        }
    }

    strings.write_int(p1, res_p1);
    strings.write_int(p2, res_p2);

    P2 :: true;
    xoff, yoff: c.int : 2, 2;
    spacing: c.int : 80 when EXAMPLE else 16;
    minus: c.int : 5 when EXAMPLE else 2;
    WIDTH := 2*DIM if P2 else DIM;
    HEIGHT := DIM;
    time :: 100 when EXAMPLE else 1;
    fnum := 0;
    rl.InitWindow(800, 800, strings.to_cstring(&title));
    rl.SetTargetFPS(120);
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        for y in 0..<HEIGHT do for x in 0..<WIDTH {
            idx := (y * WIDTH) + x;
            xspace := spacing/2 if P2 else spacing;
            xpos, ypos := c.int(x) * xspace, c.int(y) * spacing;
            char: u8;
            if P2 {
                char = steps_p2[fnum/time][idx];
            } else {
                char = steps[fnum/time][idx];
            }

            rl.DrawRectangleLines(xpos + xoff, ypos + yoff, xspace-minus, spacing-minus, Colors[char]);
        }
        rl.DrawText(rl.TextFormat("%i", fnum/time), 10, 780, 15, rl.SKYBLUE);
        rl.EndDrawing();
        fnum = math.clamp(fnum+1, 0, time*len(steps)-1);
    }
    rl.CloseWindow();
}

@(private="file")
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

@(private="file")
sim_move_p2 :: proc (grid: []u8, pos: Vec2, move: Vec2) -> bool {
    ok := sim_move_p2_impl(grid, pos, move);
    if ok {
        target := pos + move;
        tidx := (target.y * (2*DIM)) + target.x;
        sidx := (pos.y * (2*DIM)) + pos.x;
        slice.swap(grid, sidx, tidx);
    }

    return ok;
}

@(private="file")
sim_move_p2_impl :: proc (grid: []u8, pos: Vec2, move: Vec2) -> bool {
    target := pos + move;
    tidx := (target.y * (2*DIM)) + target.x;

    if grid[tidx] == '#' {
        return false;
    }
    else if grid[tidx] == '.' {
        return true;
    }
    else if grid[tidx] == '[' {
    }
    else if grid[tidx] == ']' {
    }
    else {
        fmt.printfln("[SIM] Invalid case, what tile is this? %c", grid[tidx]);
        unimplemented();
    }

    return false;
}
