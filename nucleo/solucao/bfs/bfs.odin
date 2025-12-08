package bfs

import "core:container/queue"
import gf "nucleo:grafo"
import solucao "nucleo:solucao"

/*
 Recebe como argumento um grafo e retorna, em primeiro lugar, a
 lista de tentativas realizadas para solucionar o grafo do labirinto,
 e em segundo lugar a solução encontrada pelo método no labirinto
 */
bfs :: proc(grafo: ^gf.Grafo) -> [dynamic]^gf.No {


	q: queue.Queue(^gf.No)
	queue.init(&q)
	visited := make(map[^gf.No]bool)
	passos: [dynamic]^gf.No
	actual_no := grafo.inicio

	for actual_no != grafo.fim {
		append(&passos, actual_no)
		visited[actual_no] = true
		irmoes, _ := listar_irmoes(actual_no)

		enqueue_irmoes(&q, irmoes)

		_, ok := visited[actual_no]

		for ok {
			actual_no = queue.pop_front(&q)
		}
	}
	// q: queue.Queue(^gf.No)
	// queue.init(&q)
	// visited := make(map[^gf.No]bool)
	// passos: [dynamic]gf.Aresta
	// actual_no := grafo.inicio
	//
	// for actual_no != grafo.fim {
	//
	// 	visited[actual_no] = true
	// 	irmoes, step := listar_irmoes(actual_no)
	//
	// 	for aresta, index in step {
	// 		append(&passos, aresta)
	// 	}
	//
	// 	enqueue_irmoes(&q, irmoes)
	// 	actual_no = queue.pop_front(&q)
	//
	// 	_, ok := visited[actual_no]
	//
	// 	if ok {
	// 		actual_no = queue.pop_front(&q)
	// 	}
	//
	// }

	return passos
}

listar_irmoes :: proc(no: ^gf.No) -> ([dynamic]^gf.No, [dynamic]^gf.Aresta) {

	irmoes: [dynamic]^gf.No
	arestas: [dynamic]^gf.Aresta

	for aresta in no.arestas {
		append(&arestas, aresta)
		append(&irmoes, gf.no_na_outra_ponta(aresta, no))
	}

	return irmoes, arestas
}

enqueue_irmoes :: proc(q: ^queue.Queue(^gf.No), irmoes: [dynamic]^gf.No) {
	for no in irmoes {
		queue.push_back(q, no)
	}
}
