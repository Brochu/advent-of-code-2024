package main

import "core:fmt"
import "core:mem"
import "core:mem/virtual"
import os "core:os/os2"
import "core:strconv"
import "core:strings"

day_proc :: proc()
solutions: []day_proc = {
    d0run,
    d1run,
};

main :: proc() {
    day, valid := which_day();
    if (!valid) {
        fmt.printfln("[AoC22] Solution for day %v is not implemented yet", day);
        return;
    }

    arena : virtual.Arena;
    palloc : mem.Allocator;
    assert(virtual.arena_init_growing(&arena) == virtual.Allocator_Error.None);
    palloc, context.allocator = context.allocator, virtual.arena_allocator(&arena);
    defer {
        context.allocator  = palloc;
        virtual.arena_destroy(&arena);
    }

    fmt.printfln("[AoC22] Day %v", day);
    solutions[day]();
    //TODO: Setup timer to check processing time
}

which_day :: proc() -> (int, bool) {
    fields : os.Process_Info_Fields;
    fields = { .Command_Line, .Command_Args };

    pinfo, _ := os.current_process_info(fields, context.allocator);
    defer os.free_process_info(pinfo, context.allocator);
    /*
    fmt.println("[AoC22] Process Info :");
    fmt.printfln(" - pid = %v", pinfo.pid);
    fmt.printfln(" - cmdargs = %v", pinfo.command_args);
    fmt.println("--------------------\n");
    */

    if (len(pinfo.command_args) < 2) {
        fmt.println("[AoC22] usage: aoc22.exe <daynum>");
        return 0, false;
    }
    day := strconv.atoi(pinfo.command_args[1]);
    return day, ((day < len(solutions)) ? true : false);
}
