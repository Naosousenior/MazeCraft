package main


import "core:fmt"
import "core:mem"

import gf "nucleo:grafo"
import lb "nucleo:labirinto"
import ferr "ferramentas:es"

main::proc() {
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

	nos2 := make([dynamic]^gf.No)
	for n in nos {
		append(&nos2,n)
	}

	append(&nos2,no_inicio)
	append(&nos2,no_fim)

	arestas, relacao_arestas := lb.pegar_arestas(labirinto,nos2,relacao_nos)

	fmt.println("Nós encontrados:")
	lb.imprimir_labirinto(labirinto)

	delete(relacao_nos)
	for &n in nos {
		gf.destroy_no(&n)
	}

	for &a in arestas{
		gf.destroy_aresta(&a)
	}

	delete(nos)
	delete(relacao_arestas)
	delete(nos)
	delete(nos2)
	delete(arestas)


	gf.destroy_no(&no_inicio)
	gf.destroy_no(&no_fim)
	

	lb.destroy_labirinto(&labirinto)
}