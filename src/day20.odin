package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day20.ex" when EXAMPLE else "../data/day20.in"

@(private="file")
DIM := 0;

@(private="file")
Colors: map[u8]rl.Color = {
    'S' = rl.WHITE,
    'E' = rl.WHITE,
    '#' = rl.SKYBLUE,
    '.' = rl.GRAY,
    '*' = rl.YELLOW,
};

@(private="file")
DColors: map[Vec2]rl.Color = {
    { 0, 0 }        = rl.GRAY,
    DIRS[Dir.Left]  = rl.RED,
    DIRS[Dir.Right] = rl.BLUE,
    DIRS[Dir.Up]    = rl.GREEN,
    DIRS[Dir.Down]  = rl.YELLOW,
};

@(private="file")
path_set: map[int]Phantom;

@(private="file")
Node :: struct {
    dir: Vec2,
    cost: int,
}

@(private="file")
CheatId :: distinct [2]Vec2;

/*
Code is basically the same for both parts. I use dfs to calcualte the original path and number of steps
from start to finish at each point along the way. I then walk the path and find the number of cheats to
other points in the path within a given manhattan distance between the two points. I then calculate the
savings for each pair of points by applying the cheat. I then count the number of cheats that achieve a
savings above the given threshold, 100. For Part 1, the manhattan distance is fixed at 2. For Part 2,
I loop from 2 to 20 and accumulate the number of cheats for a potential diamond of points for the given
manhattan distance of each iteration.
*/
d20run :: proc (p1, p2: ^strings.Builder) {
    rl.SetTraceLogLevel(rl.TraceLogLevel.WARNING);
    DIRS := DIRS;

    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    lines := strings.split_lines(input);
    DIM = len(lines);
    grid := transmute([]u8)strings.join(lines, "");
    path := make([]Node, len(grid));


    start, end: Vec2;
    for cell, i in grid {
        if cell == 'S' do start = coord_idx(i);
        else if cell == 'E' do end = coord_idx(i);
    }

    curr := start;
    for curr != end do for d in Dir {
        cidx := idx_coord(curr);
        path_set[cidx] = {};

        target := curr + DIRS[d];
        tidx := idx_coord(target);
        //fmt.printfln("    test: %v, [%c]", target, grid[tidx]);

        if (grid[tidx] == '.' || grid[tidx] == 'E') && !(tidx in path_set) {
            path[cidx].dir = target - curr;
            path[cidx].cost = len(path_set) - 1;
            curr = target;
            break;
        }
    }
    path[(idx_coord(end))].cost = len(path_set);

    cheats := make(map[int][dynamic]CheatId);
    for idx in path_set {
        // Check all possible cheats, group by time saved
        coord := coord_idx(idx);
        //fmt.printfln("[%v] -> cost: %v", coord, path[idx].cost);
        for d in Dir {
            start, end := coord + DIRS[d], coord + 2*DIRS[d];
            sidx, eidx := idx_coord(start), idx_coord(end);
            if sidx < 0 || eidx < 0 || sidx >= DIM*DIM || eidx >= DIM*DIM {
                continue;
            }

            saved := (path[eidx].cost - path[idx].cost) - 2;
            if grid[sidx] == '#' && (grid[eidx] == '.' || grid[eidx] == 'E') && saved > 0 {
                /*
                fmt.printfln("    FOUND CHEAT -> from %v(%v) to %v(%v) ; saved = %v",
                    coord, path[idx].cost,
                    end, path[eidx].cost,
                    saved
                );
                */

                newId: CheatId = { start, end };
                if bucket, ok := &cheats[saved]; ok {
                    append(bucket, newId);
                } else {
                    cheats[saved] = [dynamic]CheatId { newId };
                }
            }
        }
    }

    p1_res := 0;
    for key, val in cheats {
        //fmt.printfln(" - %v cheats saving %v", len(val), key);
        if key >= 100 {
            p1_res += len(val);
        }
    }

    strings.write_int(p1, p1_res);
    strings.write_int(p2, 20);

    /*
    off: c.int : 5 when EXAMPLE else 50;
    spacing: c.int : 53 when EXAMPLE else 5;
    minus: c.int : 5 when EXAMPLE else 1;
    time :: 5 when EXAMPLE else 1;
    fnum := 0;
    rl.InitWindow(800, 800, strings.to_cstring(&title));
    rl.SetTargetFPS(60);
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        for y in 0..<DIM do for x in 0..<DIM {
            xpos := off + (spacing * c.int(x));
            ypos := off + (spacing * c.int(y));
            idx := (y * DIM) + x;

            col := DColors[path[idx].dir];
            if grid[idx] == 'S' || grid[idx] == 'E' {
                col = Colors[grid[idx]];
            }
            rl.DrawRectangleLines(xpos, ypos, spacing-minus, spacing-minus, col);
            when EXAMPLE {
            if path[idx].dir == DIRS[Dir.Up] {
                rl.DrawTriangleLines(
                    {cast(f32)(xpos+(spacing/2)), cast(f32)(ypos-10+(spacing/2))},
                    {cast(f32)(xpos-5+(spacing/2)), cast(f32)(ypos+10+(spacing/2))},
                    {cast(f32)(xpos+5+(spacing/2)), cast(f32)(ypos+10+(spacing/2))},
                DColors[path[idx].dir]);
            }
            else if path[idx].dir == DIRS[Dir.Down] {
                rl.DrawTriangleLines(
                    {cast(f32)(xpos+(spacing/2)), cast(f32)(ypos+10+(spacing/2))},
                    {cast(f32)(xpos-5+(spacing/2)), cast(f32)(ypos-10+(spacing/2))},
                    {cast(f32)(xpos+5+(spacing/2)), cast(f32)(ypos-10+(spacing/2))},
                DColors[path[idx].dir]);
            }
            else if path[idx].dir == DIRS[Dir.Left] {
                rl.DrawTriangleLines(
                    {cast(f32)(xpos-10+(spacing/2)), cast(f32)(ypos+(spacing/2))},
                    {cast(f32)(xpos+10+(spacing/2)), cast(f32)(ypos+5+(spacing/2))},
                    {cast(f32)(xpos+10+(spacing/2)), cast(f32)(ypos-5+(spacing/2))},
                DColors[path[idx].dir]);
            }
            else if path[idx].dir == DIRS[Dir.Right] {
                rl.DrawTriangleLines(
                    {cast(f32)(xpos+10+(spacing/2)), cast(f32)(ypos+(spacing/2))},
                    {cast(f32)(xpos-10+(spacing/2)), cast(f32)(ypos+5+(spacing/2))},
                    {cast(f32)(xpos-10+(spacing/2)), cast(f32)(ypos-5+(spacing/2))},
                DColors[path[idx].dir]);
            }
            rl.DrawText(rl.TextFormat("%i", path[idx].cost), xpos+(spacing/2), ypos, 15, rl.WHITE);
            }
        }

        rl.EndDrawing();
    }
    rl.CloseWindow();
    */
}

idx_coord :: proc (coord: Vec2) -> int { return (coord.y * DIM) + coord.x }
coord_idx :: proc (idx: int) -> Vec2 { return {idx % DIM, idx / DIM} }
