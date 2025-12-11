package main


import "core:fmt"
import "core:mem"
import ferr "ferramentas:es"
import lb "nucleo:labirinto"
import gf "nucleo:grafo"
import sl "nucleo:solucao"
import bfs "nucleo:solucao/bfs"
// import a_star "nucleo:solucao/a_star"

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
	defer lb.destroy_labirinto(&labirinto)

	lb.imprimir_labirinto(labirinto)	

	nos,no_inicio,no_fim,relacao_nos := lb.pegar_pontos(labirinto)
	defer delete(relacao_nos)

	fmt.println("\nNós encontrados:")
	lb.imprimir_labirinto(labirinto)

	nos2 := make([dynamic]^gf.No)
	defer delete(nos2)
	for n in nos {
		append(&nos2,n)
	}

	append(&nos2,no_inicio)
	append(&nos2,no_fim)

	arestas, relacao_arestas := lb.pegar_arestas(labirinto,no_inicio,no_fim,nos2,relacao_nos)
	defer delete(relacao_arestas)
	fmt.println("\nArestas encontrados:")
	lb.imprimir_labirinto(labirinto)
	lb.limpar_caminhos_visitados(labirinto)

	grafo := gf.create_grafo(no_inicio,no_fim,nos,arestas)
	defer gf.destroy_grafo(&grafo)

	passos, solucao := bfs.bfs(grafo)
	defer {
		for &p in passos {
			sl.destroy_pilha(&p)
		}

		sl.destroy_pilha(&solucao)
	}

	sl.visualizar_solucao(labirinto,relacao_arestas,relacao_nos,passos,solucao)
}
