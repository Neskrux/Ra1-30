# Fase 1 — Léxico (AFD) e Assembly ARMv7 (DE1-SoC / CPUlator)

## Repositório

[https://github.com/Neskrux/Ra1-30](https://github.com/Neskrux/Ra1-30)

```bash
git clone https://github.com/Neskrux/Ra1-30.git
```

## Instituição

| | |
|--|--|
| Instituição | PUCPR |
| Disciplina | Construção de Interpretadores |
| Professor | Frank Coelho |
| Grupo (Canvas) | RA1 30 |

**Integrantes (ordem alfabética por sobrenome):**

1. Davi Biscaia — [@biscaiadavi](https://github.com/biscaiadavi)  
2. Bruno Sandoval — [@Neskrux](https://github.com/Neskrux)

## Execução

```bash
python main.py teste1.txt
```

Gera `tokens_ultima_execucao.txt` e `saida_arm.s` conforme o último arquivo passado.

## Testes

```bash
python -m unittest discover -s tests -v
```

## CPUlator

Sistema **ARMv7 DE1-SoC**: [https://cpulator.01xz.net/?sys=arm-de1soc](https://cpulator.01xz.net/?sys=arm-de1soc)

Carregar `saida_arm.s`, compilar (F5), executar. Display HEX em `0xFF200020`.

## Arquivos

- `teste1.txt`, `teste2.txt`, `teste3.txt` — entradas de exemplo  
- `lexico.py` — `parseExpressao` (AFD)  
- `ast_parser.py` — AST  
- `gerador_arm.py` — Assembly  
- `main.py` — `lerArquivo`, `executarExpressao`, `gerarAssembly`, `exibirResultados`  
