package labirinto

import gf "nucleo:grafo"
import lb "nucleo:labirinto"

/*
 Percorre a matriz do labirinto, tentanto encontrar os nós
 Ao concluir, retorna a lista de nós, o nó inicial, o nó final e uma relação do valor dos nós para seu ponto na matriz.
 No labirinto, todos os pontos dos nós também vão estar marcados como visitados
 */
pegar_pontos::proc(l: ^lb.Labirinto) -> ([dynamic]^gf.No, ^gf.No, ^gf.No, map[int] [2]int) {
    //primeiro, vamos definir uma relação de pontos para mapas
    relacao_de_pontos := make(map[int] [2]int) //esse mapa vai guardar uma relação do valor do nó para a coordenada da sua célula no labirinto
    nos := make([dynamic]^gf.No)
    no_inicio: ^gf.No
    no_fim: ^gf.No

    contador_nos := 0
    i,j := 0, 0

    for linha in l.matriz {
        for celula in linha {
            //vamos então, verificar célula a célula os seus vizinhos. as células de início e de fim obrigatóriamente serão nós
            //celulas de parede serão ignoradas aqui
            //nas células de caminho, vamos verificar quantas vizinhas elas possuem. caso seja um valor diferente de 2,
            //significa que a célula é um nó
            if celula == lb.ComponenteLabirinto.parede { 
                j += 1
                continue
            }

            if celula == lb.ComponenteLabirinto.inicio {
                no_inicio = gf.create_no(contador_nos)
                relacao_de_pontos[contador_nos] = [?]int{i,j}
                contador_nos += 1
            } else if celula == lb.ComponenteLabirinto.fim {
                no_fim = gf.create_no(contador_nos)
                relacao_de_pontos[contador_nos] = [?]int{i,j}
                contador_nos += 1
            } else if contar_vizinhos(l,i,j) != 2 {
                novo_no := gf.create_no(contador_nos)
                lb.visitar_celula(l,i,j)

                append(&nos, novo_no)
                relacao_de_pontos[contador_nos] = [?]int{i,j}
                contador_nos += 1
            }

            j += 1
        }

        j = 0
        i += 1
    }

    return nos,no_inicio,no_fim,relacao_de_pontos
}

contar_vizinhos::proc(labirinto: ^lb.Labirinto, i,j: int) -> int {
    vizinhos := 0

    //verificamos em cima
    if i-1 >= 0 {
        vizinho := labirinto.matriz[i-1][j]
        if  vizinho == lb.ComponenteLabirinto.caminho ||
            vizinho == lb.ComponenteLabirinto.inicio ||
            vizinho == lb.ComponenteLabirinto.fim ||
            vizinho == lb.ComponenteLabirinto.caminho_visitado
        { vizinhos += 1 }
    }

    //verificamos embaixo
    if i+1 < labirinto.altura {
        vizinho := labirinto.matriz[i+1][j]
        if  vizinho == lb.ComponenteLabirinto.caminho ||
            vizinho == lb.ComponenteLabirinto.inicio ||
            vizinho == lb.ComponenteLabirinto.fim ||
            vizinho == lb.ComponenteLabirinto.caminho_visitado
        { vizinhos += 1 }
    }

    //verificamos na esquerda
    if j-1 >= 0 {
        vizinho := labirinto.matriz[i][j-1]
        if  vizinho == lb.ComponenteLabirinto.caminho ||
            vizinho == lb.ComponenteLabirinto.inicio ||
            vizinho == lb.ComponenteLabirinto.fim ||
            vizinho == lb.ComponenteLabirinto.caminho_visitado
        { vizinhos += 1 }
    }

    //e também na direita
    if j+1 < labirinto.largura {
        vizinho := labirinto.matriz[i][j+1]
        if  vizinho == lb.ComponenteLabirinto.caminho ||
            vizinho == lb.ComponenteLabirinto.inicio ||
            vizinho == lb.ComponenteLabirinto.fim ||
            vizinho == lb.ComponenteLabirinto.caminho_visitado
        { vizinhos += 1 }
    }

    return vizinhos
}