package main
import "core:fmt"
import m "core:math"
import "core:strings"
import rl "vendor:raylib"

when EXAMPLE {
    @(private="file") input_file :: "../data/day2.example"
}
else {
    @(private="file") input_file :: "../data/day2.input"
}

d2run :: proc () {
    input :: string(#load(input_file));
    strin :: input[:len(input)-2];

    games := strings.split(strin, "\r\n");
    defer delete(games);
    p1frames := make([]int, len(games));
    defer delete(p1frames);
    p2frames := make([]int, len(games));
    defer delete(p2frames);

    for game, i in games {
        {
            a: u8 = game[0];
            b: u8 = game[2];
            val := shape_score(b) + win_score(game);
            if (i == 0) {
                p1frames[i] = val;
            } else {
                p1frames[i] = p1frames[i-1] + val;
            }
        }
        {
            a: u8 = game[0];
            b: u8 = game[2];
            val := shape_score2(game) + win_score2(b);
            if (i == 0) {
                p2frames[i] = val;
            } else {
                p2frames[i] = p2frames[i-1] + val;
            }
        }
    }

    time := 1;
    fnum := 0;
    for !rl.WindowShouldClose() {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        idx := fnum/time;
        rl.DrawText(rl.TextFormat("%v", games[idx]), 275, 25, 25, rl.GREEN);
        rl.DrawText(rl.TextFormat("%v; %v", p1frames[idx], p2frames[idx]), 275, 50, 25, rl.BLUE);

        fnum += 1;
        fnum = m.clamp(fnum, 0, time*len(games)-1);
        rl.DrawText(rl.TextFormat("%i", fnum), 15, 575, 15, rl.WHITE);
        rl.EndDrawing();
    }
}

@(private="file")
shape_score :: proc (chosen: u8) -> int {
    switch chosen {
        case 'X': return 1;
        case 'Y': return 2;
        case 'Z': return 3;
    }

    return -1;
}
@(private="file")
shape_score2 :: proc (game: string) -> int {
    if      game == "B X" || game == "A Y" || game == "C Z" { return 1; }
    else if game == "C X" || game == "B Y" || game == "A Z" { return 2; }
    else if game == "A X" || game == "C Y" || game == "B Z" { return 3; }
    else { return -1; }
}

@(private="file")
win_score :: proc (game: string) -> int {
    if      game == "B X" || game == "C Y" || game == "A Z" { return 0; }
    else if game == "A X" || game == "B Y" || game == "C Z" { return 3; }
    else if game == "C X" || game == "A Y" || game == "B Z" { return 6; }
    else { return -1; }
}

@(private="file")
win_score2 :: proc (chosen: u8) -> int {
    switch chosen {
        case 'X': return 0;
        case 'Y': return 3;
        case 'Z': return 6;
    }

    return -1;
}
