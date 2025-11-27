package main

import gf "nucleo/grafo"

main::proc() {
    grafo := gf.Grafo{
        inicio = &gf.No{valor=0},
        fim = &gf.No{valor=1}
    }

    gf.print_dados(&grafo)
}