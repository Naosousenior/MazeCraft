package grafo

No :: struct {
    valor :int,
    arestas: [dynamic]^Aresta
}

create_no::proc(valor:int) -> ^No {
    novo_no := new(No)
    novo_no.valor = valor
    novo_no.arestas = make([dynamic]^Aresta)

    return novo_no
}

destroy_no::proc(ptr_no:^^No) {
    if ptr_no == nil {return}
    if ptr_no^ == nil {return}

    no := ptr_no^

    delete(no.arestas)
    free(no)

    ptr_no^ = nil
}