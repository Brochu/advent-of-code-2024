package main
import "core:c"
import "core:fmt"
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

d1run :: proc () {
    input :: string(#load(input_file));
    groups := strings.split(input[:len(input)-2], "\r\n\r\n");
    defer delete(groups);

    xoffset : int = 25
    yoffset : int = 25
    xspace : int = 100
    yspace : int = 25

    totals := make([]int, len(groups));

    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        for g, i in groups {
            elves := strings.split_lines(g);
            defer delete(elves);

            total := 0;
            for e, j in elves {
                xoff := xoffset + (i*xspace);
                yoff := yoffset + (j*yspace);
                rl.DrawText(strings.clone_to_cstring(e), c.int(xoff), c.int(yoff), 25, rl.GREEN);
                val := strconv.atoi(e);
                total += val;
            }

            xtotal := c.int(xoffset + (i*xspace));
            ytotal := c.int(yoffset + (len(elves)*yspace));
            rl.DrawText(rl.TextFormat("%i", total), xtotal, ytotal, 25, rl.RED);

            totals[i] = total;
        }
        slice.reverse_sort(totals);
        rl.DrawText(rl.TextFormat("%i", totals[0]), 350, 550, 25, rl.BLUE);
        p2 := totals[0] + totals[1] + totals[2];
        rl.DrawText(rl.TextFormat("%i", p2), 650, 550, 25, rl.BLUE);

        rl.EndDrawing();
    }
}
