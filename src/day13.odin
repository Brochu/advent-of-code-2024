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
    abutton: Vec2,
    bbutton: Vec2,
    prize: Vec2,
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

    fmt.println("MACHINES:");
    res_p1 := 0;
    for m in machines {
        a1, b1, c1 := m.abutton.x, m.bbutton.x, m.prize.x;
        a2, b2, c2 := m.abutton.y, m.bbutton.y, m.prize.y;

        det := a1 * b2 - a2 * b1;
        if det == 0 do continue;

        a := cast(f32)(b2 * c1 - b1 * c2) / cast(f32)det;
        b := cast(f32)(a1 * c2 - a2 * c1) / cast(f32)det;

        if a < 0 || b < 0 || a > 100 || b > 100 || a != cast(f32)(cast(int)a) || b != cast(f32)(cast(int)b) {
            continue;
        }
        //fmt.printfln("a_presses = %v ; b_presses = %v", a, b);
        res_p1 += (cast(int)a * 3) + cast(int)b;
    }

    res_p2: i64 = 0;
    for m in machines {
        a1, b1, c1 := m.abutton.x, m.bbutton.x, (m.prize.x + 10000000000000);
        a2, b2, c2 := m.abutton.y, m.bbutton.y, (m.prize.y + 10000000000000);

        det := a1 * b2 - a2 * b1;
        if det == 0 do continue;

        a := cast(f64)(b2 * c1 - b1 * c2) / cast(f64)det;
        b := cast(f64)(a1 * c2 - a2 * c1) / cast(f64)det;

        if a < 0 || b < 0 || a != cast(f64)(cast(i64)a) || b != cast(f64)(cast(i64)b) {
            continue;
        }
        //fmt.printfln("a_presses = %v ; b_presses = %v", a, b);
        res_p2 += (cast(i64)a * 3) + cast(i64)b;
    }

    strings.write_int(p1, res_p1);
    strings.write_i64(p2, res_p2);

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
