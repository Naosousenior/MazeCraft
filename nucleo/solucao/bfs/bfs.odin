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
	defer queue.destroy(&q)

	visited := make(map[^gf.No]bool)
	defer delete(visited)

	passos: [dynamic]^gf.No
	actual_no := grafo.inicio

	for actual_no != grafo.fim {
		append(&passos, actual_no)
		visited[actual_no] = true
		irmoes := listar_irmoes(actual_no)

		defer delete(irmoes)

		enqueue_irmoes(&q, irmoes)

		actual_no = queue.pop_front(&q)

		for visited[actual_no] {
			actual_no = queue.pop_front(&q)
		}
	}

	append(&passos, actual_no)
	return passos
}

listar_irmoes :: proc(no: ^gf.No) -> [dynamic]^gf.No {

	irmoes: [dynamic]^gf.No

	for aresta in no.arestas {
		append(&irmoes, gf.no_na_outra_ponta(aresta, no))
	}

	return irmoes
}

enqueue_irmoes :: proc(q: ^queue.Queue(^gf.No), irmoes: [dynamic]^gf.No) {
	for no in irmoes {
		queue.push_back(q, no)
	}
}
