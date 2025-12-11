package main


import "core:fmt"
import "core:mem"
import tools "ferramentas:montando_grafos"
import gf "nucleo:grafo"
import so "nucleo:solucao"
import sl "nucleo:solucao/bfs"

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

	grafo := tools.montar_grafo_simples()

	solucao, passos := sl.bfs(grafo)

	fmt.println("Segundo o emanuel, a solução para este labirinto é:")
	for s in solucao {
		fmt.println(s.valor)
	}


	fmt.println(passos)

	for passo := so.pop(passos); passo != nil; passo = so.pop(passos) {
		fmt.println(passo)

	}

	append(&nos2,no_inicio)
	append(&nos2,no_fim)

	arestas, relacao_arestas := lb.pegar_arestas(labirinto,no_inicio,no_fim,nos2,relacao_nos)
	fmt.println("\nArestas encontrados:")
	lb.imprimir_labirinto(labirinto)

	for a in arestas {
		fmt.printfln("Aresta: %d, peso: %f, no1: %d, no2: %d", a.valor,a.peso, a.no1.valor, a.no2.valor)
	}

	
	for &n in nos {
		gf.destroy_no(&n)
	}

	for &a in arestas{
		gf.destroy_aresta(&a)
	}

	for _,r in relacao_arestas {
		delete(r)
	}

	delete(relacao_nos)
	delete(relacao_arestas)
	delete(nos)
	delete(nos2)
	delete(arestas)


	gf.destroy_no(&no_inicio)
	gf.destroy_no(&no_fim)
	

	lb.destroy_labirinto(&labirinto)
}
