package bfs

import "core:container/queue"
import gf "nucleo:grafo"
import solucao "nucleo:solucao"

/*
 Recebe como argumento um grafo e retorna, em primeiro lugar, a
 lista de tentativas realizadas para solucionar o grafo do labirinto,
 e em segundo lugar a solução encontrada pelo método no labirinto
1 */
bfs :: proc(grafo: ^gf.Grafo) -> ^solucao.PilhaPassos {


	q: queue.Queue(^gf.No)
	queue.init(&q)
	defer queue.destroy(&q)

	visited := make(map[^gf.No]bool)
//	passos: [dynamic]^gf.No
	actual_no := grafo.inicio
	pilha_passos := solucao.create_passos()

	defer {
		queue.destroy(&q)
		delete(visited)
	}

	for actual_no != grafo.fim {

	//	append(&passos, actual_no)
		visited[actual_no] = true
		irmoes, arestas := listar_irmoes(actual_no)

		for aresta in arestas {
			solucao.push(pilha_passos, aresta)
		}

		defer delete(irmoes)
    defer delete(arestas)

		enqueue_irmoes(&q, irmoes)

		actual_no = queue.pop_front(&q)
 
		for visited[actual_no] {
			actual_no = queue.pop_front(&q)
		}
	}

//	append(&passos, actual_no)
	return pilha_passos
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
