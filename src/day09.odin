package main
import "core:c"
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
}

d9run :: proc (p1, p2: ^strings.Builder) {
    input := transmute([]u8)strings.trim(#load(input_file, string) or_else "", "\r\n");
    mem_blocks_p1 := make([dynamic]int, 0, len(input));
    free_blocks_p1 := make([dynamic]Segment, 0, len(input));
    file_blocks_p1 := make([dynamic]Segment, 0, len(input));

    free_blocks_p2 := make([dynamic]Segment, 0, len(input));
    file_blocks_p2 := make([dynamic]Segment, 0, len(input));

    pos := 0;
    for c, i in input {
        size := int(c - '0');
        id := -1;
        q_p1 : ^[dynamic]Segment;
        q_p2 : ^[dynamic]Segment;

        if (i % 2) == 1 {
            q_p1 = &free_blocks_p1
            q_p2 = &free_blocks_p2
        }
        else {
            id = i / 2
            q_p1 = &file_blocks_p1
            q_p2 = &file_blocks_p2
        }

        for i in 0..<size {
            append(&mem_blocks_p1, id);
            append(q_p1, Segment{ pos+i, 1 });
        }
        if size > 0 do append(q_p2, Segment { pos, size });
        pos += size;
    }
    mem_blocks_p2 := slice.clone(mem_blocks_p1[:]);

    for len(free_blocks_p1) > 0 {
        free_segment := free_blocks_p1[0];
        ordered_remove(&free_blocks_p1, 0);
        file_segment := file_blocks_p1[len(file_blocks_p1)-1];
        ordered_remove(&file_blocks_p1, len(file_blocks_p1)-1);

        if free_segment.pos >= file_segment.pos do break;
        slice.swap(mem_blocks_p1[:], free_segment.pos, file_segment.pos);
    }
    //fmt.printfln("%v", mem_blocks_p1);

    #reverse for file in file_blocks_p2 {
        fmt.printfln(" -%v", file);
        // Rework this, try to move each file once
        // place on best free space from start
    }
    //fmt.printfln("%v", mem_blocks_p2);
    //for free in free_blocks_p2 {
    //    fmt.printfln("%v", free);
    //}
    //fmt.println();
    //for file in file_blocks_p2 {
    //    fmt.printfln("%v", file);
    //}

    res_p1 := 0;
    for block, i in mem_blocks_p1 {
        if block != -1 {
            res_p1 += block * i;
        }
    }
    res_p2 := 0;
    for block, i in mem_blocks_p2 {
        if block != -1 {
            res_p2 += block * i;
        }
    }

    strings.write_int(p1, res_p1);
    strings.write_int(p2, res_p2);

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

free_of_size :: proc(free_blocks: [dynamic]Segment, filesize: int) -> int {
    for free, i in free_blocks {
        if free.size >= filesize do return i;
    }
    return -1;
}
