package main
import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day02.ex" when EXAMPLE else "../data/day02.in"

report :: struct {
    display_levels: cstring,
    valid_p1: bool,
    valid_p2: bool,
}

d2run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(string(#load(input_file)), "\r\n");
    lines := strings.split_lines(input);
    defer delete(lines);
    reports := make([]report, len(lines));
    defer { 
        for r in reports {
            delete(r.display_levels);
        }
        delete(reports);
    }

    valid_counts_p1 := make([]int, len(lines));
    defer delete(valid_counts_p1);
    valid_counts_p2 := make([]int, len(lines));
    defer delete(valid_counts_p2);

    for r, i in lines {
        reports[i].display_levels = strings.clone_to_cstring(r);
        levels := parse_report(r);
        reports[i].valid_p1 = check_report_p1(levels);
        reports[i].valid_p2 = check_report_p2(levels);

        valid_counts_p1[i] = 0 if i == 0 else valid_counts_p1[i-1];
        if reports[i].valid_p1 {
            valid_counts_p1[i] += 1;
        }

        valid_counts_p2[i] = 0 if i == 0 else valid_counts_p2[i-1];
        if reports[i].valid_p2 {
            valid_counts_p2[i] += 1;
        }
    }

    //for r in reports {
    //    fmt.printfln("%v", r);
    //}
    //fmt.printfln("%v", valid_counts_p1);
    //fmt.println("---------------");
    //fmt.printfln("%v", valid_counts_p2);

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

    strings.write_int(p1, valid_counts_p1[len(valid_counts_p1)-1]);
    strings.write_int(p2, valid_counts_p2[len(valid_counts_p2)-1]);
}

@(private="file")
parse_report :: proc(report: string) -> []int {
    elems, _ := strings.split(report, " ");
    res, _ := make([]int, len(elems));

    for e, i in elems {
        res[i] = strconv.atoi(elems[i]);
    }
    return res;
}

@(private="file")
check_report_p1 :: proc(levels: []int) -> bool {
    //fmt.printfln("[CHECK] %v", levels);
    is_asc : bool = levels[0] < levels[1];
    valid := true;

    for i in 1..<len(levels) {
        l := levels[i-1];
        r := levels[i];

        //fmt.printfln("%v vs. %v", l, r);
        if (is_asc && l > r) || (!is_asc && l < r) {
            valid = false;
            break;
        }
        diff := math.abs(l - r);
        if diff < 1 || diff > 3 {
            valid = false;
            break;
        }
    }
    //fmt.printfln("[DONE] %v = %v", levels, valid);
    return valid;
}

@(private="file")
check_report_p2 :: proc(levels: []int) -> bool {
    if check_report_p1(levels) {
        return true;
    }

    for i in 0..<len(levels) {
        parts := [][]int {
            levels[:i],
            levels[i+1:],
        }
        new_levels, _ := slice.concatenate(parts);
        //fmt.printfln("[%v] -> '%v' = %v", levels, parts, new_levels);

        if check_report_p1(new_levels) {
            return true;
        }

    }
    return false;
}
