
This is a scanner for Verilog; purpose:
- delete whitespace, regularise line-breaks,
- optionally replace identifiers/numbers with generic tokens.

This code is a hacked version of the scanner from:
	https://github.com/ben-marshall/verilog-parser

I basically removed the parser/AST code as well as the
preprocessor so that the .l file would work stand-alone.

The original code weas released unde the MIT License;
see the file LICENSE.txt for details.


James Power <james.power@mu.ie>
14 August 2019.

