package main
import "core:c"
import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day13.ex" when EXAMPLE else "../data/day13.in"

@(private="file")
Machine :: struct {
    ab: Vec2,
    bb: Vec2,
    target: Vec2,
};

d13run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    machines := make([dynamic]Machine, 0, 300);
    for entry in strings.split_iterator(&input, "\n\n") {
        lines := strings.split_lines(entry);
        infos := make([][]string, 3);
        infos[0] = strings.split_n(lines[0][10:], ", ", 2);
        infos[1] = strings.split_n(lines[1][10:], ", ", 2);
        infos[2] = strings.split_n(lines[2][7:], ", ", 2);
        data := slice.mapper(infos, proc (data: []string) -> Vec2 {
            return { strconv.atoi(data[0][2:]), strconv.atoi(data[1][2:]) };
        });
        append(&machines, Machine { data[0], data[1], data[2] });
    }

    //fmt.println("MACHINES:");
    //for m in machines {
    //    fmt.printfln("%v", m);
    //}

    res_p1 := 0;
    for m in machines {
        min_tokens := 0;
        for a in 0..<100 do for b in 0..<100 {
            //fmt.printfln("A: %v, B: %v", a, b);
            xs := a * m.ab.x + b * m.bb.x;
            ys := a * m.ab.y + b * m.bb.y;

            if m.target.x == xs && m.target.y == ys {
                tokens := (a * 3) + b;
                //fmt.printfln("[%v, %v] A: %v; B: %v -> tokens = %v", xs, ys, a, b, tokens);
                if min_tokens == 0 do min_tokens = tokens;
                min_tokens = math.min(min_tokens, tokens);
            }
        }
        //fmt.printfln("MIN TOKENS: %v", min_tokens);
        res_p1 += min_tokens;
    }

    strings.write_int(p1, res_p1);
    strings.write_int(p2, 13);

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
}
