%{

/* This is a hacked version of the scanner from
 *   https://github.com/ben-marshall/verilog-parser
 * The original was released under the MIT licence
 */

  #include <stdbool.h>
  # include "verilog_parser.tab.h"
  YYSTYPE yylval;

  #define EMIT_TOKEN(x)  return x;
  char *ast_new_identifier(char *yytext, int yylineno) { return yytext; }
  bool want_newline = false;

%}

%option yylineno
%option nodefault 
%option noyywrap 


/* Keyword Token deffinitions. */
ALWAYS              "always"
AND                 "and"
ASSIGN              "assign"
AUTOMATIC           "automatic"
BEGIN               "begin"
BUF                 "buf"
BUFIF0              "bufif0"
BUFIF1              "bufif1"
CASE                "case"
CASEX               "casex"
CASEZ               "casez"
CELL                "cell"
CMOS                "cmos"
CONFIG              "config"
DEASSIGN            "deassign"
DEFAULT             "default"
DEFPARAM            "defparam"
DESIGN              "design"
DISABLE             "disable"
EDGE                "edge"
ELSE                "else"
END                 "end"
ENDCASE             "endcase"
ENDCONFIG           "endconfig"
ENDFUNCTION         "endfunction"
ENDGENERATE         "endgenerate"
ENDMODULE           "endmodule"
ENDPRIMITIVE        "endprimitive"
ENDSPECIFY          "endspecify"
ENDTABLE            "endtable"
ENDTASK             "endtask"
EVENT               "event"
FOR                 "for"
FORCE               "force"
FOREVER             "forever"
FORK                "fork"
FUNCTION            "function"
GENERATE            "generate"
GENVAR              "genvar"
HIGHZ0              "highz0"
HIGHZ1              "highz1"
IF                  "if"
IFNONE              "ifnone"
INCDIR              "-incdir"
INCLUDE             "include"
INITIAL             "initial"
INOUT               "inout"
INPUT               "input"
INSTANCE            "instance"
INTEGER             "integer"
JOIN                "join"
LARGE               "large"
LIBLIST             "liblist"
LIBRARY             "library"
LOCALPARAM          "localparam"
MACROMODULE         "macromodule"
MEDIUM              "medium"
MODULE              "module"
NAND                "nand"
NEGEDGE             "negedge"
NMOS                "nmos"
NOR                 "nor"
NOSHOWCANCELLED     "noshowcancelled"
NOT                 "not"
NOTIF0              "notif0"
NOTIF1              "notif1"
OR                  "or"
OUTPUT              "output"
PARAMETER           "parameter"
PMOS                "pmos"
POSEDGE             "posedge"
PRIMITIVE           "primitive"
PULL0               "pull0"
PULL1               "pull1"
PULLDOWN            "pulldown"
PULLUP              "pullup"
PULSESTYLE_ONEVENT  "pulsestyle_onevent"
PULSESTYLE_ONDETECT "pulsestyle_ondetect"
RCMOS               "rcmos"
REAL                "real"
REALTIME            "realtime"
REG                 "reg"
RELEASE             "release"
REPEAT              "repeat"
RNMOS               "rnmos"
RPMOS               "rpmos"
RTRAN               "rtran"
RTRANIF0            "rtranif0"
RTRANIF1            "rtranif1"
SCALARED            "scalared"
SHOWCANCELLED       "showcancelled"
SIGNED              "signed"
SMALL               "small"
SPECIFY             "specify"
SPECPARAM           "specparam"
STRONG0             "strong0"
STRONG1             "strong1"
SUPPLY0             "supply0"
SUPPLY1             "supply1"
TABLE               "table"
TASK                "task"
TIME                "time"
TRAN                "tran"
TRANIF0             "tranif0"
TRANIF1             "tranif1"
TRI0                "tri0"
TRI1                "tri1"
TRI                 "tri"
TRIAND              "triand"
TRIOR               "trior"
TRIREG              "trireg"
UNSIGNED            "unsigned"
USE                 "use"
VECTORED            "vectored"
WAIT                "wait"
WAND                "wand"
WEAK0               "weak0"
WEAK1               "weak1"
WHILE               "while"
WIRE                "wire"
WOR                 "wor"
XNOR                "xnor"
XOR                 "xor"

/* Single character tokens */

