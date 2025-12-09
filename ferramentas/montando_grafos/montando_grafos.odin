/*
 Esta parte tem como único objetivo ser capaz de gerar grafos para testes
 */

package montando_grafos

import gf "nucleo:grafo"

montar_grafo_simples::proc() -> (^gf.Grafo) {
    no_inicial := gf.create_no(0)
    no_final := gf.create_no(9)
    lista_nos := make([dynamic]^gf.No,0,8)

    for i in 1..<9 {
        append(&lista_nos,gf.create_no(i))
    }

    lista_arestas := make([dynamic]^gf.Aresta)

    append(&lista_arestas,gf.create_aresta(no_inicial,lista_nos[1],0))
    append(&lista_arestas,gf.create_aresta(lista_nos[1],lista_nos[0],1))
    append(&lista_arestas,gf.create_aresta(lista_nos[1],lista_nos[2],2))
    append(&lista_arestas,gf.create_aresta(lista_nos[2],lista_nos[3],3))
    append(&lista_arestas,gf.create_aresta(lista_nos[2],lista_nos[5],4))
    append(&lista_arestas,gf.create_aresta(lista_nos[3],lista_nos[4],5))
    append(&lista_arestas,gf.create_aresta(lista_nos[3],lista_nos[7],6))
    append(&lista_arestas,gf.create_aresta(lista_nos[7],lista_nos[6],7))
    append(&lista_arestas,gf.create_aresta(lista_nos[7],no_final,8))
    
    return gf.create_grafo(no_inicial,no_final,lista_nos,lista_arestas)
}

montar_grafo_complexo::proc() -> (^gf.Grafo) {
    no_inicial := gf.create_no(0)
    no_final := gf.create_no(83)
    lista_nos := make([dynamic]^gf.No,0,83)

    for i in 1..<83 {
        append(&lista_nos,gf.create_no(i))
    }

    lista_arestas := make([dynamic]^gf.Aresta)

    append(&lista_arestas,gf.create_aresta(no_inicial,lista_nos[1],0))
    append(&lista_arestas,gf.create_aresta(lista_nos[1],lista_nos[0],1))
    append(&lista_arestas,gf.create_aresta(lista_nos[1],lista_nos[2],2))
    append(&lista_arestas,gf.create_aresta(lista_nos[2],lista_nos[3],3))
    append(&lista_arestas,gf.create_aresta(lista_nos[2],lista_nos[5],4))
    append(&lista_arestas,gf.create_aresta(lista_nos[3],lista_nos[4],5))
    append(&lista_arestas,gf.create_aresta(lista_nos[3],lista_nos[7],6))
    append(&lista_arestas,gf.create_aresta(lista_nos[7],lista_nos[6],7))
    append(&lista_arestas,gf.create_aresta(lista_nos[7],no_final,8))
    
    return gf.create_grafo(no_inicial,no_final,lista_nos,lista_arestas)
}