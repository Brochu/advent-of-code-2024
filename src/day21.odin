package main
import "core:c"
import "core:fmt"
import "core:mem"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day21.ex" when EXAMPLE else "../data/day21.in";

d21run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    codes := strings.split_lines(input);

    total := 0;
    for code in codes[:] {
        current := code;
        val, ok := strconv.parse_int(current, 10);
        fmt.printfln("CODE: '%v' (value = '%v')", current, val);

        next := strings.builder_make_len_cap(0, 256);
        defer strings.builder_destroy(&next);

        // KEYPAD SIM
        key_state: byte = 'A';
        for target in current {
            expand_door(&next, &key_state, cast(byte)target);
        }
        fmt.printfln("    out: %v", strings.to_string(next));

        // ROBOTS SIM
        /*
        for round in 0..<2 {
            fmt.print("    ");
            for target in current {
                fmt.printf("%v, ", target);
            }
            fmt.println();
            current = strings.clone(strings.to_string(next));
            strings.builder_reset(&next);
            mem.zero(raw_data(next.buf), strings.builder_cap(next));
        }
        */

        complexity := val * len(current);
        total += complexity;
        fmt.printfln("    Complexity = (%v * %v) = %v", val, len(current), complexity);
    }

    strings.write_int(p1, total);
    strings.write_string(p2, "Upcoming...");

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

expand_door :: proc (out: ^strings.Builder, from: ^byte, to: byte) {
    keypas_pos: map[byte]Vec2 = {
        '7' = {0, 0}, '8' = {1, 0}, '9' = {2, 0},
        '4' = {0, 1}, '5' = {1, 1}, '6' = {2, 1},
        '1' = {0, 2}, '2' = {1, 2}, '3' = {2, 2},
                      '0' = {1, 3}, 'A' = {2, 3},
    }
    def_order: []byte = { '<', 'v', '^', '>' };
    alt_order: []byte = { '^', '>', 'v', '<' };

    fpos := keypas_pos[from^];
    tpos := keypas_pos[to];
    diff := tpos - fpos;
    fmt.printfln("    expand from: %c (%v) ; to: %c (%v) -> diff: %v", from^, fpos, to, tpos, diff);

    order := &def_order;
    if (fpos.y == 3 && tpos.x == 0) || (tpos.y == 3 && fpos.x == 0) {
        order = &alt_order;
    }

    for char in order^ {
        if char == '<' {
            for diff.x < 0 {
                strings.write_byte(out, char);
                diff.x += 1;
            }
        }
        else if char == '>' {
            for diff.x > 0 {
                strings.write_byte(out, char);
                diff.x -= 1;
            }
        }
        else if char == '^' {
            for diff.y < 0 {
                strings.write_byte(out, char);
                diff.y += 1;
            }
        }
        else if char == 'v' {
            for diff.y > 0 {
                strings.write_byte(out, char);
                diff.y -= 1;
            }
        }
    }

    strings.write_byte(out, 'A');
    from^ = to;
}
