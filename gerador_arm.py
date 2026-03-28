# PUCPR — Construção de Interpretadores — Prof. Frank Coelho
# Grupo Canvas: RA1 30 | https://github.com/Neskrux/Ra1-30
# Integrantes (A–Z): Biscaia, Davi — @biscaiadavi | Sandoval, Bruno — @Neskrux

from __future__ import annotations

from typing import List, Set, Tuple

from ast_parser import AstNode


class ErroGeracao(Exception):
    pass


def _escape_double_literal(s: str) -> str:
    return s.replace("\\", "\\\\")


def gerarAssembly(
    asts: List[AstNode],
    memorias: Set[str],
    literais: Set[str],
    codigoAssembly: List[str],
) -> None:
    codigoAssembly.clear()
    g = _Gerador(asts, memorias, literais, codigoAssembly)
    g.emitir_programa()


class _Gerador:
    def __init__(
        self,
        asts: List[AstNode],
        memorias: Set[str],
        literais: Set[str],
        out: List[str],
    ) -> None:
        self.asts = asts
        self.memorias = memorias
        self.literais = sorted(literais)
        self.out = out
        self._lid = 0

    def _ln(self, s: str = "") -> None:
        self.out.append(s)

    def _emit(self, s: str) -> None:
        self.out.append("\t" + s)

    def _rot(self, prefix: str) -> str:
        self._lid += 1
        return f"{prefix}_{self._lid}"

    def emitir_programa(self) -> None:
        n = len(self.asts)
        self._ln("/* RA1-30 / PUCPR — saida_arm.s */")
        self._ln(".syntax unified")
        self._ln(".cpu cortex-a9")
        self._ln(".fpu vfpv3-d16")
        self._ln(".arm")
        self._ln("")
        self._ln(".equ HEX3_HEX0, 0xFF200020")
        self._ln(".equ HEX5_HEX4, 0xFF200030")
        self._ln(".equ LEDR_BASE, 0xFF200000")
        self._ln("")
        self._ln(".section .text")
        self._ln(".global _start")
        self._ln("")
        self._ln("_start:")
        self._emit("mrc p15, 0, r0, c1, c0, 2")
        self._emit("orr r0, r0, #0x300000")
        self._emit("mcr p15, 0, r0, c1, c0, 2")
        self._emit("isb")
        self._emit("mov r0, #0x40000000")
        self._emit("vmsr fpexc, r0")
        self._emit("ldr sp, =stack_top")
        self._emit("bl main_program")
        self._ln("halt_loop:")
        self._emit("b halt_loop")
        self._ln("")
        self._ln("/* d0 -> HEX3_HEX0 */")
        self._ln("mostrar_d0_hex:")
        self._emit("push {r4, lr}")
        self._emit("sub sp, sp, #8")
        self._emit("vstr d0, [sp]")
        self._emit("ldr r0, [sp]")
        self._emit("ldr r4, =HEX3_HEX0")
        self._emit("str r0, [r4]")
        self._emit("add sp, sp, #8")
        self._emit("pop {r4, pc}")
        self._ln("")
        self._ln("main_program:")
        self._emit("push {r4-r11, lr}")
        for k in range(n):
            self._emit(f"bl linha_{k}")
            self._emit(f"ldr r4, =hist")
            self._emit(f"mov r5, #{k * 8}")
            self._emit("add r4, r4, r5")
            self._emit("vstr d0, [r4]")
            self._emit("bl mostrar_d0_hex")
        self._emit("pop {r4-r11, pc}")
        self._ln("")
        for k in range(n):
            self._ln(f"linha_{k}:")
            self._gen_expr(self.asts[k], k)
            self._emit("bx lr")
            self._ln("")
        self._emitar_dados()

    def _gen_expr(self, ast: AstNode, idx_linha: int) -> None:
        k = ast[0]
        if k == "num":
            lab = f"lit_{self._san_mem(ast[1])}"
            self._emit(f"ldr r0, ={lab}")
            self._emit("vldr d0, [r0]")
            return
        if k == "load":
            self._emit(f"ldr r0, =mem_{ast[1]}")
            self._emit("vldr d0, [r0]")
            return
        if k == "res":
            n = ast[1]
            alvo = idx_linha - n
            if alvo < 0 or alvo >= idx_linha:
                raise ErroGeracao(
                    f"(RES) referência inválida na linha {idx_linha} (índice 0-based): N={n}"
                )
            self._emit("ldr r0, =hist")
            self._emit(f"mov r1, #{alvo * 8}")
            self._emit("add r0, r0, r1")
            self._emit("vldr d0, [r0]")
            return
        if k == "store":
            nome, sub = ast[1], ast[2]
            self._gen_expr(sub, idx_linha)
            self._emit(f"ldr r0, =mem_{nome}")
            self._emit("vstr d0, [r0]")
            return
        if k == "bin":
            op, esq, dir_ = ast[1], ast[2], ast[3]
            self._gen_expr(esq, idx_linha)
            self._emit("vpush {d0}")
            self._gen_expr(dir_, idx_linha)
            self._emit("vpop {d1}")
            if op == "+":
                self._emit("vadd.f64 d0, d1, d0")
            elif op == "-":
                self._emit("vsub.f64 d0, d1, d0")
            elif op == "*":
                self._emit("vmul.f64 d0, d1, d0")
            elif op == "/":
                self._emit("vdiv.f64 d0, d1, d0")
            elif op == "//":
                self._emitir_div_inteira()
            elif op == "%":
                self._emitir_resto()
            elif op == "^":
                self._emitir_potencia()
            else:
                raise ErroGeracao(f"Operador não suportado: {op}")
            return
        raise ErroGeracao(f"AST desconhecida: {ast!r}")

    def _emitir_div_inteira(self) -> None:
        self._emit("vcvt.s32.f64 s0, d1")
        self._emit("vcvt.s32.f64 s2, d0")
        self._emit("vmov r0, s0")
        self._emit("vmov r1, s2")
        self._emit("cmp r1, #0")
        self._emit("beq divzero_die")
        self._emit("bl idiv_trunc")
        self._emit("vmov s4, r2")
        self._emit("vcvt.f64.s32 d0, s4")

    def _emitir_resto(self) -> None:
        self._emit("vcvt.s32.f64 s0, d1")
        self._emit("vcvt.s32.f64 s2, d0")
        self._emit("vmov r0, s0")
        self._emit("vmov r1, s2")
        self._emit("cmp r1, #0")
        self._emit("beq divzero_die")
        self._emit("bl idiv_trunc")
        self._emit("mls r3, r1, r2, r0")
        self._emit("vmov s4, r3")
        self._emit("vcvt.f64.s32 d0, s4")

    def _emitir_potencia(self) -> None:
        z = self._rot("pow_z")
        p1 = self._rot("pow_one")
        done = self._rot("pow_fin")
        loop = self._rot("pow_lp")
        self._emit("vcvt.s32.f64 s4, d0")
        self._emit("vmov r2, s4")
        self._emit("vpop {d1}")
        self._emit("cmp r2, #0")
        self._emit("blt pow_neg_err")
        self._emit(f"beq {z}")
        self._emit("cmp r2, #1")
        self._emit(f"ble {p1}")
        self._emit("vmov.f64 d3, d1")
        self._emit("mov r4, r2")
        self._emit("subs r4, r4, #1")
        self._ln(f"{loop}:")
        self._emit("vmul.f64 d3, d3, d1")
        self._emit("subs r4, r4, #1")
        self._emit(f"bne {loop}")
        self._emit("vmov.f64 d0, d3")
        self._emit(f"b {done}")
        self._ln(f"{p1}:")
        self._emit("vmov.f64 d0, d1")
        self._emit(f"b {done}")
        self._ln(f"{z}:")
        self._emit("ldr r0, =lit_one")
        self._emit("vldr d0, [r0]")
        self._ln(f"{done}:")
        self._emit("nop")

    @staticmethod
    def _san_mem(s: str) -> str:
        t = []
        for c in s:
            if c.isalnum():
                t.append(c)
            else:
                t.append("_")
        return "".join(t) or "L"

    def _emitar_dados(self) -> None:
        self._ln(".section .rodata")
        self._ln(".align 3")
        self._ln("lit_one:")
        self._ln("\t.double 1.0")
        for lit in self.literais:
            self._ln(f"lit_{self._san_mem(lit)}:")
            self._ln(f"\t.double {_escape_double_literal(lit)}")
        self._ln("")
        self._ln(".section .bss")
        self._ln(".align 3")
        self._ln("hist:")
        self._ln(f"\t.space {max(8, len(self.asts) * 8)}")
        for m in sorted(self.memorias):
            self._ln(f"mem_{m}:")
            self._ln("\t.space 8")
        self._ln("")
        self._ln(".section .bss")
        self._ln(".align 4")
        self._ln("stack:")
        self._ln("\t.space 65536")
        self._ln("stack_top:")
        self._ln("")
        self._ln(".section .text")
        self._ln("udiv32:")
        self._emit("push {r4, r5, r6, r7, lr}")
        self._emit("mov r7, #0")
        self._emit("mov r3, #0")
        self._emit("mov r5, r0")
        self._emit("mov r6, r1")
        self._emit("mov r4, #31")
        self._ln("ud32_loop:")
        self._emit("lsl r3, r3, #1")
        self._emit("mov r2, r5")
        self._emit("lsr r2, r2, r4")
        self._emit("and r2, r2, #1")
        self._emit("orr r3, r3, r2")
        self._emit("cmp r3, r6")
        self._emit("blt ud32_skip")
        self._emit("sub r3, r3, r6")
        self._emit("mov r2, #1")
        self._emit("lsl r2, r2, r4")
        self._emit("orr r7, r7, r2")
        self._ln("ud32_skip:")
        self._emit("subs r4, r4, #1")
        self._emit("bge ud32_loop")
        self._emit("mov r2, r7")
        self._emit("pop {r4, r5, r6, r7, pc}")
        self._ln("")
        self._ln("idiv_trunc:")
        self._emit("push {r4, r5, r6, lr}")
        self._emit("mov r4, r0")
        self._emit("mov r5, r1")
        self._emit("mov r6, #0")
        self._emit("cmp r4, #0")
        self._emit("rsblt r4, r4, #0")
        self._emit("orrlt r6, r6, #1")
        self._emit("cmp r5, #0")
        self._emit("rsblt r5, r5, #0")
        self._emit("orrlt r6, r6, #2")
        self._emit("mov r0, r4")
        self._emit("mov r1, r5")
        self._emit("bl udiv32")
        self._emit("cmp r6, #1")
        self._emit("beq idiv_neg")
        self._emit("cmp r6, #2")
        self._emit("beq idiv_neg")
        self._emit("b idiv_ret")
        self._ln("idiv_neg:")
        self._emit("rsb r2, r2, #0")
        self._ln("idiv_ret:")
        self._emit("pop {r4, r5, r6, pc}")
        self._ln("")
        self._ln("divzero_die:")
        self._emit("b divzero_die")
        self._ln("pow_neg_err:")
        self._emit("b pow_neg_err")
