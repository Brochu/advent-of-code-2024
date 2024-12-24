package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:slice/heap"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day24.ex" when EXAMPLE else "../data/day24.in"

@(private="file")
signals: map[string]u8;

@(private="file")
Gate :: struct {
    left: string,
    right: string,
    op: string,
    out: string,
};

@(private="file")
pending: [dynamic]Gate;

@(private="file")
Result :: struct {
    name: string,
    signal: u8,
};

d24run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    elems := strings.split(input, "\n\n");

    signals = make(map[string]u8);
    for s in strings.split_lines_iterator(&elems[0]) {
        vals := strings.split(s, ": ");
        signals[vals[0]] = cast(u8)strconv.atoi(vals[1]);
    }
    //fmt.printfln("signals: %v", signals);

    pending = make([dynamic]Gate, 0, 512);
    for g in strings.split_lines_iterator(&elems[1]) {
        l := g[0:3];
        op := strings.trim_space(g[4:7]);
        end := strings.split_n(g[4:], " ", 2)[1];
        others := strings.split(end, " -> ");
        append(&pending, Gate{ l, others[0], op, others[1] });
        heap.push(pending[:], heap_proc);
    }
    //fmt.println("gates:");
    //for gate in pending {
    //    fmt.printfln("  %v", gate);
    //}

    for len(pending) > 0 {
        heap.pop(pending[:], heap_proc);
        curr := pop(&pending);
        //fmt.printfln("signals: %v", signals);
        //fmt.printfln("gate: %v", curr);

        if strings.compare(curr.op, "OR") == 0 {
            signals[curr.out] = signals[curr.left] | signals[curr.right];
        }
        else if strings.compare(curr.op, "AND") == 0 {
            signals[curr.out] = signals[curr.left] & signals[curr.right];
        }
        else if strings.compare(curr.op, "XOR") == 0 {
            signals[curr.out] = signals[curr.left] ~ signals[curr.right];
        }
    }

    res := make([dynamic]Result, 0, 256);
    for k, v in signals do append(&res, Result{ k, v });
    slice.sort_by(res[:], proc (l, r: Result) -> bool {
        return strings.compare(l.name, r.name) < 0;
    });
    idx, _ := slice.linear_search_proc(res[:], proc (r: Result) -> bool {
        return strings.starts_with(r.name, "z");
    });

    val_p1: u64 = 0;
    fmt.println("signals:");
    #reverse for s in res[idx:] {
        val_p1 <<= 1;
        if s.signal == 1 do val_p1 += 1;

        fmt.printfln("  %v", s);
    }

    strings.write_u64(p1, val_p1);
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

heap_proc :: proc (l, r: Gate) -> bool {
    lcnt := 0;
    if l.left in signals do lcnt += 1;
    if l.right in signals do lcnt += 1;

    rcnt := 0;
    if r.left in signals do rcnt += 1;
    if r.right in signals do rcnt += 1;

    return lcnt < rcnt;
}
