package main
import "core:fmt"
import "core:strings"

when 1 == 1 {
    @(private="file")
    input_file :: "../data/day0.example"
}
else {
    @(private="file")
    input_file :: "../data/day0.input"
}

d0run :: proc () {
    //input := #load(input_file);
}

//@(private="file")
//func :: proc () {
//}
