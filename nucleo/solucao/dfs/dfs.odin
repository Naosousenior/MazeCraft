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
dfs :: proc(grafo: ^gf.Grafo) -> [dynamic]^gf.No {
	node_stack: stack.Queue(^gf.No)
	stack.init(&node_stack)
	defer stack.destroy(&node_stack)

	visited := make(map[^gf.No]bool)
	defer delete(visited)

	resulting_path := make([dynamic]^gf.No)

	stack.push_back(&node_stack, grafo.inicio)
	current_node := grafo.inicio

	for current_node != grafo.fim {
		current_node, ok := stack.pop_back_safe(&node_stack)
		if current_node == nil do break


		fmt.println("Nó atual: %v", current_node.valor)

		map_insert(&visited, current_node, true)
		append(&resulting_path, current_node)

		for aresta in current_node.arestas {
			_, already_visited, _, err := map_entry(&visited, aresta.no2)

			if err == nil && !already_visited^ {
				stack.push_back(&node_stack, aresta.no2)
			}
		}
	}

	append(&resulting_path, grafo.fim)

	return resulting_path
}
