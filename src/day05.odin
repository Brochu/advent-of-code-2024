package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day05.ex" when EXAMPLE else "../data/day05.in"

PageSet :: bit_set[10..<100];
rules : map[int]PageSet;

Update :: struct {
    display_pages : string,
    pages: [dynamic]int,
    valid : bool,
};

d5run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    elements := strings.split(input, "\n\n");

    rules = make(map[int]PageSet, len(elements[0]));
    for r in strings.split_lines(elements[0]) {
        p := 0;
        f, _ := strconv.parse_int(r, 10, &p);
        s, _ := strconv.parse_int(r[p+1:]);
        //fmt.printfln(" - '%v' -> (%v, %v)", r, f, s);
        rules[f] += { s };
    }

    /*
    fmt.println("RULES:");
    for k, v in rules {
        fmt.printfln("[%v] - %v", k, v);
    }
    fmt.println();
    */

    inupdates := strings.split_lines(elements[1])
    updates := make([]Update, len(inupdates));
    p1_res := 0;
    p2_res := 0;
    for u, i in inupdates[:] {
        nums, ok := is_valid_p1(rules, u);
        updates[i].display_pages = u;
        updates[i].pages = nums;
        updates[i].valid = ok;

        if ok {
            p1_res += nums[len(nums)/2];
        }
        else {
            //fmt.printfln("[BEFORE] %v", updates[i].pages);
            nums := slice.clone(updates[i].pages[:]);
            slice.sort_by_cmp(nums, sort_p2);
            //fmt.printfln("[AFTER ] %v", nums);

            p2_res += nums[len(nums)/2];
        }
    }

    /*
    fmt.println("UPDATES:");
    for u in updates {
        fmt.printfln("Pages: %v", u);
    }
    */

    strings.write_int(p1, p1_res);
    strings.write_int(p2, p2_res);

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

is_valid_p1 :: proc(rules: map[int]PageSet, update: string) -> ([dynamic]int, bool) {
    nums := make([dynamic]int);
    prev : PageSet;
    valid := true;

    for s in strings.split(update, ",") {
        val := strconv.atoi(s);
        append(&nums, val);
        breaks := rules[val] & prev;
        if card(breaks) > 0 do valid = false;

        prev += { val };
    }

    return nums, valid
}

sort_p2 :: proc(l, r: int) -> slice.Ordering {
    //fmt.printfln("(%v, %v)", l, rules[l]);
    //fmt.printfln("(%v, %v)", r, rules[r]);
    //fmt.println();

    if r in rules[l] {
        return .Less;
    }
    else if l in rules[r] {
        return .Greater;
    }
    else {
        return .Equal;
    }
}
