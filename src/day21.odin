package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day21.ex" when EXAMPLE else "../data/day21.in";

d21run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    codes := strings.split_lines(input);

    keypas_pos: map[byte]Vec2 = {
        '7' = {0, 0}, '8' = {1, 0}, '9' = {2, 0},
        '4' = {0, 1}, '5' = {1, 1}, '6' = {2, 1},
        '1' = {0, 2}, '2' = {1, 2}, '3' = {2, 2},
                      '0' = {1, 3}, 'A' = {2, 3},
    }

    dirs_pos: map[byte]Vec2 = {
                      '^' = {1, 0}, 'A' = {2, 0},
        '<' = {0, 1}, 'v' = {1, 1}, '>' = {2, 1},
    }
    pad_state: [3]byte = 'A';

    total := 0;
    for code in codes[2:3] {
        current := code;
        val, ok := strconv.parse_int(current, 10);
        fmt.printfln("CODE: '%v' (value = '%v')", current, val);

        next := strings.builder_make_len_cap(0, 256);
        defer strings.builder_destroy(&next);

        for round in 0..<3 {
            for target in current {
                expand(keypas_pos if round == 0 else dirs_pos, cast(byte)target, &pad_state[round], &next);
            }
            current = strings.clone(strings.to_string(next));
            strings.builder_reset(&next);
            fmt.printfln("round %v: %v (%v)", round, current, len(current));
        }

        total += val * len(current);
        fmt.printfln("CODE COMPLEXITY: %v * %v = %v", val, len(current), val * len(current));
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

expand :: proc(pos_map: map[byte]Vec2, to: byte, state: ^byte, out: ^strings.Builder) {
    diff := pos_map[to] - pos_map[state^];
    //fmt.printfln("[EX] from: %c; to: %c", state^, to);
    //fmt.printfln("[EX] diff: %v", diff);
    for diff.y > 0 {
        strings.write_byte(out, 'v');
        diff.y -= 1;
    }
    for diff.x < 0 {
        strings.write_byte(out, '<');
        diff.x += 1;
    }
    for diff.x > 0 {
        strings.write_byte(out, '>');
        diff.x -= 1;
    }
    for diff.y < 0 {
        strings.write_byte(out, '^');
        diff.y += 1;
    }

    strings.write_byte(out, 'A');
    state^ = to;
}
