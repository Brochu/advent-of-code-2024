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
    valid_p1: bool,
    valid_p2: bool,
    levels: cstring,
}

d2run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(string(#load(input_file)), "\r\n");
    reports := strings.split_lines(input);
    defer delete(reports);
    //fmt.printfln("[%v] -> \n%v", len(reports), reports);

    repobjs := make([]report, len(reports));
    defer delete(repobjs);
    valid_counts_p1 := make([]int, len(reports));
    defer delete(valid_counts_p1);
    valid_counts_p2 := make([]int, len(reports));
    defer delete(valid_counts_p2);

    for r, i in reports {
        repobjs[i].levels = strings.clone_to_cstring(r);
        repobjs[i].valid_p1 = check_report_p1(r);
        repobjs[i].valid_p2 = check_report_p2(r);

        valid_counts_p1[i] = 0 if i == 0 else valid_counts_p1[i-1];
        if repobjs[i].valid_p1 {
            valid_counts_p1[i] += 1;
        }

        valid_counts_p2[i] = 0 if i == 0 else valid_counts_p2[i-1];
        if repobjs[i].valid_p2 {
            valid_counts_p2[i] += 1;
        }
    }

    //for o in repobjs {
    //    fmt.printfln("%v", o);
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
check_report_p1 :: proc(report: string) -> bool {
    curr := 0
    pos := 0;
    dir := 0;

    val, _ := strconv.parse_int(report[curr:], 10, &pos);
    curr += pos + 1;

    for curr < len(report) {
        other, _ := strconv.parse_int(report[curr:], 10, &pos);
        curr += pos + 1;

        //fmt.printfln("%v vs. %v", val, other);
        diff := math.abs(val - other);
        if dir > 0 && val > other || dir < 0 && val < other || val == other || diff > 3 {
            //fmt.println();
            return false
        }

        if dir == 0 {
            dir = other - val;
        }
        val = other;
    }

    //fmt.println();
    return true;
}

@(private="file")
check_report_p2 :: proc(report: string) -> bool {
    if check_report_p1(report) {
        return true;
    }

    fmt.printfln("[P2] %v", report);
    for _, i in report {
        parts := []string {
            report[:i],
            report[i+1:],
        };
        test, _ := strings.concatenate(parts);
        fmt.printfln(" - %v", test);
        //TODO: Handle spaces, probably parse properly
    }
    fmt.println();

    return true;
}
