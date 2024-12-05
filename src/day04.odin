package main
import "core:c"
import "core:container/queue"
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day04.ex" when EXAMPLE else "../data/day04.in"

Vec2 :: [2]int;
DIRS :: [8]Vec2 {
    { -1, -1 }, {  0, -1 }, {  1, -1 },

    { -1,  0 },             {  1,  0 },

    { -1,  1 }, {  0,  1 }, {  1,  1 },
};

letters := [4]u8 { 'X', 'M', 'A', 'S' };

Node_p1 :: struct {
    pos: [4]Vec2,
    len: int,
}

Node_p2 :: struct {
    pos: [5]Vec2,
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
get_neighbours :: proc(n: Node_p1) -> [dynamic]Vec2 {
    ns := make([dynamic]Vec2, 0, len(DIRS));

    if n.len == 1 {
        for d in DIRS {
            new := n.pos[n.len-1] + d;
            if (new.x >= 0 && new.x < DIM) && (new.y >= 0 && new.y < DIM) {
                append(&ns, new);
            }
        }
    }
    else if n.len <= 3 {
        dir := n.pos[n.len-1] - n.pos[n.len-2];
        n := n.pos[n.len-1] + dir;
        if (n.x >= 0 && n.x < DIM) && (n.y >= 0 && n.y < DIM) {
            append(&ns, n);
        }
    }
    return ns;
}

d4run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    lines := strings.split_lines(input);
    DIM = len(lines);

    Q: queue.Queue(Node_p1);
    queue.init(&Q, DIM * DIM);
    grid := transmute([]u8)strings.join(lines, "");
    matches_p1 := make([dynamic]Node_p1, 0, DIM*DIM);
    matches_p2 := make([dynamic]Node_p2, 0, DIM*DIM);

    for y in 0..<DIM {
        for x in 0..<DIM {
            coord := Vec2 { x, y };
            idx := get_idx(coord);
            //fmt.printf("%v ", rune(grid[idx]));

            if grid[idx] == 'X' {
                queue.push_back(&Q, Node_p1 { { coord, {}, {}, {} }, 1 });
            }
            else if grid[idx] == 'A' {
                if node, ok := cross_check(grid, coord); ok {
                    //fmt.printfln("[%v] %v - %v | %v", idx, coord, rune(grid[idx]), node.pos);
                    ms := 0;
                    ss := 0;
                    for e in node.pos {
                        if grid[get_idx(e)] == 'M' {
                            ms += 1;
                        }
                        else if grid[get_idx(e)] == 'S' {
                            ss += 1;
                        }
                    }

                    if ms == 2 && ss == 2 && grid[get_idx(node.pos[1])] != grid[get_idx(node.pos[4])] {
                        append(&matches_p2, node);
                    }
                }
            }
        }
        //fmt.println();
    }

    for queue.len(Q) > 0 {
        node := queue.pop_back(&Q);
        //fmt.printfln("[PROC] %v", node);

        if node.len >= 4 {
            append(&matches_p1, node);
        }
        else {
            for n in get_neighbours(node) {
                idx := get_idx(n);
                //fmt.printfln(" - %v -> %v == %v", n, grid[idx], letters[node.len]);
                if grid[idx] == letters[node.len] {
                    new := Node_p1 { node.pos, node.len };
                    new.pos[new.len] = n;
                    new.len += 1;
                    queue.push_back(&Q, new);
                }
            }
        }
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

    strings.write_int(p1, len(matches_p1));
    strings.write_int(p2, len(matches_p2));
}

CROSS :: [4]Vec2 {
    { -1, -1 }, {  1, -1 },
    { -1,  1 }, {  1,  1 },
};

cross_check :: proc(grid: []u8, s: Vec2) -> (Node_p2, bool) {
    idx := get_idx(s);

    cs : [5]Vec2;
    cs[0] = s;

    for e, i in CROSS {
        new := s + e;
        if (new.x < 0 || new.x >= DIM) || (new.y < 0 || new.y >= DIM) {
            return Node_p2 {}, false;
        }
        cs[i+1] = new;
    }
    return Node_p2 { cs }, true;
}
