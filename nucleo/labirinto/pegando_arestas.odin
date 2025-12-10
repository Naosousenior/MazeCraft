package labirinto

import gf "nucleo:grafo"

/*
 procedimento para pegar as arestas de um labirinto. Observe que para ele funcionar corretamente, é necessário que:
 * Você primeiro execute a função pegar_pontos no mesmo labirinto
 * Você não limpe os caminhos visitados do labirinto depois de executar o procedimento anterior
 * Você inclua na lista de pontos, o ponto de início e de fim. Essa função não vai diferenciar essses nós dos demais
 */
pegar_arestas::proc(l:^Labirinto, nos: [dynamic]^gf.No, relacao_nos: map[int] Coordenada) -> ([dynamic]^gf.Aresta,map[int] [dynamic] Coordenada){
    lista_arestas := make([dynamic]^gf.Aresta)
    relacao_arestas := make(map[int] [dynamic]Coordenada) //precisamos de uma relação da lista de coordenadas pra cada aresta

    //primeiro, vamos de nó em nó
    contar_arestas := 0
    for no in nos {
        //para cada nó, vamos tentar pegar suas arestas. Para isso, vamos pegar sua coordenada no labirinto:
        coordenada := relacao_nos[no.valor]

        //agora, vamos verficar cada uma das direções da coordenada
        //nas direções em que o vizinho for um 

        //verificamos em cima
        if vizinho := em_cima(coordenada); verifica_coordenada(l,vizinho) {
            if  pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
                outro_no,caminho_coordenadas := montar_aresta(no,coordenada,vizinho,l,[dynamic]Coordenada{},nos,relacao_nos)

                nova_aresta := gf.create_aresta(no,outro_no,contar_arestas)
                contar_arestas += 1
                append(&lista_arestas,nova_aresta)
                relacao_arestas[nova_aresta.valor] = caminho_coordenadas
            }
        }

        //verificamos embaixo
        if vizinho := em_baixo(coordenada); verifica_coordenada(l,vizinho) {
            if  pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
                outro_no,caminho_coordenadas := montar_aresta(no,coordenada,vizinho,l,[dynamic]Coordenada{},nos,relacao_nos)

                nova_aresta := gf.create_aresta(no,outro_no,contar_arestas)
                contar_arestas += 1
                append(&lista_arestas,nova_aresta)
                relacao_arestas[nova_aresta.valor] = caminho_coordenadas
            }
        }

        //verificamos na esquerda
        if vizinho := a_esquerda(coordenada); verifica_coordenada(l,vizinho) {
            if  pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
                outro_no,caminho_coordenadas := montar_aresta(no,coordenada,vizinho,l,[dynamic]Coordenada{},nos,relacao_nos)

                nova_aresta := gf.create_aresta(no,outro_no,contar_arestas)
                contar_arestas += 1
                append(&lista_arestas,nova_aresta)
                relacao_arestas[nova_aresta.valor] = caminho_coordenadas
            }
        }

        //e também na direita
        if vizinho := a_direita(coordenada); verifica_coordenada(l,vizinho) {
            if  pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
                outro_no,caminho_coordenadas := montar_aresta(no,coordenada,vizinho,l,[dynamic]Coordenada{},nos,relacao_nos)

                nova_aresta := gf.create_aresta(no,outro_no,contar_arestas)
                contar_arestas += 1
                append(&lista_arestas,nova_aresta)
                relacao_arestas[nova_aresta.valor] = caminho_coordenadas
            }
        }
    }

    for no in nos {
        i, j := relacao_nos[no.valor].i, relacao_nos[no.valor].j
        l.matriz[i][j] = ComponenteLabirinto.caminho
    }

    return lista_arestas,relacao_arestas
}

/*
 Para montar a aresta, precisamos saber qual o nó de onde a aresta está vindo, e também a lista de coordenadas que já visitamos
 Então, vamos verificar as células ao redor da coordenada, se a célula for um caminho, vamos marcar a coordenada atual
 como visitada, e vamos seguir para a próxima célula de caminho.
 Quando todas as células ao redor da coordenada não forem caminhos, ela vai verificar se existem dois caminhos_visitados.
 Se sim, significa que um deles é o nó da outra ponta da aresta, então, ela tenta pegar o nó correspondente a sua coordenada e retorna
 a lista de coordenadas coletadas até agora
 */
