# Syntax Directed Translation with Jison

Jison is a tool that receives as input a Syntax Directed Translation and produces as output a JavaScript parser  that executes
the semantic actions in a bottom up ortraversing of the parse tree.
 

## Compile the grammar to a parser

See file [grammar.jison](./src/grammar.jison) for the grammar specification. To compile it to a parser, run the following command in the terminal:
``` 
➜  jison git:(main) ✗ npx jison grammar.jison -o parser.js
```

## Use the parser

After compiling the grammar to a parser, you can use it in your JavaScript code. For example, you can run the following code in a Node.js environment:

```
➜  jison git:(main) ✗ node                                
Welcome to Node.js v25.6.0.
Type ".help" for more information.
> p = require("./parser.js")
{
  parser: { yy: {} },
  Parser: [Function: Parser],
  parse: [Function (anonymous)],
  main: [Function: commonjsMain]
}
> p.parse("2*3")
6
```

# Practica 4 Procesadores de Lenguajes

## Ejercicio 2
Para este ejercicio teniendo en cuenta el siguiente trozo de código
```javascript
%lex
%%
\s+                   { /* skip whitespace */; }
[0-9]+                { return 'NUMBER';       }
"**"                  { return 'OP';           }
[-+*/]                { return 'OP';           }
<<EOF>>               { return 'EOF';          }
.                     { return 'INVALID';      }
/lex
```

### 2.1 Diferencia entre retornar un token y un whitespace.

La diferencia entre ambos es que donde aparezca algo que se pueda considerar un token, el analizador léxico va a **devolver** algo, en cambio al detectar un whitespace, no se va a preocupar en devolve nada, solo ignorara dicho whitespace para el resultado.

### 2.2 Escriba la secuencia exacta de tokens producidos para la entrada 123**45+@.

Para esta entrada se produciran 7 tokens, y no 8, porque el @ al no poder ser detectado, el analizador léxico va a devolver un error.

### 2.3 Indique por qué ** debe aparecer antes que [-+*/].

De esta manera al encontrarse un *'**'* al estar la producción ** primero, no se va a detectar como dos token, si no como un único token

### 2.4 Explique cuándo se devuelve EOF.

El EOF o final de linea se va a devolver cuando en la entrada se detecte que se uso enter, es decir cuando se haya añadido un salto de línea.

### 2.5 Explique por qué existe la regla . que devuelve INVALID.

Existe para recoger especificamente los carácteres que no se permiten, esto ayuda a poder capturar los errores y hacerle saber al usuario donde se equivoco.