package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day11.ex" when EXAMPLE else "../data/day11.in"

d11run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    stones_p1 := make(map[u64]u64);
    stones_p2 := make(map[u64]u64);

    for stone in strings.split_iterator(&input, " ") {
        s, _ := strconv.parse_u64(stone);
        stones_p1[s] += 1;
        stones_p2[s] += 1;
    }

    for _ in 0..<25 {
        stones_p1 = sim_blink(stones_p1);
    }
    for _ in 0..<75 {
        stones_p2 = sim_blink(stones_p2);
    }

    res_p1: u64 = 0;
    for val, size in stones_p1 {
        res_p1 += size;
    }
    res_p2: u64 = 0;
    for val, size in stones_p2 {
        res_p2 += size;
    }
    strings.write_u64(p1, res_p1);
    strings.write_u64(p2, res_p2);

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

@(private="file")
print_stones :: proc (stones: map[u64]u64) {
    fmt.println("STONES:");
    for mark, size in stones {
        fmt.printfln("[%v] -> %v", mark, size);
    }
}

@(private="file")
len_num :: proc (num: u64) -> int {
    if num == 0 do return 1;

    num, res := num, 0;
    for num > 0 {
        res += 1;
        num /= 10;
    }
    return res;
}

@(private="file")
split_num :: proc (num: u64, size: int) -> (l: u64, r: u64) {
    if size % 2 == 1 do return 0, 0;

    div: u64 = 1;
    for _ in 0..<size/2 do div *= 10;
    l = num / div;
    r = num - (l * div);
    return;
}

@(private="file")
sim_blink :: proc (stones: map[u64]u64) -> map[u64]u64 {
    result := make(map[u64]u64);

    for val, size in stones {
        digits := len_num(val);
        if val == 0 {
            result[1] += size;
        }
        else if digits % 2 == 0 {
            l, r := split_num(val, digits);
            result[l] += size;
            result[r] += size;
        }
        else {
            result[val*2024] += size;
        }
    }
    return result;
}
