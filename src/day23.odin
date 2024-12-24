package main
import "core:c"
import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

@(private="file")
input_file :: "../data/day23.ex" when EXAMPLE else "../data/day23.in"

@(private="file")
Vertex :: struct {
    name: string,
    edges: [dynamic]int,
};

@(private="file")
verts: [dynamic]Vertex;

@(private="file")
triples: [dynamic][3]int;

d23run :: proc (p1, p2: ^strings.Builder) {
    input := strings.trim(#load(input_file, string) or_else "", "\r\n");
    reg := make(map[string]int);
    verts = make([dynamic]Vertex, 0, 512);

    for conn in strings.split_lines_iterator(&input) {
        cpus := strings.split(conn, "-");
        left, right := cpus[0], cpus[1];
        //fmt.printfln("    '%v' connects to '%v'", left, right);

        if _, ok := reg[left]; !ok {
            reg[left] = len(verts);
            append(&verts, Vertex{ left, {} });
        }
        if _, ok := reg[right]; !ok {
            reg[right] = len(verts);
            append(&verts, Vertex{ right, {} });
        }

        append(&verts[reg[left]].edges, reg[right]);
        append(&verts[reg[right]].edges, reg[left]);
    }
    //fmt.printfln("registry: %v", reg);
    //fmt.println("vertices:");

    triples = make([dynamic][3]int);
    closed := make(map[int]Phantom);
    for _, vidx in reg {
        v := verts[vidx];
        //fmt.printfln("[EXPLORE] %v", v);
        marked: map[int]Phantom;
        for i in v.edges do if !(i in closed) {
            marked[i] = {};
        }
        //fmt.printfln("    %v", marked);

        for uidx in marked {
            u := verts[uidx];
            for widx in u.edges do if widx in marked {
                new_trip: [3]int = { vidx, uidx, widx };
                append(&triples, new_trip);
            }
            delete_key(&marked, uidx);
        }
        closed[vidx] = {};
    }
    //fmt.println("triples:");
    //for t in triples {
    //    for i in t {
    //        fmt.printf("%v, ", verts[i].name);
    //    }
    //    fmt.println();
    //}

    res_p1 := 0;
    for trip in triples {
        if find_t(trip) do res_p1 += 1;
    }
    strings.write_int(p1, res_p1);
    strings.write_int(p2, 23);

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

find_t :: proc (trip: [3]int) -> bool {
    for idx in trip do if strings.starts_with(verts[idx].name, "t") {
        return true;
    }
    return false;
}
