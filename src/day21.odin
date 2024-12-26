package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day21.ex" when EXAMPLE else "../data/day21.in"

@(private="file")
Keypads :: enum {
    OURS,
    ROB1,
    ROB2,
    NUMS,
};

@(private="file")
states: [Keypads]int = {
    .OURS = 2,
    .ROB1 = 2,
    .ROB2 = 2,
    .NUMS = 11,
};

d21run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    codes := strings.split_lines(input);

    fmt.println("CODES:");
    for code in codes[0:1] {
        fmt.printfln("    %v", code);
        print_states();
    }

    strings.write_string(p1, "Upcoming...");
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

solve_numeric :: proc (idx: int) -> u8 {
    switch idx {
    case 0: return '7'; case 1: return '8'; case 2: return '9';
    case 3: return '4'; case 4: return '5'; case 5: return '6';
    case 6: return '1'; case 7: return '2'; case 8: return '3';
    case 9: unimplemented("[SOLVE] Invalid key");
    case 10: return '0';
    case 11: return 'A';
    }

    unimplemented("[SOLVE] Invalid key");
}

solve_dir :: proc (idx: int) -> u8 {
    switch idx {
    case 0: unimplemented("[SOLVE] Invalid key");
    case 1: return '^';
    case 2: return 'A';
    case 3: return '<'; case 4: return 'v'; case 5: return '>';
    }

    unimplemented("[SOLVE] Invalid key");
}

print_states :: proc() {
    fmt.printfln("[OURS] [%v] %c", states[.OURS], solve_dir(states[.OURS]));
    fmt.printfln("[ROB1] [%v] %c", states[.ROB1], solve_dir(states[.ROB1]));
    fmt.printfln("[ROB2] [%v] %c", states[.ROB2], solve_dir(states[.ROB2]));
    fmt.printfln("[NUMS] [%v] %c", states[.NUMS], solve_numeric(states[.NUMS]));
}
