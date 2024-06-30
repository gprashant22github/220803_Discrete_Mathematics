# Kanpur Language Lexical Analyzer

## Overview
This project implements a lexical analyzer (scanner) for the Kanpur programming language using Flex. The lexical analyzer identifies and classifies lexemes into various token types such as keywords, operators, identifiers, strings, delimiters, integers, floating-point numbers, and hexadecimal literals.

## Features
- Recognizes keywords, operators, identifiers, strings, delimiters, integers, floating-point numbers, and hexadecimal literals.
- Handles multiline strings, comments, and whitespace.
- Case-insensitive for keywords and operators; case-sensitive for identifiers.
- Reports errors for illegal characters and ill-formed strings.

## Usage
To use the lexical analyzer:
1. Clone the repository :
git clone https://github.com/gprashant22github/lexical-analyzer.git
2. Compile the lexical analyzer : <br>
    (I) flex prob1.1.l <br>
    (II) gcc lex.yy.c -o lexer -lfl

3. Run the lexical analyzer on a Kanpur program file :
./lexer public1.knp.
Replace `public1.knp` with your Kanpur program file.

4. View the output which lists and classifies all lexemes.

## Example Output

LEXEME    TOKEN       COUNT <br>
--------------------------- <br>
BEGIN     KEYWORD     1 <br>
ELSE      KEYWORD     1 <br>
END       KEYWORD     1 <br>
GT        OPERATOR    1 <br>
IF        KEYWORD     1 <br>
INTEGER   KEYWORD     1 <br>
PRINT     IDENTIFIER  1 <br>
STRING    "x is greater than y"  1 <br>
STRING    " y is greater than x"  1 <br>
...       ...         ... <br>



## Requirements
- Flex (Lexical Analyzer Generator)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
