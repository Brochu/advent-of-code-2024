package main
import "core:c"
import "core:container/queue"
import "core:fmt"
import "core:math"
import "core:slice"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day09.ex" when EXAMPLE else "../data/day09.in"

d9run :: proc (p1, p2: ^strings.Builder) {
    input := transmute([]u8)strings.trim(#load(input_file, string) or_else "", "\r\n");
    mem_blocks_p1 := make([dynamic]int, 0, len(input));
    mem_blocks_p2 := make([dynamic]int, 0, len(input));

    free_blocks : queue.Queue([]int);
    queue.init(&free_blocks);

    file_blocks : queue.Queue([]int);
    queue.init(&file_blocks);

    pos := 0;
    for c, i in input {
        size := int(c - '0');
        id := -1;
        q : ^queue.Queue([]int);

        if (i % 2) == 1 {
            q = &free_blocks
        }
        else {
            id = i / 2
            q = &file_blocks
        }

        for i in 0..<size {
            idx := i + pos;
            queue.push_back(q, idx); //TODO: Figure out slice syntax
            append(&mem_blocks_p1, id);
        }
        pos += size;
    }

    for queue.len(free_blocks) > 0 {
        file_index := queue.pop_back(&file_blocks);
        free_index := queue.pop_front(&free_blocks);

        if free_index >= file_index do break;
        slice.swap(mem_blocks_p1[:], file_index, free_index);
    }

    res_p1 := 0;
    for block, i in mem_blocks_p1 {
        if block == -1 do break;

        res_p1 += block * i;
    }

    strings.write_int(p1, res_p1);
    strings.write_int(p2, 2);

    /*
    rl.InitWindow(800, 600, strings.to_cstring(&title));
    rl.SetTargetFPS(60);

    fnum : f32 = 0;
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.ColorFromHSV(math.sin(fnum) * 360, 1, 1));
        rl.DrawText(rl.TextFormat("%i; %f", fnum, math.sin(fnum) * 360), 15, 15, 25, rl.WHITE);

        rl.EndDrawing();
        fnum += 0.01;
    }
    rl.CloseWindow();
    */
}
