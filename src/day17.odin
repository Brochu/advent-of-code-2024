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
pc: int;

@(private="file")
operations: []proc (operand: u8) = {
    adv,
    bxl,
    bst,
    jnz,
    bxc,
    out,
    bdv,
    cdv,
}

d17run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    elems := strings.split(input, "\n\n");

    for rline, i in strings.split_lines(elems[0]) {
        regs[cast(Registers)i] = strconv.atoi(rline[12:]);
    }
    fmt.printfln("%v", regs);

    prog := make([dynamic]u8, 0, len(elems[1]));
    elems[1] = elems[1][9:];
    for val in strings.split_iterator(&elems[1], ",") {
        append(&prog, val[0] - '0');
    }
    fmt.printfln("%v", prog);

    for pc = 0; pc < len(prog); pc += 2 {
        opcode  := prog[pc+0];
        operand := prog[pc+1];
        operations[opcode](operand);
    }

    strings.write_string(p1, "D17 - P1");
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
adv :: proc (cop: u8) {
    fmt.printfln("[ADV] %v", cop);
}

@(private="file")
bxl :: proc (lop: u8) {
    fmt.printfln("[BXL] %v", lop);
}

@(private="file")
bst :: proc (cop: u8) {
    fmt.printfln("[BST] %v", cop);
}

@(private="file")
jnz :: proc (cop: u8) {
    fmt.printfln("[JNZ] %v", cop);
}

@(private="file")
bxc :: proc (_: u8) {
    fmt.printfln("[BXC]");
}

@(private="file")
out :: proc (cop: u8) {
    fmt.printfln("[OUT] %v", cop);
}

@(private="file")
bdv :: proc (_: u8) {
    fmt.printfln("[BDV]");
}

@(private="file")
cdv :: proc (_: u8) {
    fmt.printfln("[CDV]");
}
