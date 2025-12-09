package labirinto
import "core:fmt"

ComponenteLabirinto :: enum {
    inicio,
    caminho,
    parede,
    fim
}

Labirinto :: struct {
    altura:  int,
    largura: int,
    matriz:  [dynamic][dynamic] ComponenteLabirinto
}

VERMELHO :: "\x1b[41m"
VERDE    :: "\x1b[42m"
AMARELO  :: "\x1b[43m"
AZUL     :: "\x1b[44m"
MAGENTA  :: "\x1b[45m"
RESETAR  :: "\x1b[0m"

imprimir_labirinto::proc(labiri: ^Labirinto) {
    matriz := labiri.matriz
    for linha in matriz {
        for celula in linha {
            switch celula {
                case ComponenteLabirinto.parede:
                    fmt.printf("%s   %s",MAGENTA,RESETAR)
                case ComponenteLabirinto.caminho:
                    fmt.printf("%s   %s",AMARELO,RESETAR)
                case ComponenteLabirinto.inicio:
                    fmt.printf("%s   %s",AZUL,RESETAR)
                case ComponenteLabirinto.fim:
                    fmt.printf("%s   %s",VERMELHO,RESETAR)
            }
        }

        fmt.println()
    }

}

create_labirinto::proc(texto_labirinto: string) -> ^Labirinto {
    i, j: int
    matriz := make([dynamic][dynamic] ComponenteLabirinto)
    linha := make([dynamic] ComponenteLabirinto)

    for letra in texto_labirinto {
        switch letra {
            case  '\n':
                append(&matriz,linha)
                linha = make([dynamic] ComponenteLabirinto)
            case '+':
                append(&linha,ComponenteLabirinto.caminho)
            case '#':
                append(&linha,ComponenteLabirinto.parede)
            case 's':
                append(&linha,ComponenteLabirinto.inicio)
            case 'e':
                append(&linha,ComponenteLabirinto.fim)
        }
    }

    novo_labirinto := new(Labirinto)
    novo_labirinto.altura = j
    novo_labirinto.largura = i
    novo_labirinto.matriz = matriz

    return novo_labirinto
}

destroy_labirinto::proc(pont_labirinto: ^^Labirinto) {
    if pont_labirinto == nil {return;}
    if pont_labirinto^ == nil {return;}

    for linha in pont_labirinto^.matriz {
        delete(linha)
    }

    delete(pont_labirinto^.matriz)
    free(pont_labirinto^)
}