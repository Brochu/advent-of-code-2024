package main
import "core:c"
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day03.ex" when EXAMPLE else "../data/day03.in"

Step :: struct {
    str: string,
    first: int,
    second: int,
};

d3run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string), "\r\n");
    text_p1 := input;
    steps_p1 := make([dynamic]Step);
    //TODO: Find a way to store which step we reach at a given spot in the input string

    curr := 0;
    marker :: "mul(";
    for {
        //TODO: Keep how many chars are offset to calc global index
        curr = strings.index(text_p1, marker);
        if curr == -1 do break;
        if func, f, s, ok := check_marker(text_p1[curr:]); ok {
            //fmt.printfln("[%v] -> (%v, %v)", func, f, s);
            append(&steps_p1, Step { str = func, first = f, second = s });
        }
        text_p1 = text_p1[curr+4:];
    }

    //TODO: Try to combine with loop of part 1? Should be possible
    text_p2 := input;
    steps_p2 := make([dynamic]Step);

    curr = 0;
    enabled := true;
    marker_p2 :: []string {
        marker,
        "do()",
        "don't()",
    };
    for {
        curr, _ = strings.index_multi(text_p2, marker_p2);
        if curr == -1 do break;

        //fmt.printfln("[%v]: %v", curr, text_p2[curr:]);
        if strings.has_prefix(text_p2[curr:], "do()") {
            enabled = true;
        }
        else if strings.has_prefix(text_p2[curr:], "don't()") {
            enabled = false;
        }
        else {
            if func, f, s, ok := check_marker(text_p2[curr:]); enabled && ok {
                //fmt.printfln("P2 [%v] -> (%v, %v)", func, f, s);
                append(&steps_p2, Step { str = func, first = f, second = s });
            }
        }

        text_p2 = text_p2[curr+4:];
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

    res1 := 0;
    for s in steps_p1 {
        //fmt.printfln("[P1] - %v", s);
        res1 += s.first * s.second;
    }

    res2 := 0;
    for s in steps_p2 {
        //fmt.printfln("[P2] - %v", s);
        res2 += s.first * s.second;
    }
    strings.write_int(p1, res1);
    strings.write_int(p2, res2);
}

ParseSteps :: enum {
    Invalid,
    FirstNum,
    SecondNum,
    Done,
};

@(private="file")
check_marker :: proc(curr: string) -> (string, int, int, bool) {
    f, s := 0, 0;
    state := ParseSteps.FirstNum;

    i := 4;
    for i < len(curr) {
        #partial switch (state) {

        case .FirstNum:
            if curr[i] == ',' {
                state = .SecondNum if f != 0 else .Invalid;
            }
            else if curr[i] >= '0' && curr[i] <= '9' {
                f *= 10;
                f += int(curr[i] - '0');
            }
            else do state = .Invalid;

        case .SecondNum:
            if curr[i] == ')' {
                state = .Done;
            }
            else if curr[i] >= '0' && curr[i] <= '9' {
                s *= 10;
                s += int(curr[i] - '0');
            }
            else do state = .Invalid;

        case .Invalid:
            return "", -1, -1, false;
        }

        if state == .Done do break;
        i += 1;
    }
    return curr[:i+1], f, s, true;
}
