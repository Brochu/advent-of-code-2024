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

CROSS :: [4]Vec2 {
    { -1, -1 }, {  1, -1 },
    { -1,  1 }, {  1,  1 },
};

letters := [4]u8 { 'X', 'M', 'A', 'S' };

Node :: struct {
    pos: [4]Vec2,
    len: int,
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
get_neighbours :: proc(n: Node) -> [dynamic]Vec2 {
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

    Q: queue.Queue(Node);
    queue.init(&Q, DIM * DIM);
    grid := transmute([]u8)strings.join(lines, "");
    matches_p1 := make([dynamic]Node, 0, DIM*DIM);
    matches_p2 := make([dynamic]Node, 0, DIM*DIM);

    for y in 0..<DIM {
        for x in 0..<DIM {
            idx := get_idx(Vec2 {x, y});
            //fmt.printf("%v ", rune(grid[idx]));

            if grid[idx] == 'X' {
                queue.push_back(&Q, Node { { {x, y}, {}, {}, {} }, 1 });
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
                    new := Node { node.pos, node.len };
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
    strings.write_int(p2, 4);
}
