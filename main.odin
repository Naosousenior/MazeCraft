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
	so.destroy_pilha(&passos)
	delete(solucao)
	gf.destroy_grafo(&grafo)
}
