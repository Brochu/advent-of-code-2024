package main
import "core:fmt"
import "core:strings"
import ba"core:container/bit_array"
import "base:intrinsics"

when EXAMPLE {
    @(private="file") input_file :: "../data/day3.example"
}
else {
    @(private="file") input_file :: "../data/day3.input"
}

d3run :: proc () {
    input :: string(#load(input_file));
    lines := strings.split_lines(input);
    defer delete(lines);

    p1 := part1(lines);
    p2 := part2(lines);

    fmt.printfln("PART 1 = %v", p1);
    fmt.printfln("PART 2 = %v", p2);
}

@(private="file")
part1 :: proc (lines: []string) -> u64 {
    total : u64 = 0;
    for l in lines {
        str := transmute([]byte)l;
        first, okf := ba.create('z', 'A');
        second, oks := ba.create('z', 'A');
        defer ba.destroy(first);
        defer ba.destroy(second);

        for c in str[:len(str)/2] {
            ba.set(first, c);
        }
        for c in str[len(str)/2:] {
            ba.set(second, c);
        }

        idx := intrinsics.count_trailing_zeros(first.bits[0] & second.bits[0]) + u64(first.bias);
        val : u64 = 0;
        if idx <= 'Z' {
            val = idx - 'A' + 27;
        } else {
            val = idx - ('a' - 1);
        }
        //fmt.printfln("%v (%v); value = %v", idx, rune(idx), val);
        total += val;
    }
    return total;
}

@(private="file")
part2 :: proc (lines: []string) -> u64 {
    total : u64 = 0;

    for i := 0; i < len(lines); i += 3 {
        f, okf := ba.create('z', 'A');
        s, oks := ba.create('z', 'A');
        t, okt := ba.create('z', 'A');
        defer ba.destroy(f);
        defer ba.destroy(s);
        defer ba.destroy(t);

        for c in transmute([]u8)lines[i + 0] do ba.set(f, c);
        for c in transmute([]u8)lines[i + 1] do ba.set(s, c);
        for c in transmute([]u8)lines[i + 2] do ba.set(t, c);

        conj := f.bits[0] & s.bits[0] & t.bits[0];
        idx := intrinsics.count_trailing_zeros(conj) + u64(f.bias);
        val : u64 = 0;
        if idx <= 'Z' {
            val = idx - 'A' + 27;
        } else {
            val = idx - ('a' - 1);
        }
        //fmt.printfln("%v (%v); value = %v", idx, rune(idx), val);
        total += val;
    }
    return total;
}
