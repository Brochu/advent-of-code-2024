package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day12.ex" when EXAMPLE else "../data/day12.in"

@(private="file")
DIM := 0;

@(private="file")
Region :: struct {
    char: u8,
    area: int,
    peri: int,
    corners: int,
    plots: [dynamic]int,
};

@(private="file")
COLORS: []rl.Color : {
    rl.RED,
    rl.ORANGE,
    rl.YELLOW,
    rl.GREEN,
    rl.SKYBLUE,
    rl.BLUE,
    rl.DARKBLUE,
    rl.PURPLE,
    rl.PINK,
    rl.MAROON,
    rl.BROWN,
    rl.GRAY,
}

d12run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    lines := strings.split_lines(input);
    grid := transmute([]u8)strings.join(lines, "");
    DIM = len(lines);

    regions := make([dynamic]Region);
    visited := make(map[int]Phantom);
    for plot, i in grid {
        if _, ok := visited[i]; !ok do append(&regions, flood_fill(i, grid, &visited));
    }
    //print_state(regions[:], visited);

    res_p1 := slice.reduce(regions[:], 0, proc(acc: int, region: Region) -> int {
        return acc + region.area * region.peri;
    });
    res_p2 := slice.reduce(regions[:], 0, proc(acc: int, region: Region) -> int {
        return acc + region.area * region.corners;
    });
    strings.write_int(p1, res_p1);
    strings.write_int(p2, res_p2);

    xoff := 250 when EXAMPLE else 10;
    yoff := 250 when EXAMPLE else 10;
    spacing := 50 when EXAMPLE else 7;
    font := c.int(25) when EXAMPLE else c.int(5);
    sb, _ := strings.builder_make_none();
    rl.InitWindow(1000, 1000, strings.to_cstring(&title));
    rl.SetTargetFPS(60);
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();

        rl.ClearBackground(rl.BLACK);
        for y in 0..<DIM {
            for x in 0..<DIM {
                idx := (y * DIM) + x;
                col := find_region(regions, idx);

                fmt.sbprintf(&sb, "%c", grid[idx]);
                rl.DrawText(strings.to_cstring(&sb),
                    c.int(x * spacing + xoff), c.int(y * spacing + yoff),
                    font, col);
                strings.builder_reset(&sb);
            }
        }
        rl.EndDrawing();
    }
    rl.CloseWindow();
}

@(private="file")
print_state :: proc(regions: []Region, visited: map[int]Phantom) {
    fmt.println("REGIONS:");
    for r in regions {
        fmt.printfln("    [%c][A=%v][P=%v][C=%v] -> %v", r.char, r.area, r.peri, r.corners, r.plots);
    }
    fmt.println("VISITED:");
    fmt.print("    ");
    for v in visited {
        fmt.printf("%v, ", v);
    }
    fmt.println();
    fmt.println();
}

@(private="file")
grid_get :: proc(grid: []u8, pos: Vec2) -> u8 {
    if (pos.x < 0 || pos.x >= DIM) || (pos.y < 0 || pos.y >= DIM) { return 0; }
    else do return grid[(pos.y * DIM) + pos.x];
}

@(private="file")
find_region :: proc(regions: [dynamic]Region, idx: int) -> rl.Color {
    COLORS := COLORS;
    for region, i in regions {
        if _, ok := slice.linear_search(region.plots[:], idx); ok do return COLORS[i%len(COLORS)];
    }
    return rl.WHITE;
}

@(private="file")
flood_fill :: proc(sidx: int, grid: []u8, visited: ^map[int]Phantom) -> Region {
    DIRS := DIRS;
    region: Region = {
        grid[sidx],
        0,
        0,
        0,
        make([dynamic]int, 0, len(grid)),
    }
    stack := make([dynamic]int, 0, len(grid));
    append(&stack, sidx);

    for len(stack) > 0 {
        i := pop_front(&stack);
        if _, ok := visited[i]; ok do continue;

        append(&region.plots, i);
        visited[i] = {};
        region.area += 1;
        curr := Vec2 { i % DIM, i / DIM };

        //fmt.printfln("VISITING [%2.v] -> %v : %v", i, grid_get(grid, curr), curr);
        for d in Dir {
            pos := curr + DIRS[d];
            if letter := grid_get(grid, pos); letter == region.char {
                nidx := (pos.y * DIM) + pos.x;
                //fmt.printfln("    N [%2.v] -> %v : %v", nidx, grid_get(grid, pos), pos);
                append(&stack, nidx);
            } else {
                region.peri += 1;
            }
        }
    }
    region.corners = count_corners(grid, region);
    return region;
}

@(private="file")
count_corners :: proc(g: []u8, r: Region) -> int {
    corners := 0;

    for idx in r.plots {
        pos := Vec2 { idx % DIM, idx / DIM };
        top := pos + DIRS[Dir.Up];
        lft := pos + DIRS[Dir.Left];
        rgt := pos + DIRS[Dir.Right];
        dwn := pos + DIRS[Dir.Down];
        //fmt.printfln("POS: %v [%v]", pos, grid_get(g, pos));
        //fmt.printfln("    TOP: %v [%v] vs LFT: %v [%v]", top, grid_get(g, top), lft, grid_get(g, lft));
        //fmt.printfln("    LFT: %v [%v] vs DWN: %v [%v]", lft, grid_get(g, lft), dwn, grid_get(g, dwn));
        //fmt.printfln("    DWN: %v [%v] vs RGT: %v [%v]", dwn, grid_get(g, dwn), rgt, grid_get(g, rgt));
        //fmt.printfln("    RGT: %v [%v] vs TOP: %v [%v]", rgt, grid_get(g, rgt), top, grid_get(g, top));
        tl := pos + DIRS[Dir.Up] + DIRS[Dir.Left];
        dl := pos + DIRS[Dir.Down] + DIRS[Dir.Left];
        dr := pos + DIRS[Dir.Down] + DIRS[Dir.Right];
        tr := pos + DIRS[Dir.Up] + DIRS[Dir.Right];

        if (grid_get(g, top) != r.char) && (grid_get(g, lft) != r.char) do corners += 1;
        if (grid_get(g, lft) != r.char) && (grid_get(g, dwn) != r.char) do corners += 1;
        if (grid_get(g, dwn) != r.char) && (grid_get(g, rgt) != r.char) do corners += 1;
        if (grid_get(g, rgt) != r.char) && (grid_get(g, top) != r.char) do corners += 1;

        if (grid_get(g, top) == r.char) && (grid_get(g, lft) == r.char) && (grid_get(g, tl) != r.char) do corners += 1;
        if (grid_get(g, lft) == r.char) && (grid_get(g, dwn) == r.char) && (grid_get(g, dl) != r.char) do corners += 1;
        if (grid_get(g, dwn) == r.char) && (grid_get(g, rgt) == r.char) && (grid_get(g, dr) != r.char) do corners += 1;
        if (grid_get(g, rgt) == r.char) && (grid_get(g, top) == r.char) && (grid_get(g, tr) != r.char) do corners += 1;
    }
    return corners;
}
