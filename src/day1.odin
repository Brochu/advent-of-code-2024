package main
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

when 1 == 1 {
    @(private="file")
    input_file :: "../data/day1.example"
}
else {
    @(private="file")
    input_file :: "../data/day1.input"
}

d1run :: proc () {
    input := #load(input_file);

    elves := strings.split(string(input), "\r\n\r\n");
    defer delete(elves);

    packs := make([]int, len(elves));
    defer delete(packs);

    //fmt.printfln("elves count: %d", len(elves));
    for e, i in elves {
        //fmt.println("GROUP:");
        cals := strings.split(e, "\r\n");
        for c in cals {
            packs[i] += strconv.atoi(c);
        }
        //fmt.printfln("\ntotal: %d\n--------------------", packs[i]);
    }

}
