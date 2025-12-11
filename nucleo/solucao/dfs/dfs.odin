package dfs

import stack "core:container/queue"
import "core:fmt"
import gf "nucleo:grafo"
import solucao "nucleo:solucao"

/*
 Recebe como argumento um grafo e retorna, em primeiro lugar, a
 lista de tentativas realizadas para solucionar o grafo do labirinto,
 e em segundo lugar a solução encontrada pelo método no labirinto
 */
dfs :: proc(grafo: ^gf.Grafo) -> ([dynamic]^solucao.PilhaPassos, ^solucao.PilhaPassos) {
	node_stack: stack.Queue(^gf.No)
	stack.init(&node_stack)
	defer stack.destroy(&node_stack)

	visited := make(map[^gf.No]bool)
	defer delete(visited)

	resulting_path := make([dynamic]^gf.No)

	stack.push_back(&node_stack, grafo.inicio)
	current_node := grafo.inicio

	tentativas := make([dynamic]^solucao.PilhaPassos)
	passos := solucao.create_passos()

	for current_node != grafo.fim {
		current_node, _ := stack.pop_back_safe(&node_stack)
		if current_node == nil do break
		was_visited, ok := visited[current_node]
		if was_visited do continue

		fmt.println("Nó atual: %v", current_node.valor)

		map_insert(&visited, current_node, true)
		append(&resulting_path, current_node)

		has_children := false
		#reverse for aresta in current_node.arestas {
			has_children = true
			stack.push_back(&node_stack, gf.no_na_outra_ponta(aresta, current_node))
			solucao.push(passos, aresta)
		}

		if !has_children && current_node != grafo.fim {
			clone, err := new_clone(passos^)
			assert(err == .None)
			append(&tentativas, clone)
			solucao.pop(passos)
			continue
		}
	}

	return tentativas, passos
}