NEWLINE             [\r]?[\n]|[\r]
WHITESPACE          [ \t\f]


AT                  "@"
COMMA               ","
HASH                "#"
DOT                 "."
EQ                  "="
COLON               ":"
IDX_PRT_SEL         "+:"|"-:"
SEMICOLON           ";"
OPEN_BRACKET        "\("
CLOSE_BRACKET       "\)"
OPEN_SQ_BRACKET     "\["
CLOSE_SQ_BRACKET    "\]"
OPEN_SQ_BRACE       "{"
CLOSE_SQ_BRACE      "}"


/* Tokens related to numbers */

EXP                 "e"|"E"
UNDERSCORE          "_"
SIGN                {PLUS}|{MINUS}
X                   "x"|"X"
Z                   "z"|"Z"|"?"

DIGIT_DECIMAL       [0-9]
DIGIT_DECMIAL_NZ    [1-9]
DIGIT_BINARY        [0-1]|{X}|{Z}
DIGIT_OCTAL         [0-7]|{X}|{Z}
DIGIT_HEX           [0-9a-fA-F]|{X}|{Z}

BASE_DECIMAL        '[sS]?[dD]
BASE_BINARY         '[sS]?[bB]
BASE_OCTAL          '[sS]?[oO]
BASE_HEX            '[sS]?[hH]

NUM_REAL_EXP        {NUM_UNSIGNED}({DOT}{NUM_UNSIGNED})?{EXP}({SIGN})?{NUM_UNSIGNED}

BIN_VALUE           {DIGIT_BINARY}({UNDERSCORE}|{DIGIT_BINARY})*
OCT_VALUE           {DIGIT_OCTAL}({UNDERSCORE}|{DIGIT_OCTAL})*
HEX_VALUE           {DIGIT_HEX}({UNDERSCORE}|{DIGIT_HEX})*

%x in_hex_val
%x in_oct_val
%x in_bin_val
%s in_number

NUM_REAL            {NUM_UNSIGNED}{DOT}{NUM_UNSIGNED}|{NUM_REAL_EXP}
NUM_UNSIGNED        {DIGIT_DECIMAL}({UNDERSCORE}|{DIGIT_DECIMAL})*

/* Identifiers */

SYSTEM_ID           \$[a-zA-Z0-9_\$]+
SIMPLE_ID           [a-zA-Z_][a-zA-Z0-9_$]*
ESCAPED_ID          \\{SIMPLE_ID}
MACRO_IDENTIFIER    `{SIMPLE_ID}

MACRO_TEXT          .*\n

%x in_define
%x in_define_t

/* Attributes */

ATTRIBUTE_START     \(\*
ATTRIBUTE_END       \*\)

/* Comments */
COMMENT_LINE        "//".*\n

COMMENT_BEGIN       "/*"
COMMENT_END         "*/"

%x in_comment

/* Pre-processor definitions */
CD_DEFAULT_NETTYPE     "`default_nettype".*{NEWLINE}
CD_LINE                "`line".*{NEWLINE}
CD_CELLDEFINE          "`celldefine".*{NEWLINE}
CD_DEFINE              "`define".*{NEWLINE}
CD_RESETALL            "`resetall".*{NEWLINE}
CD_ENDCELLDEFINE       "`endcelldefine".*{NEWLINE}
CD_ELSE                "`else".*{NEWLINE}
CD_ELSIF               "`elsif".*{NEWLINE}
CD_ENDIF               "`endif".*{NEWLINE}
CD_IFDEF               "`ifdef".*{NEWLINE}
CD_IFNDEF              "`ifndef".*{NEWLINE}
CD_UNDEF               "`undef".*{NEWLINE}
CD_NOUNCONNECTED_DRIVE "`nounconnected_drive".*{NEWLINE}
CD_UNCONNECTED_DRIVE   "`unconnected_drive".*{NEWLINE}
CD_INCLUDE             "`include".*{NEWLINE}
CD_TIMESCALE           "`timescale".*{NEWLINE}


/* Strings */

STRING              \".*\"

/* Operators */

