package main


import "core:fmt"
import "core:mem"
import ferr "ferramentas:es"
import lb "nucleo:labirinto"
import gf "nucleo:grafo"
import sl "nucleo:solucao"
import bfs "nucleo:solucao/bfs"

main :: proc() {
	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					fmt.eprintf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	texto,ok := ferr.ler_arquivo("testes/labirinto_simples.txt")
	defer delete(texto)
	if !ok {
		fmt.println("da não fi, não achei o labirinto")
	}

	labirinto := lb.create_labirinto(texto)
	lb.imprimir_labirinto(labirinto)	

	nos,no_inicio,no_fim,relacao_nos := lb.pegar_pontos(labirinto)
	fmt.println("\nNós encontrados:")
	lb.imprimir_labirinto(labirinto)

	nos2 := make([dynamic]^gf.No)
	for n in nos {
		append(&nos2,n)
	}


	arestas, relacao_arestas := lb.pegar_arestas(labirinto,no_inicio,no_fim,nos2,relacao_nos)
	fmt.println("\nArestas encontrados:")
	lb.imprimir_labirinto(labirinto)
	lb.limpar_caminhos_visitados(labirinto)

	grafo := gf.create_grafo(no_inicio,no_fim,nos,arestas)

	passos,solucao := bfs.bfs(grafo)


	fmt.println("Solução encontrada:")
	for aresta := sl.pop(solucao); aresta != nil; aresta = sl.pop(solucao) {
		for coor in relacao_arestas[aresta.valor] {
			lb.visitar_celula(labirinto,coor)
		}
	}

	lb.imprimir_labirinto(labirinto)
}
