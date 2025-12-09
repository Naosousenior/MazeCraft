package main

import "core:strings"
import "core:fmt"
import "core:mem"

import lb "interface:labirinto"
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

	fmt.println(texto)
	labirinto := lb.create_labirinto(texto)

	lb.imprimir_labirinto(labirinto)

	lb.destroy_labirinto(&labirinto)
}