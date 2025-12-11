package a_estrela

import gf "nucleo:grafo"
import solucao "nucleo:solucao"

a_estrela :: proc(grafo: ^gf.Grafo) -> ^solucao.PilhaPassos {
	q: [dynamic]^gf.Aresta
	defer delete(q)

	visited := make(map[^gf.No]bool)
	defer delete(visited)

	actual_no := grafo.inicio
	pilha_passos := solucao.create_passos()

	proxima_aresta: ^gf.Aresta

	for actual_no != grafo.fim {
		visited[actual_no] = true

		adjacencias := listar_adjacências(actual_no)

		for aresta in adjacencias {
			append(&q, aresta)
		}

		i: f16
		i = 1000

		for aresta in q {
			if i < aresta.peso {
				if visited[gf.no_na_outra_ponta(aresta, actual_no)] {
					continue
				}
				i = aresta.peso
				proxima_aresta = aresta
			}
		}

		actual_no = gf.no_na_outra_ponta(proxima_aresta, actual_no)
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