STAR                "\*"
PLUS                "+"
MINUS               "-"
ASL                 "<<<"
ASR                 ">>>"
LSL                 "<<"
LSR                 ">>"
DIV                 "/"
POW                 "**"
MOD                 "%"
GTE                 ">="
LTE                 "<="
GT                  ">"
LT                  "<"
L_NEG               "!"
L_AND               "&&"
L_OR                "||"
C_EQ                "==="
L_EQ                "=="
C_NEQ               "!=="
L_NEQ               "!="
B_NEG               "~"
B_AND               "&"
B_OR                "|"
B_XOR               "^"
B_EQU               "^~"|"~^"
B_NAND              "~&"
B_NOR               "~|"
TERNARY             "?"

%%
{ATTRIBUTE_START}      {EMIT_TOKEN(ATTRIBUTE_START);}
{ATTRIBUTE_END}        {EMIT_TOKEN(ATTRIBUTE_END);}

{COMMENT_LINE}         {/*EMIT_TOKEN(COMMENT_LINE); IGNORE */}
{COMMENT_BEGIN}        {BEGIN(in_comment);                    ;}

<in_comment>.|\n       {/* IGNORE                            */}
<in_comment>{COMMENT_END} {BEGIN(INITIAL);                     }

{CD_CELLDEFINE}          { }
{CD_ENDCELLDEFINE}       { }
{CD_DEFAULT_NETTYPE}     { }
{CD_TIMESCALE}           { }
{CD_RESETALL}            { }
{CD_IFDEF}               { }
{CD_IFNDEF}              { }
{CD_ELSIF}               { }
{CD_ELSE}                { }
{CD_ENDIF}               { }
{CD_INCLUDE}             { }
{CD_LINE}                { }
{CD_NOUNCONNECTED_DRIVE} { }
{CD_UNCONNECTED_DRIVE}   { }
{CD_DEFINE}              { }
{CD_UNDEF}               { }
{MACRO_IDENTIFIER}       { }

{AT}                   {EMIT_TOKEN(AT);}
{COMMA}                {EMIT_TOKEN(COMMA);}
{HASH}                 {EMIT_TOKEN(HASH);}
{DOT}                  {EMIT_TOKEN(DOT);}
{EQ}                   {EMIT_TOKEN(EQ);}
{COLON}                {EMIT_TOKEN(COLON);}
{IDX_PRT_SEL}          {EMIT_TOKEN(IDX_PRT_SEL);}
{SEMICOLON}            {want_newline=true; EMIT_TOKEN(SEMICOLON);}
{OPEN_BRACKET}         {EMIT_TOKEN(OPEN_BRACKET);}
{CLOSE_BRACKET}        {EMIT_TOKEN(CLOSE_BRACKET);}
{OPEN_SQ_BRACKET}      {EMIT_TOKEN(OPEN_SQ_BRACKET);}
{CLOSE_SQ_BRACKET}     {EMIT_TOKEN(CLOSE_SQ_BRACKET);}
{OPEN_SQ_BRACE}        {EMIT_TOKEN(OPEN_SQ_BRACE);}
{CLOSE_SQ_BRACE}       {EMIT_TOKEN(CLOSE_SQ_BRACE);}
{STAR}                 {EMIT_TOKEN(STAR);}
{PLUS}                 {EMIT_TOKEN(PLUS);}
{MINUS}                {EMIT_TOKEN(MINUS);}
{ASL}                  {EMIT_TOKEN(ASL);}
{ASR}                  {EMIT_TOKEN(ASR);}
{LSL}                  {EMIT_TOKEN(LSL);}
{LSR}                  {EMIT_TOKEN(LSR);}
{DIV}                  {EMIT_TOKEN(DIV);}
{POW}                  {EMIT_TOKEN(POW);}
{MOD}                  {EMIT_TOKEN(MOD);}
{GTE}                  {EMIT_TOKEN(GTE);}
{LTE}                  {EMIT_TOKEN(LTE);}
{GT}                   {EMIT_TOKEN(GT);}
{LT}                   {EMIT_TOKEN(LT);}
{L_NEG}                {EMIT_TOKEN(L_NEG);}
{L_AND}                {EMIT_TOKEN(L_AND);}
{L_OR}                 {EMIT_TOKEN(L_OR);}
{C_EQ}                 {EMIT_TOKEN(C_EQ);}
{L_EQ}                 {EMIT_TOKEN(L_EQ);}
{C_NEQ}                {EMIT_TOKEN(C_NEQ);}
{L_NEQ}                {EMIT_TOKEN(L_NEQ);}
{B_NEG}                {EMIT_TOKEN(B_NEG);}
{B_AND}                {EMIT_TOKEN(B_AND);}
{B_OR}                 {EMIT_TOKEN(B_OR);}
{B_XOR}                {EMIT_TOKEN(B_XOR);}
{B_EQU}                {EMIT_TOKEN(B_EQU);}
{B_NAND}               {EMIT_TOKEN(B_NAND);}
{B_NOR}                {EMIT_TOKEN(B_NOR);}
{TERNARY}              {EMIT_TOKEN(TERNARY);}

