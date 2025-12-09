package dfs

import "core:container/queue"
import "core:fmt"
import gf "nucleo:grafo"
import solucao "nucleo:solucao"

VetorTentativas :: [dynamic]^solucao.PilhaPassos

/*
 Recebe como argumento um grafo e retorna, em primeiro lugar, a
 lista de tentativas realizadas para solucionar o grafo do labirinto,
 e em segundo lugar a solução encontrada pelo método no labirinto
 */

no_visitado :: proc(lista: ^[dynamic]int, valor: int) -> bool {
	assert(lista != nil)
	for i in 0 ..< len(lista) {
		if lista[i] == valor do return true
	}
	return false
}

dfs :: proc(grafo: ^gf.Grafo) -> (VetorTentativas, ^solucao.PilhaPassos) {
	pilha_passos := solucao.create_passos()
	lista_tentativas := make([dynamic]^solucao.PilhaPassos)

	lista_visitados := make([dynamic]int)
	defer delete(lista_visitados)

	lista_percurso := new(queue.Queue(^gf.No))
	defer free(lista_percurso)

	queue.init(lista_percurso, 64)
	defer queue.destroy(lista_percurso)

	queue.push(lista_percurso, grafo.inicio)

	for {
		fmt.println("OI")
		node, ok := queue.pop_back_safe(lista_percurso)
		if !ok do break
		if node.valor == grafo.fim.valor do return lista_tentativas, pilha_passos

		if no_visitado(&lista_visitados, node.valor) do continue

		append(&lista_visitados, node.valor)
		// solucao.push(pilha_passos, gf.pegar_aresta(grafo, node.valor))
		for aresta in node.arestas {
			if no_visitado(&lista_visitados, aresta.no2.valor) do continue
			queue.push_back(lista_percurso, aresta.no2)
		}
	}

	// append(&lista_visitados, grafo.fim.valor)
	for item in lista_visitados {
		fmt.printf("%i ", item)
	}
	fmt.println("")

	// pilha_percursao := solucao.create_passos()
	// defer solucao.destroy_pilha(&pilha_percursao)

	// lista_visitados := make([dynamic]int)
	// defer free(lista_visitados)


	// for {
	// 	visited := false
	// 	for i in 0 ..< len(node.arestas) {
	// 		for visitado in lista_visitados {
	// 		    if i == visitado
	// 		}
	// 		solucao.push(pilha_passos, node.arestas[i])
	// 	}
	// }

	return lista_tentativas, pilha_passos
}
