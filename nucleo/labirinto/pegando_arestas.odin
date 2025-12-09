package labirinto

import gf "nucleo:grafo"

/*
 procedimento para pegar as arestas de um labirinto. Observe que para ele funcionar corretamente, é necessário que:
 * Você primeiro execute a função pegar_pontos no mesmo labirinto
 * Você não limpe os caminhos visitados do labirinto depois de executar o procedimento anterior
 * Você inclua na lista de pontos, o ponto de início e de fim. Essa função não vai diferenciar essses nós dos demais
 */
pegar_arestas::proc(l:^Labirinto, nos: []^gf.No, coordenadas: map[int] [2]int) {
    //primeiro, vamos de nó em nó
    for no in nos {
        //para cada nó, temos um
    }
}