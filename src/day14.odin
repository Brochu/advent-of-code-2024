package main
import "core:c"
import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day14.ex" when EXAMPLE else "../data/day14.in"

@(private="file")
Robot :: struct {
    pos: Vec2,
    vel: Vec2,
};

@(private="file")
XDIM :: 11 when EXAMPLE else 101;
@(private="file")
YDIM :: 7 when EXAMPLE else 103;
@(private="file")
TIME :: 100;

@(private="file")
Colors: []rl.Color = {
    rl.WHITE,
    rl.RED,
    rl.ORANGE,
    rl.YELLOW,
    rl.GREEN,
    rl.SKYBLUE,
    rl.BLUE,
    rl.DARKBLUE,
    rl.PURPLE,
    rl.PINK,
    rl.MAROON,
    rl.BROWN,
    rl.GRAY,
};

d14run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    robots := slice.mapper(strings.split_lines(input), proc (line: string) -> Robot {
        elems := strings.split(line, " ");
        pos := 0;
        px, _ := strconv.parse_int(elems[0][2:], 10, &pos);
        py, _ := strconv.parse_int(elems[0][2+pos+1:]);

        pos = 0;
        vx, _ := strconv.parse_int(elems[1][2:], 10, &pos);
        vy, _ := strconv.parse_int(elems[1][2+pos+1:]);
        return { { px, py } , { vx, vy } };
    });

    steps := make([dynamic][]Robot, 0, TIME);
    append(&steps, slice.clone(robots));

    for sec in 0..<100 {
        for i in 0..<len(robots) {
            sim_robot(&robots[i]);
        }
        append(&steps, slice.clone(robots));
    }

    for robot in robots {
        quad, ok := find_quadrant(robot);
        fmt.printfln("    pos: %v -> [%v] %v", robot.pos, ok, quad);
    }

    strings.write_int(p1, 14);
    strings.write_int(p2, 14);

    /*
    when EXAMPLE do xoff, yoff := c.int(125), c.int(200);
    else do xoff, yoff := c.int(50), c.int(10);
    spacing := c.int(50) when EXAMPLE else c.int(7);
    font := c.int(25) when EXAMPLE else c.int(5);
    margin := c.int(5) when EXAMPLE else c.int(1);

    fnum := 0;
    time := 5;
    rl.InitWindow(800, 750, strings.to_cstring(&title));
    rl.SetTargetFPS(60);
    for !rl.WindowShouldClose() {
        //if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
        //    fnum += time;
        //}

        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        for y in 0..<YDIM do for x in 0..<XDIM {
            px := c.int(xoff + (c.int(x) * spacing));
            py := c.int(yoff + (c.int(y) * spacing));

            step := steps[fnum/time];
            cell := Vec2 { x, y };
            context.user_ptr = &cell;
            count := slice.count_proc(step, proc (r: Robot) -> bool {
                return r.pos == (cast(^Vec2)context.user_ptr)^;
            });

            rl.DrawRectangleLines(px, py, spacing-margin, spacing-margin, Colors[count]);
            rl.DrawText(rl.TextFormat("%i", fnum), 15, 750-25, 15, rl.WHITE);
        }
        rl.EndDrawing();
        fnum = math.clamp(fnum+1, 0, (len(steps) * time)-1);
    }
    rl.CloseWindow();
    */
}

print_robots :: proc (robots: []Robot) {
    fmt.println("ROBOTS:");
    for r in robots do fmt.printfln("    %v", r);
}

sim_robot :: proc (robot: ^Robot) {
    robot.pos += robot.vel;

    if robot.pos.x < 0 do robot.pos.x += XDIM;
    if robot.pos.x >= XDIM do robot.pos.x -= XDIM;

    if robot.pos.y < 0 do robot.pos.y += YDIM;
    if robot.pos.y >= YDIM do robot.pos.y -= YDIM;
}

find_quadrant :: proc (robot: Robot) -> (int, bool) {
    return 0, false;
}
