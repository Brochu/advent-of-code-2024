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
Gate :: struct {
    left: string,
    right: string,
    op: string,
};

@(private="file")
signals: map[string]u8;

@(private="file")
outputs: map[string]Gate;

@(private="file")
cache: map[Gate]u8;

d24run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    elems := strings.split(input, "\n\n");

    signals = make(map[string]u8);
    for s in strings.split_lines_iterator(&elems[0]) {
        vals := strings.split(s, ": ");
        signals[vals[0]] = cast(u8)strconv.atoi(vals[1]);
    }
    //fmt.printfln("signals: %v", signals);

    outputs = make(map[string]Gate);
    for g in strings.split_lines_iterator(&elems[1]) {
        l := g[0:3];
        op := strings.trim_space(g[4:7]);
        end := strings.split_n(g[4:], " ", 2)[1];
        others := strings.split(end, " -> ");
        outputs[others[1]] = Gate{ l, others[0], op };
    }
    //fmt.println("gates:");
    //for out, g in outputs {
    //    fmt.printfln("  [%v]->%v", out, g);
    //}
    keys, _ := slice.map_keys(outputs)
    zs := slice.filter(keys, proc (key: string) -> bool { return strings.starts_with(key, "z") });
    slice.sort(zs);

    val_p1: u64 = 0;
    #reverse for z in zs {
        val_p1 <<= 1;
        val_p1 |= cast(u64)eval(z);
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

eval :: proc (key: string) -> u8 {
    if res, ok := signals[key]; ok do return res;

    gate := outputs[key];
    if res, ok := cache[gate]; ok do return res;

    out: u8 = 0;
    switch gate.op {
    case "OR": out = eval(gate.left)  | eval(gate.right);
    case "AND": out = eval(gate.left) & eval(gate.right);
    case "XOR": out = eval(gate.left) ~ eval(gate.right);
    }
    cache[gate] = out;
    return out;
}
