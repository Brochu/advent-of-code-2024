package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day25.ex" when EXAMPLE else "../data/day25.in"

@(private="file")
TUMBLER_COUNT, MAX_HEIGHT :: 5, 5

@(private="file")
Heights :: distinct [5]u8;

@(private="file")
locks, keys: [dynamic]Heights;

d25run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    for group in strings.split_iterator(&input, "\n\n") {
        grid := transmute([]u8)strings.join(strings.split_lines(group), "");
        arr := &locks if grid[0] == '#' else &keys;

        heights: Heights;
        for h in 1..=MAX_HEIGHT do for tidx in 0..<TUMBLER_COUNT {
            idx := (h * TUMBLER_COUNT) + tidx;
            if grid[idx] == '#' do heights[tidx] += 1;
        }
        append(arr, heights);
    }
    //fmt.printfln("[%v] LOCKS:", len(locks));
    //for l in locks {
    //    fmt.printfln("    %v", l);
    //}
    //fmt.printfln("[%v] KEYS :", len(keys));
    //for k in keys {
    //    fmt.printfln("    %v", k);
    //}

    res_p1 := 0;
    for l in locks do for k in keys {
        if !check_overlap(l, k) do res_p1 += 1;
    }
    strings.write_int(p1, res_p1);
    strings.write_int(p2, 25);

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

check_overlap :: proc (lock, key: Heights) -> bool {
    for i in 0..<TUMBLER_COUNT do if (lock[i] + key[i]) > MAX_HEIGHT {
        return true;
    }

    return false;
}
