package main
import "core:c"
import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"
import th"core:thread"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day22.ex" when EXAMPLE else "../data/day22.in"

@(private="file")
PricePoint :: struct {
    units: i8,
    diff: i8,
}

@(private="file")
out_values: []int;

@(private="file")
out_prices: []PricePoint;

@(private="file")
N, THREADS :: 2000, 8;

d22run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    lines := strings.split_lines(input);
    //in_secrets := slice.mapper(lines, proc (line: string) -> int { return strconv.atoi(line); });
    in_secrets: []int = { 123 };
    out_values = make([]int, len(in_secrets));
    out_prices = make([]PricePoint, len(in_secrets) * N);

    tpool: th.Pool;
    worker: th.Task_Proc : proc (t: th.Task) {
        value := (cast(^int)t.data)^;
        for i in 0..<N {
            init := cast(i8)(value % 10);
            next_secret(&value);
            if i == 0 {
                units := cast(i8)(value % 10);
                out_prices[(t.user_index * N) + i] = PricePoint { units, cast(i8)(value % 10) - init };
            }
            else {
                units := cast(i8)(value % 10);
                pp := out_prices[(t.user_index * N) + i - 1];
                out_prices[(t.user_index * N) + i] = PricePoint { units, units - pp.units };
            }
        }
        out_values[t.user_index] = value;
    };

    th.pool_init(&tpool, context.allocator, THREADS);
    for i in 0..<len(in_secrets) {
        th.pool_add_task(&tpool, context.allocator, worker, &in_secrets[i], i);
    }
    th.pool_start(&tpool);
    th.pool_finish(&tpool);

    //fmt.printfln("-> %v", in_secrets);
    //fmt.printfln("-> %v", out_values);
    for i in 0..<len(in_secrets) {
        s := out_prices[i*N : (i*N)+N];
        out := slice.mapper(s, proc (pp: PricePoint) -> i8 {
            return pp.diff;
        });
        fmt.printfln("[%v] : %v", len(out), out);
    }

    strings.write_int(p1, slice.reduce(out_values, 0, proc (acc, val: int) -> int {
        return acc + val;
    }));
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

next_secret :: proc (val: ^int) {
    mult := val^ * 64;
    val^ = mult ~ val^;
    val^ = val^ % 16777216;

    div := cast(int)(math.trunc(cast(f32)(val^) / 32));
    val^ = div ~ val^;
    val^ = val^ % 16777216;

    big_mult := val^ * 2048;
    val^ = big_mult ~ val^;
    val^ = val^ % 16777216;
}
