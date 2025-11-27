package grafo

import "core:fmt"
Grafo :: struct {
    inicio,fim: ^No,
    nos: [dynamic]No
}

print_dados::proc(grafo:^Grafo) {
    fmt.printfln("%v",grafo)
}