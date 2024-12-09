package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day07.ex" when EXAMPLE else "../data/day07.in"

@(private="file")
Op :: enum {
    Add,
    Mult,
    Cat,
}

@(private="file")
Equation :: struct {
    res: i64,
    ops: [dynamic]i64,

    is_valid_p1 : bool,
    is_valid_p2 : bool,
    good_comb : []Op,
}

d7run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");

    eqs := make([dynamic]Equation);
    total_p1 : i64 = 0;
    total_p2 : i64 = 0;
    for line in strings.split_lines_iterator(&input) {
        eq : Equation;
        pos := 0;
        r, ok := strconv.parse_i64(line, 10, &pos);
        eq.res = r;

        //eq.ops = make([dynamic]i64, 0, 10);
        nums := strings.split(line[pos+2:], " ");
        for n in nums {
            append(&eq.ops, i64(strconv.atoi(n)));
        }

        eq.is_valid_p1 = check_equation(eq);
        if eq.is_valid_p1 {
            total_p1 += eq.res;
        }
        eq.is_valid_p2 = check_equation(eq, true);
        if eq.is_valid_p2 {
            total_p2 += eq.res;
        }
        append(&eqs, eq);
        //fmt.printfln("- %v", eq);
    }

    strings.write_i64(p1, total_p1);
    strings.write_i64(p2, total_p2);

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
check_equation :: proc(eq: Equation, p2: bool = false) -> bool {
    stack := make([]Op, 0);
    return check_equation_inner(eq, stack, p2);
}

@(private="file")
check_equation_inner :: proc(eq: Equation, stack: []Op, p2: bool) -> bool {
    //fmt.printfln("[CHECK] %v - %v", eq, stack);

    if len(stack) == len(eq.ops) - 1 {
        val : i64 = eq.ops[0];

        for i in 0..<len(stack) {
            switch stack[i] {
            case .Add : val += eq.ops[i+1];
            case .Mult : val *= eq.ops[i+1];
            case .Cat :
                buf0 : [128]byte;
                buf1 : [128]byte;
                res0 := strconv.append_int(buf0[:], val, 10);
                res1 := strconv.append_int(buf1[:], eq.ops[i+1], 10);
                out := strings.concatenate({ res0, res1 });
                val, _ = strconv.parse_i64(out);
            }
        }
        //fmt.printfln("[CHECK] FULL OPS %v -> %v = %v", eq.ops, stack, val);
        return val == eq.res;
    }

    add_stack : [][]Op = { stack, { Op.Add } };
    if check_equation_inner(eq, slice.concatenate(add_stack), p2) do return true;
    mult_stack : [][]Op = { stack, { Op.Mult } };
    if check_equation_inner(eq, slice.concatenate(mult_stack), p2) do return true;

    if p2 {
        cat_stack : [][]Op = { stack, { Op.Cat } };
        if check_equation_inner(eq, slice.concatenate(cat_stack), p2) do return true;
    }

    return false;
}
