package main
import "core:c"
import "core:fmt"
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

    max := 0;

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

            if (max < total) {
                max = total;
            }
        }
        rl.DrawText(rl.TextFormat("%i", max), 650, 550, 25, rl.BLUE);

        rl.EndDrawing();
    }
}
