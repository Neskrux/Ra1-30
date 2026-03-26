# Fase 1 — Analisador léxico (AFD) e gerador de Assembly ARMv7 (DE1-SoC / CPUlator)

## Repositório

- **GitHub:** [Neskrux/Ra1-30](https://github.com/Neskrux/Ra1-30)
- **Clone (HTTPS):** `git clone https://github.com/Neskrux/Ra1-30.git`

Se o repositório ainda estiver vazio no GitHub, na pasta do projeto (com o código já copiado):

```bash
git init
git branch -M main
git remote add origin https://github.com/Neskrux/Ra1-30.git
git add .
git commit -m "Fase 1: léxico AFD, AST, gerador ARMv7 e testes"
git push -u origin main
```

## Instituição, disciplina e docente

- **Instituição:** [PREENCHER]
- **Disciplina:** [PREENCHER]
- **Professor(a):** [PREENCHER]

## Grupo e integrantes (ordem alfabética + usuário GitHub)

- **Nome do grupo (Canvas):** [PREENCHER]
- [Nome Completo](https://github.com/USUARIO) — `@USUARIO`
- (Adicionar demais integrantes na mesma linha de formato.)

## Objetivo

Programa em **Python** que:

1. Lê um arquivo de expressões em RPN parentetizada (uma expressão por linha).
2. Realiza **análise léxica** com **autômato finito determinístico** (cada estado é uma função; **sem regex** na léxica).
3. Constrói a AST da linha (**sem avaliar** em Python as operações `+ - * / // % ^` da linguagem).
4. Gera **Assembly ARMv7** com **VFP (IEEE 754 dupla precisão)** para o simulador **CPUlator — ARMv7 DE1-SoC (v16.1)**.
5. Grava `tokens_ultima_execucao.txt` (JSON com os tokens da última execução) e `saida_arm.s` (último Assembly gerado).

Os **cálculos** ocorrem apenas no **Assembly** gerado. A saída numérica formatada no console não replica o valor em ponto flutuante (evita `eval` / operações da linguagem em Python); o resultado deve ser verificado no **CPUlator** (registrador `d0`, memória `hist`, display **HEX3–HEX0** em `0xFF200020`).

## Requisitos

- Python 3.10+ (recomendado).

## Execução

Na pasta do projeto:

```bash
python main.py teste1.txt
```

Equivalente ao `./programa teste1.txt` após tornar o script executável em Unix.

Saídas:

- `tokens_ultima_execucao.txt` — lista de listas de tokens (última execução).
- `saida_arm.s` — programa Assembly correspondente **exatamente** ao último arquivo processado.

## Testes

```bash
python -m unittest discover -s tests -v
```

Inclui testes do **léxico** (válidos e inválidos), **parser** e um teste de **pipeline** (geração de Assembly não vazia).

## Uso no CPUlator

1. Abra [CPUlator](https://cpulator.01xz.net/?sys=arm-de1soc) e selecione o sistema **ARMv7 DE1-SoC**.
2. Copie o conteúdo de `saida_arm.s` para o editor (ou carregue o arquivo).
3. **Compile and Load (F5)**.
4. Execute (**Continue**). O programa entra em laço final `halt_loop` após processar todas as linhas.
5. Observe o **display de 7 segmentos** (HEX) e/ou inspecione `hist` e variáveis `mem_*` na janela de memória.

## Funções principais (contrato da disciplina)

| Função | Módulo | Descrição |
|--------|--------|-----------|
| `parseExpressao` | `lexico.py` | Léxico AFD → vetor de tokens. |
| `executarExpressao` | `main.py` | Monta AST e estado simbólico (memórias/literais) por linha. |
| `gerarAssembly` | `main.py` | Preenche `codigoAssembly` com o programa ARM (usa contexto da execução atual). |
| `exibirResultados` | `main.py` | Imprime resumo por linha (sem calcular expressões em Python). |
| `lerArquivo` | `main.py` | Lê linhas do arquivo de teste. |

Fluxo interno: `iniciarContextoCompilacao()` antes de processar um arquivo; em seguida, para cada linha, `parseExpressao` → `executarExpressao`; ao final, `gerarAssembly`.

## Arquivos de teste

- `teste1.txt`, `teste2.txt`, `teste3.txt` — cada um com **12 linhas**, cobrindo operadores `+ - * / // % ^`, comandos `(N RES)`, `(V MEM)`, `(MEM)` e aninhamento.

## Estrutura do repositório

```
main.py              # Ponto de entrada, orquestração, funções pedidas
lexico.py            # AFD (estados como funções)
ast_parser.py        # AST a partir dos tokens
gerador_arm.py       # Emissão ARMv7 + VFP
tests/               # Testes unitários
teste1.txt …         # Entradas de exemplo
saida_arm.s          # Último Assembly (regenerado ao rodar main.py)
tokens_ultima_execucao.txt
```

Preencha os campos `[PREENCHER]` nos cabeçalhos de `main.py` / `lexico.py` e neste README antes da entrega.
