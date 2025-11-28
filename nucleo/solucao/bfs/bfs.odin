package bfs

import gf "nucleo:grafo"
import solucao "nucleo:solucao"

/*
 Recebe como argumento um grafo e retorna, em primeiro lugar, a
 lista de tentativas realizadas para solucionar o grafo do labirinto,
 e em segundo lugar a solução encontrada pelo método no labirinto
 */
bfs::proc(grafo: ^gf.Grafo) -> ([dynamic]solucao.PilhaPassos, solucao.PilhaPassos)