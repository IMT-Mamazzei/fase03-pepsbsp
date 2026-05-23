package br.maua.cic303;

import java_cup.runtime.Symbol;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* ========================================================================= */
/* MACROS                                                                     */
/* ========================================================================= */
LineTerminator    = \r|\n|\r\n
WhiteSpace        = {LineTerminator} | [ \t\f]

/* TODO 1: Número com notação de engenharia */
Number            = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

/* TODO 2: Identificador (máx 32 caracteres) */
Letter            = [a-zA-Z]
Digit             = [0-9]
Identifier        = {Letter}({Letter}|{Digit}|_){0,31}
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32,255}

%%
/* ========================================================================= */
/* REGRAS LÉXICAS                                                             */
/* ========================================================================= */

<YYINITIAL> {

    {WhiteSpace}          { /* ignora */ }

    /* TODO 3: Palavras Reservadas */
    "if"                  { return symbol(sym.IF); }
    "then"                { return symbol(sym.THEN); }
    "else"                { return symbol(sym.ELSE); }
    "while"               { return symbol(sym.WHILE); }

    /* TODO 4: Pontuação */
    "("                   { return symbol(sym.LPAREN); }
    ")"                   { return symbol(sym.RPAREN); }
    "{"                   { return symbol(sym.LBRACE); }
    "}"                   { return symbol(sym.RBRACE); }
    ";"                   { return symbol(sym.SEMI); }

    /* TODO 5: Operadores Relacionais e Atribuição */
    /* ATENÇÃO: operadores duplos ANTES dos simples! */
    "=="                  { return symbol(sym.REL_OP, yytext()); }
    "!="                  { return symbol(sym.REL_OP, yytext()); }
    "<="                  { return symbol(sym.REL_OP, yytext()); }
    ">="                  { return symbol(sym.REL_OP, yytext()); }
    "<"                   { return symbol(sym.REL_OP, yytext()); }
    ">"                   { return symbol(sym.REL_OP, yytext()); }
    "="                   { return symbol(sym.ASSIGN); }

    /* TODO 6: Operadores Matemáticos */
    "+" | "-"             { return symbol(sym.ADD_OP, yytext()); }
    "*" | "/"             { return symbol(sym.MUL_OP, yytext()); }
    "%"                   { return symbol(sym.MUL_OP, yytext()); }

    /* Macros */
    {Identifier}          { return symbol(sym.ID, yytext()); }
    {Number}              { return symbol(sym.NUMBER, yytext()); }

    /* Identificador grande demais */
    {OversizedIdentifier} { throw new RuntimeException("Erro Léxico: Identificador gigante -> " + yytext()); }

    /* Caractere ilegal */
    .                     { throw new RuntimeException("Erro Léxico: Caractere Ilegal -> " + yytext()); }
}

<<EOF>>                   { return symbol(sym.EOF, ""); }