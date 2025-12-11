package a_estrela

import "core:fmt"
import gf "nucleo:grafo"
import solucao "nucleo:solucao"

a_estrela :: proc(grafo: ^gf.Grafo) -> ^solucao.PilhaPassos {
	q: [dynamic]^gf.Aresta
	defer delete(q)

	visited := make(map[int]bool)
	defer delete(visited)

	actual_no := grafo.inicio
	pilha_passos := solucao.create_passos()

	proxima_aresta: ^gf.Aresta

	for actual_no != grafo.fim {
		visited[actual_no.valor] = true

		adjacencias := listar_adjacências(actual_no)

		for aresta in adjacencias {
			append(&q, aresta)
		}

		i: f16
		i = 1000

		for aresta in q {
			fmt.println("peso:", aresta.peso)
			if i > aresta.peso {
				if no_visitado(aresta.no2, visited) && no_visitado(aresta.no1, visited) {
					continue
				}
				fmt.println("pesso da vez:", aresta.peso)
				i = aresta.peso
				proxima_aresta = aresta
			}

		}

		if no_visitado(proxima_aresta.no2, visited) {
			if no_visitado(proxima_aresta.no1, visited) {
				continue
			} else {
				actual_no = proxima_aresta.no1
			}
		} else {
			actual_no = proxima_aresta.no2
		}
		//actual_no = gf.no_na_outra_ponta(proxima_aresta, actual_no)
		//
		// if visited[proxima_aresta.no1] {
		// 	if visited[proxima_aresta.no2] {
		// 		continue
		// 	} else {
		// 		actual_no = proxima_aresta.no2
		// 	}
		// } else {
		// 	actual_no = proxima_aresta.no1
		// }

		solucao.push(pilha_passos, proxima_aresta)
	}

	return pilha_passos
}

listar_adjacências :: proc(no: ^gf.No) -> [dynamic]^gf.Aresta {
	arestas: [dynamic]^gf.Aresta

	for aresta in no.arestas {
		append(&arestas, aresta)
	}

	return arestas
}

no_visitado :: proc(no: ^gf.No, mapa: map[int]bool) -> bool {
	_, ok := mapa[no.valor]

	return ok
}
