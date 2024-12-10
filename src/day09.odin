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

@(private="file")
Segment :: struct {
    pos: int,
    size: int,
    slice: []int, // ???
}

d9run :: proc (p1, p2: ^strings.Builder) {
    input := transmute([]u8)strings.trim(#load(input_file, string) or_else "", "\r\n");
    mem_blocks_p1 := make([dynamic]int, 0, len(input));
    mem_blocks_p2 := make([dynamic]int, 0, len(input));

    //TODO: Might need to implement our own slice?
    // Also need to stop using queues here, swap to dynamic arrays
    // Might need to sort them based on Segment.pos
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
            append(&mem_blocks_p1, id);
            queue.push_back(q, mem_blocks_p1[pos:pos+1]);
        }
        pos += size;
    }
    fmt.printfln("%v", mem_blocks_p1);
    fmt.printfln("%v", free_blocks);
    fmt.printfln("%v", file_blocks);

    for queue.len(free_blocks) > 0 {
        file_index := queue.pop_back(&file_blocks);
        free_index := queue.pop_front(&free_blocks);

        if raw_data(free_index) >= raw_data(file_index) do break;
        slice.swap_between(file_index, free_index);
    }
    fmt.printfln("%v", mem_blocks_p1);

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
