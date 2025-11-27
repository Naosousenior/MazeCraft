package main

import "core:fmt"
import "core:mem"
import gf "nucleo:grafo"

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

    no_inicio := gf.create_no(0)
    no_fim := gf.create_no(4)

    nos := make([dynamic]^gf.No,3)
    nos[0] = gf.create_no(1)
    nos[1] = gf.create_no(2)
    nos[2] = gf.create_no(3)

    arestas := make([dynamic]^gf.Aresta,0)

    append(&arestas,gf.create_aresta(no_inicio,nos[2],0))
    append(&arestas,gf.create_aresta(no_inicio,no_fim,1))
    append(&arestas,gf.create_aresta(nos[0],nos[2],2))
    append(&arestas,gf.create_aresta(nos[0],no_fim,3))
    append(&arestas,gf.create_aresta(nos[1],no_fim,4))
    append(&arestas,gf.create_aresta(nos[0],nos[1],5))

    grafo := gf.create_grafo(no_inicio,no_fim,nos,arestas)

    matriz_adjacencia := gf.criar_matriz_adjacencia(grafo)
    matriz_incidencia := gf.criar_matriz_incidencia(grafo)

    fmt.println("Matriz adjacencia:")
    for m in matriz_adjacencia {
        fmt.print(m)
        fmt.println("")
    }

    fmt.println("Matriz incidencia:")
    for m in matriz_incidencia {
        fmt.print(m)
        fmt.println("")
    }

    gf.destroy_grafo(&grafo)
    for i in matriz_adjacencia {
        delete(i)
    }

    for i in matriz_incidencia {
        delete(i)
    }

    delete(matriz_adjacencia)
    delete(matriz_incidencia)
}