package a_estrela

import "core:container/queue"
import "core:sys/wasm/wasi"
import gf "nucleo:grafo"
import solucao "nucleo:solucao"

vizinho :: struct {
	no:               ^gf.No,
	aresta_de_origem: ^gf.Aresta,
}

a_estrela :: proc(grafo: ^gf.Grafo) -> ^solucao.PilhaPassos {
	visited := make(map[^gf.No]bool)
	defer delete(visited)

	actual_no := grafo.inicio
	pilha_de_passos := solucao.create_passos()

	for actual_no != grafo.fim {

		visited[actual_no] = true
		vizinhos := listar_vizinhos(actual_no)
		aresta_passo: ^gf.Aresta
		defer delete(vizinhos)
		i := 999999999
		for vizinho in vizinhos {
			if vizinho.aresta_de_origem.peso_origem + vizinho.aresta_de_origem.peso_fim < i {
				actual_no = vizinho.no
				aresta_passo = vizinho.aresta_de_origem

			}
		}

		solucao.push(pilha_de_passos, aresta_passo)

	}

	return pilha_de_passos

}

listar_vizinhos :: proc(no: ^gf.No) -> [dynamic]^vizinho {
	nos: ^gf.No
	arestas: ^gf.No
	vizinhoList: [dynamic]^vizinho
	for aresta in no.arestas {
		vizinhoObj := vizinho {
			no               = gf.no_na_outra_ponta(aresta, no),
			aresta_de_origem = aresta,
		}

		append(&vizinhoList, &vizinhoObj)

	}

	return vizinhoList
}
