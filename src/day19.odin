package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day19.ex" when EXAMPLE else "../data/day19.in"

@(private="file")
cache: map[string]bool;

d19run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    elems := strings.split(input, "\n\n");

    inv := make([dynamic]string, 0, 512);
    for towel in strings.split_iterator(&elems[0], ", ") do append(&inv, towel);
    //fmt.printfln("TOWELS: %v", inv);

    designs := make([dynamic]string, 0, 512);
    for design in strings.split_lines_iterator(&elems[1]) do append(&designs, design);
    //fmt.println("DESIGNS:");
    //for d in designs {
    //    fmt.printfln("    '%v'", d);
    //}

    context.user_ptr = &inv;
    valid_p1 := slice.mapper(designs[:], proc (d: string) -> bool {
        inv: []string = (cast(^[]string)context.user_ptr)^;
        return check_p1(d, inv);
    });
    count_p2 := slice.mapper(designs[0:1], proc (d: string) -> int {
        inv: []string = (cast(^[]string)context.user_ptr)^;
        count := 0;
        enum_p2(d, inv, &count);
        return count;
    });

    strings.write_int(p1, slice.count(valid_p1, true));
    strings.write_int(p2, slice.reduce(count_p2, 0, proc (acc, val: int) -> int {
        return acc + val;
    }));

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

check_p1 :: proc (des: string, inv: []string) -> bool {
    if len(des) == 0 do return true;
    if res, ok := cache[des]; ok {
        return res;
    }

    //fmt.printfln("[CHECK] %v", des);
    for towel in inv {
        if strings.has_prefix(des, towel) && check_p1(strings.trim_prefix(des, towel), inv) {
            cache[des] = true;
            return true;
        }
    }
    cache[des] = false;
    return false;
}

enum_p2 :: proc (des: string, inv: []string, count: ^int) {
    count^ += 1;
}
