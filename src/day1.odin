package main
import "core:c"
import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

when 0 == 1 {
    @(private="file") input_file :: "../data/day1.example"
}
else {
    @(private="file") input_file :: "../data/day1.input"
}

@(private="file")
ElfGroup :: struct {
    calories: []int,
    total: int,
}

d1run :: proc () {
    input :: string(#load(input_file));
    groups := strings.split(input[:len(input)-2], "\r\n\r\n");
    defer delete(groups);

    elfgroups := make([]ElfGroup, len(groups));
    defer {
        for eg in elfgroups {
            delete(eg.calories);
        }
        delete(elfgroups);
    }
    for g, i in groups {
        elfs := strings.split(g, "\r\n");
        eg : ElfGroup;
        eg.calories = make([]int, len(elfs));
        eg.total = 0;

        for e, j in elfs {
            eg.calories[j] = strconv.atoi(e);
            eg.total += eg.calories[j];
        }

        elfgroups[i] = eg;
    }

    xoffset : int = 25
    yoffset : int = 25
    xspace : int = 100
    yspace : int = 25
    time : int = 1;

    fnum := 0;
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        idx := fnum/time;
        g := groups[idx];
        elves := strings.split_lines(g);
        defer delete(elves);

        total := 0;
        for e, j in elves {
            xoff := xoffset;
            yoff := yoffset + (j*yspace);
            rl.DrawText(strings.clone_to_cstring(e), c.int(xoff), c.int(yoff), 25, rl.GREEN);
            val := strconv.atoi(e);
            total += val;
        }

        xtotal := c.int(xoffset);
        ytotal := c.int(yoffset + (len(elves)*yspace));
        rl.DrawText(rl.TextFormat("%i", total), xtotal, ytotal, 25, rl.RED);

        slice.sort_by(elfgroups[:idx+1], proc(l: ElfGroup, r: ElfGroup)->bool {
            return l.total > r.total;
        });
        p1 := elfgroups[0].total;
        rl.DrawText(rl.TextFormat("%i", p1), 350, 500, 25, rl.BLUE);
        if len(elfgroups[:idx+1]) >= 3 {
            p2 := elfgroups[0].total + elfgroups[1].total + elfgroups[2].total;
            rl.DrawText(rl.TextFormat("%i", p2), 350, 550, 25, rl.BLUE);
        }

        fnum += 1;
        fnum = math.clamp(fnum, 0, time*len(groups) - 1);
        rl.DrawText(rl.TextFormat("%i", fnum), 0, 575, 15, rl.WHITE);
        rl.EndDrawing();
    }
}