{BASE_DECIMAL}         {EMIT_TOKEN(DEC_BASE);}
{BASE_HEX}             {BEGIN(in_hex_val); EMIT_TOKEN(HEX_BASE);}
{BASE_OCTAL}           {BEGIN(in_oct_val); EMIT_TOKEN(OCT_BASE);}
{BASE_BINARY}          {BEGIN(in_bin_val); EMIT_TOKEN(BIN_BASE);}

<in_bin_val>{BIN_VALUE} {BEGIN(INITIAL); yylval.string = yytext; EMIT_TOKEN(BIN_VALUE);}
<in_oct_val>{OCT_VALUE} {BEGIN(INITIAL); yylval.string = yytext; EMIT_TOKEN(OCT_VALUE);}
<in_hex_val>{HEX_VALUE} {BEGIN(INITIAL); yylval.string = yytext; EMIT_TOKEN(HEX_VALUE);}

{NUM_REAL}             {yylval.string=yytext;EMIT_TOKEN(NUM_REAL);}
{NUM_UNSIGNED}         {yylval.string=yytext;EMIT_TOKEN(UNSIGNED_NUMBER);}

{ALWAYS}               {EMIT_TOKEN(KW_ALWAYS);} 
{AND}                  {EMIT_TOKEN(KW_AND);} 
{ASSIGN}               {EMIT_TOKEN(KW_ASSIGN);} 
{AUTOMATIC}            {EMIT_TOKEN(KW_AUTOMATIC);} 
{BEGIN}                {want_newline=true; EMIT_TOKEN(KW_BEGIN);} 
{BUF}                  {EMIT_TOKEN(KW_BUF);} 
{BUFIF0}               {EMIT_TOKEN(KW_BUFIF0);} 
{BUFIF1}               {EMIT_TOKEN(KW_BUFIF1);} 
{CASE}                 {EMIT_TOKEN(KW_CASE);} 
{CASEX}                {EMIT_TOKEN(KW_CASEX);} 
{CASEZ}                {EMIT_TOKEN(KW_CASEZ);} 
{CELL}                 {EMIT_TOKEN(KW_CELL);} 
{CMOS}                 {EMIT_TOKEN(KW_CMOS);} 
{CONFIG}               {EMIT_TOKEN(KW_CONFIG);} 
{DEASSIGN}             {EMIT_TOKEN(KW_DEASSIGN);} 
{DEFAULT}              {EMIT_TOKEN(KW_DEFAULT);} 
{DEFPARAM}             {EMIT_TOKEN(KW_DEFPARAM);} 
{DESIGN}               {EMIT_TOKEN(KW_DESIGN);} 
{DISABLE}              {EMIT_TOKEN(KW_DISABLE);} 
{EDGE}                 {EMIT_TOKEN(KW_EDGE);} 
{ELSE}                 {EMIT_TOKEN(KW_ELSE);} 
{END}                  {want_newline=true; EMIT_TOKEN(KW_END);} 
{ENDCASE}              {want_newline=true; EMIT_TOKEN(KW_ENDCASE);} 
{ENDCONFIG}            {want_newline=true; EMIT_TOKEN(KW_ENDCONFIG);} 
{ENDFUNCTION}          {want_newline=true; EMIT_TOKEN(KW_ENDFUNCTION);} 
{ENDGENERATE}          {want_newline=true; EMIT_TOKEN(KW_ENDGENERATE);} 
{ENDMODULE}            {want_newline=true; EMIT_TOKEN(KW_ENDMODULE);} 
{ENDPRIMITIVE}         {want_newline=true; EMIT_TOKEN(KW_ENDPRIMITIVE);} 
{ENDSPECIFY}           {want_newline=true; EMIT_TOKEN(KW_ENDSPECIFY);} 
{ENDTABLE}             {want_newline=true; EMIT_TOKEN(KW_ENDTABLE);} 
{ENDTASK}              {want_newline=true; EMIT_TOKEN(KW_ENDTASK);} 
{EVENT}                {EMIT_TOKEN(KW_EVENT);} 
{FOR}                  {EMIT_TOKEN(KW_FOR);} 
{FORCE}                {EMIT_TOKEN(KW_FORCE);} 
{FOREVER}              {EMIT_TOKEN(KW_FOREVER);} 
{FORK}                 {EMIT_TOKEN(KW_FORK);} 
{FUNCTION}             {EMIT_TOKEN(KW_FUNCTION);} 
{GENERATE}             {EMIT_TOKEN(KW_GENERATE);} 
{GENVAR}               {EMIT_TOKEN(KW_GENVAR);} 
{HIGHZ0}               {EMIT_TOKEN(KW_HIGHZ0);} 
{HIGHZ1}               {EMIT_TOKEN(KW_HIGHZ1);} 
{IF}                   {EMIT_TOKEN(KW_IF);} 
{IFNONE}               {EMIT_TOKEN(KW_IFNONE);} 
{INCDIR}               {EMIT_TOKEN(KW_INCDIR);} 
{INCLUDE}              {EMIT_TOKEN(KW_INCLUDE);} 
{INITIAL}              {EMIT_TOKEN(KW_INITIAL);} 
{INOUT}                {EMIT_TOKEN(KW_INOUT);} 
{INPUT}                {EMIT_TOKEN(KW_INPUT);} 
{INSTANCE}             {EMIT_TOKEN(KW_INSTANCE);} 
{INTEGER}              {EMIT_TOKEN(KW_INTEGER);} 
{JOIN}                 {EMIT_TOKEN(KW_JOIN);} 
{LARGE}                {EMIT_TOKEN(KW_LARGE);} 
{LIBLIST}              {EMIT_TOKEN(KW_LIBLIST);} 
{LIBRARY}              {EMIT_TOKEN(KW_LIBRARY);} 
{LOCALPARAM}           {EMIT_TOKEN(KW_LOCALPARAM);} 
{MACROMODULE}          {EMIT_TOKEN(KW_MACROMODULE);} 
{MEDIUM}               {EMIT_TOKEN(KW_MEDIUM);} 
{MODULE}               {EMIT_TOKEN(KW_MODULE);} 
{NAND}                 {EMIT_TOKEN(KW_NAND);} 
{NEGEDGE}              {EMIT_TOKEN(KW_NEGEDGE);} 
{NMOS}                 {EMIT_TOKEN(KW_NMOS);} 
{NOR}                  {EMIT_TOKEN(KW_NOR);} 
{NOSHOWCANCELLED}      {EMIT_TOKEN(KW_NOSHOWCANCELLED);} 
{NOT}                  {EMIT_TOKEN(KW_NOT);} 
{NOTIF0}               {EMIT_TOKEN(KW_NOTIF0);} 
{NOTIF1}               {EMIT_TOKEN(KW_NOTIF1);} 
{OR}                   {EMIT_TOKEN(KW_OR);} 
{OUTPUT}               {EMIT_TOKEN(KW_OUTPUT);} 
{PARAMETER}            {EMIT_TOKEN(KW_PARAMETER);} 
{PMOS}                 {EMIT_TOKEN(KW_PMOS);} 
{POSEDGE}              {EMIT_TOKEN(KW_POSEDGE);} 
{PRIMITIVE}            {EMIT_TOKEN(KW_PRIMITIVE);} 
{PULL0}                {EMIT_TOKEN(KW_PULL0);} 
{PULL1}                {EMIT_TOKEN(KW_PULL1);} 
{PULLDOWN}             {EMIT_TOKEN(KW_PULLDOWN);} 
{PULLUP}               {EMIT_TOKEN(KW_PULLUP);} 
{PULSESTYLE_ONEVENT}   {EMIT_TOKEN(KW_PULSESTYLE_ONEVENT);} 
{PULSESTYLE_ONDETECT}  {EMIT_TOKEN(KW_PULSESTYLE_ONDETECT);} 
{RCMOS}                {EMIT_TOKEN(KW_RCMOS);} 
{REAL}                 {EMIT_TOKEN(KW_REAL);} 
{REALTIME}             {EMIT_TOKEN(KW_REALTIME);} 
{REG}                  {EMIT_TOKEN(KW_REG);} 
{RELEASE}              {EMIT_TOKEN(KW_RELEASE);} 
{REPEAT}               {EMIT_TOKEN(KW_REPEAT);} 
{RNMOS}                {EMIT_TOKEN(KW_RNMOS);} 
{RPMOS}                {EMIT_TOKEN(KW_RPMOS);} 
{RTRAN}                {EMIT_TOKEN(KW_RTRAN);} 
{RTRANIF0}             {EMIT_TOKEN(KW_RTRANIF0);} 
{RTRANIF1}             {EMIT_TOKEN(KW_RTRANIF1);} 
{SCALARED}             {EMIT_TOKEN(KW_SCALARED);} 
{SHOWCANCELLED}        {EMIT_TOKEN(KW_SHOWCANCELLED);} 
{SIGNED}               {EMIT_TOKEN(KW_SIGNED);} 
{SMALL}                {EMIT_TOKEN(KW_SMALL);} 
{SPECIFY}              {EMIT_TOKEN(KW_SPECIFY);} 
{SPECPARAM}            {EMIT_TOKEN(KW_SPECPARAM);} 
{STRONG0}              {EMIT_TOKEN(KW_STRONG0);} 
{STRONG1}              {EMIT_TOKEN(KW_STRONG1);} 
{SUPPLY0}              {EMIT_TOKEN(KW_SUPPLY0);} 
{SUPPLY1}              {EMIT_TOKEN(KW_SUPPLY1);} 
{TABLE}                {EMIT_TOKEN(KW_TABLE);} 
{TASK}                 {EMIT_TOKEN(KW_TASK);} 
{TIME}                 {EMIT_TOKEN(KW_TIME);} 
{TRAN}                 {EMIT_TOKEN(KW_TRAN);} 
{TRANIF0}              {EMIT_TOKEN(KW_TRANIF0);} 
{TRANIF1}              {EMIT_TOKEN(KW_TRANIF1);} 
{TRI0}                 {EMIT_TOKEN(KW_TRI0);} 
{TRI1}                 {EMIT_TOKEN(KW_TRI1);} 
{TRIAND}               {EMIT_TOKEN(KW_TRIAND);} 
{TRIOR}                {EMIT_TOKEN(KW_TRIOR);} 
{TRIREG}               {EMIT_TOKEN(KW_TRIREG);} 
{TRI}                  {EMIT_TOKEN(KW_TRI);} 
{UNSIGNED}             {EMIT_TOKEN(KW_UNSIGNED);} 
{USE}                  {EMIT_TOKEN(KW_USE);} 
{VECTORED}             {EMIT_TOKEN(KW_VECTORED);} 
{WAIT}                 {EMIT_TOKEN(KW_WAIT);} 
{WAND}                 {EMIT_TOKEN(KW_WAND);} 
{WEAK0}                {EMIT_TOKEN(KW_WEAK0);} 
{WEAK1}                {EMIT_TOKEN(KW_WEAK1);} 
{WHILE}                {EMIT_TOKEN(KW_WHILE);} 
{WIRE}                 {EMIT_TOKEN(KW_WIRE);} 
{WOR}                  {EMIT_TOKEN(KW_WOR);} 
{XNOR}                 {EMIT_TOKEN(KW_XNOR);} 
{XOR}                  {EMIT_TOKEN(KW_XOR);} 

{SYSTEM_ID}            {
    yylval.identifier = ast_new_identifier(yytext,yylineno); 
    EMIT_TOKEN(SYSTEM_ID);
}
{ESCAPED_ID}           {
    yylval.identifier = ast_new_identifier(yytext,yylineno); 
    EMIT_TOKEN(ESCAPED_ID);
}
{SIMPLE_ID}            {
    yylval.identifier = ast_new_identifier(yytext,yylineno); 
    EMIT_TOKEN(SIMPLE_ID);
}

{STRING}               {yylval.string= yytext;EMIT_TOKEN(STRING);}

<*>{NEWLINE}              {/*EMIT_TOKEN(NEWLINE); IGNORE */   }
<*>{WHITESPACE}           {/*EMIT_TOKEN(SPACE);   IGNORE */   }


<<EOF>> {
        yyterminate();
}

.                      {
    EMIT_TOKEN(ANY);
}

%%
