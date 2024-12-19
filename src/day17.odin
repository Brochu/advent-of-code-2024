package main
import "core:c"
import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day17.ex" when EXAMPLE else "../data/day17.in"

@(private="file")
Registers :: enum u8 { A, B, C };

@(private="file")
regs: [Registers]int = { .A = 0, .B = 0, .C = 0 }

@(private="file")
prog: [dynamic]u8;

@(private="file")
pc: int;

@(private="file")
operations: []proc (operand: u8) = { adv, bxl, bst, jnz, bxc, out, bdv, cdv };

@(private="file")
sb_out: strings.Builder;

d17run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    elems := strings.split(input, "\n\n");

    for rline, i in strings.split_lines(elems[0]) {
        regs[cast(Registers)i] = strconv.atoi(rline[12:]);
    }
    fmt.printfln("%v", regs);

    prog = make([dynamic]u8, 0, len(elems[1]));
    elems[1] = elems[1][9:];
    for val in strings.split_iterator(&elems[1], ",") {
        append(&prog, val[0] - '0');
    }
    fmt.printfln("%v", prog);
    strings.builder_init_len_cap(&sb_out, 0, 256);

    for pc < len(prog) {
        opcode  := prog[pc+0];
        operand := prog[pc+1];
        operations[opcode](operand);
    }
    fmt.printfln("%v", regs);

    strings.write_string(p1, strings.to_string(sb_out));
    strings.write_string(p2, "D17 - P2");

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
resolve_combo :: proc (val: u8) -> int {
    switch(val) {
    case 0:
        fallthrough;
    case 1:
        fallthrough;
    case 2:
        fallthrough;
    case 3:
        return cast(int)val;
    case 4:
        return regs[.A];
    case 5:
        return regs[.B];
    case 6:
        return regs[.C];
    };

    fmt.printfln("INVALID combo operand : %v", val);
    return -1;
}

@(private="file")
adv :: proc (cop: u8) {
    param := resolve_combo(cop);
    fmt.printfln("[ADV] (%v) %v", cop, param);
    for _ in 0..<param do regs[.A] /= 2;
    pc += 2;
}

@(private="file")
bxl :: proc (lop: u8) {
    fmt.printfln("[BXL] %v", lop);
    pc += 2;
}

@(private="file")
bst :: proc (cop: u8) {
    fmt.printfln("[BST] %v", resolve_combo(cop));
    pc += 2;
}

@(private="file")
jnz :: proc (lop: u8) {
    fmt.printfln("[JNZ] %v", lop);
    if regs[.A] != 0 {
        pc = cast(int)lop;
    }
    else {
        pc += 2;
    }
}

@(private="file")
bxc :: proc (_: u8) {
    fmt.printfln("[BXC]");
    pc += 2;
}

@(private="file")
out :: proc (cop: u8) {
    param := resolve_combo(cop);
    fmt.printfln("[OUT] %v, %v", cop, param);
    if strings.builder_len(sb_out) != 0 {
        strings.write_string(&sb_out, ",");
    }
    strings.write_int(&sb_out, param % 8);
    pc += 2;
}

@(private="file")
bdv :: proc (_: u8) {
    fmt.printfln("[BDV]");
    pc += 2;
}

@(private="file")
cdv :: proc (_: u8) {
    fmt.printfln("[CDV]");
    pc += 2;
}