montar_aresta::proc(
    no_inicial: ^gf.No,
    anterior_coordenada, atual_coordenada: Coordenada,
    l: ^Labirinto,
    lista_coordenadas: [dynamic]Coordenada,
    nos: [dynamic]^gf.No,
    relacao_nos: map[int] Coordenada
) -> (^gf.No, [dynamic]Coordenada) {
    lista_coordenadas := lista_coordenadas //devido ao cu doce de odin, temos que sombrear essa variável
    //para montar uma aresta, temos que saber por qual caminho essa aresta continua
    coordenada_final : Coordenada
    visitar_celula(l,atual_coordenada) //ja podemos visitar a celula atual

    //agora vamos executar o passo a seguir para cada uma das direcoes
    //supomos que não deve haver risco de a coordenada ter mais de um vizinho como caminho
    if vizinho := em_cima(atual_coordenada); verifica_coordenada(l,vizinho) {
        if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
            //vamos adicionar a coordenada atual na lista de coordenadas
            append(&lista_coordenadas,atual_coordenada)

            return montar_aresta(no_inicial,atual_coordenada,vizinho,l,lista_coordenadas,nos,relacao_nos)
        } else if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho_visitado {
            //se a vizinha for uma celula já visitada, devemos verificar se ela já está na lista de coordenadas visitadas
            if vizinho != anterior_coordenada {
                coordenada_final = vizinho
            }
        }
    }

    if vizinho := em_baixo(atual_coordenada); verifica_coordenada(l,vizinho) {
        if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
            //vamos adicionar a coordenada atual na lista de coordenadas
            append(&lista_coordenadas,atual_coordenada)

            return montar_aresta(no_inicial,atual_coordenada,vizinho,l,lista_coordenadas,nos,relacao_nos)
        } else if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho_visitado {
            //se a vizinha for uma celula já visitada, devemos verificar se ela já está na lista de coordenadas visitadas
            if vizinho != anterior_coordenada {
                coordenada_final = vizinho
            }
        }
    }

    if vizinho := a_esquerda(atual_coordenada); verifica_coordenada(l,vizinho) {
        if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
            //vamos adicionar a coordenada atual na lista de coordenadas
            append(&lista_coordenadas,atual_coordenada)

            return montar_aresta(no_inicial,atual_coordenada,vizinho,l,lista_coordenadas,nos,relacao_nos)
        } else if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho_visitado {
            //se a vizinha for uma celula já visitada, devemos verificar se ela já está na lista de coordenadas visitadas
            if vizinho != anterior_coordenada {
                coordenada_final = vizinho
            }
        }
    }

    if vizinho := a_direita(atual_coordenada); verifica_coordenada(l,vizinho) {
        if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho {
            //vamos adicionar a coordenada atual na lista de coordenadas
            append(&lista_coordenadas,atual_coordenada)

            return montar_aresta(no_inicial,atual_coordenada,vizinho,l,lista_coordenadas,nos,relacao_nos)
        } else if pegar_celula(l,vizinho) == ComponenteLabirinto.caminho_visitado {
            //se a vizinha for uma celula já visitada, devemos verificar se ela já está na lista de coordenadas visitadas
            if vizinho != anterior_coordenada {
                coordenada_final = vizinho
            }
        }
    }

    //se chegou até aqui, significa que chegamos ao final da aresta, então, significa que a coordenada já foi definida, e podemos usar ele para encontrar
    //então, podemos adicionar ela a lista de coordenadas, e pegamos o seu nó correspondente

    valor_no := -1
    for index, c in relacao_nos {
        if coordenada_final == c {
            valor_no = index
        }
    }

    no_final : ^gf.No
    for n in nos {
        if n.valor == valor_no {
            no_final = n
        }
    }

    return no_final,lista_coordenadas

}

ponto_da_coordenada::proc(x_pos,y_pos: int,nos: []^gf.No, coordenadas: map[int] [2]int) -> ^gf.No {
    for index, coordenada in coordenadas {
        if x_pos == coordenada[0] && y_pos == coordenada[1] {
            for no in nos {
                if no.valor == index {
                    return no
                }
            }
        }
    }

    return nil
}