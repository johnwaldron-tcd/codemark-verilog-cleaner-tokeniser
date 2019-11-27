#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "verilog_parser.tab.h"

extern int yylex (void);
extern char *yytext;

/* The scanner sets this to 1 if it wants a newline after the token */
extern bool want_newline;

/* Command-line flag to anonymise identifiers and numbers */
#define ANON_IDENTS 'i'

int main(int argc, char *argv[])
{
  int generic_ident = ((argc > 1) && argv[1][0] == ANON_IDENTS);
  bool last_was_newline = false;
  int c;
  
  while ((c = yylex())) {

    /* Maybe an extra newline before the token: */
    if ((c==KW_IF || c==KW_ELSE || c==KW_CASE || c==KW_ALWAYS || c==KW_BEGIN) 
        && ! last_was_newline) {
      printf("\n");
    }

    /* The token itself: */
    switch(c) {
      case ANY: /* IGNORE */ break;

      case SYSTEM_ID:
      case ESCAPED_ID:
      case SIMPLE_ID: 
        if (generic_ident)
          printf("IDENT"); 
        else
          printf("%s", yytext);
        break;

      case BIN_VALUE:
      case OCT_VALUE:
      case HEX_VALUE:
      case NUM_REAL:
      case NUM_SIZE:
      case UNSIGNED_NUMBER:
        if (generic_ident)
          printf("NUM"); 
        else
          printf("%s", yytext);
        break;

      default: printf("%s", yytext);
    }

    /* Either a space or newline after each token: */
    if (want_newline) {
      printf("\n"); 
      last_was_newline = true; 
    }
    else { 
      printf(" "); 
      last_was_newline = false;
    }
    want_newline = false;

  }

  return EXIT_SUCCESS;
}

