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

# Practica 4 Procesadores de Lenguajes Primera Parte

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

# Práctica 5 Procesadores de Lenguaje Segunda Parte
### 1 Partiendo de la gramática y las siguientes frases 4.0-2.0*3.0, 2**3**2 y 7-4/2

#### 1.1 Escriba la derivación para cada una de las frases.

- 4.0-2.0*3.0
```
L
→ E eof
→ E op T eof
→ E op T op T eof
→ T op T op T eof
→ number op T op T eof
→ 4.0 op T op T eof
→ 4.0 - T op T eof
→ 4.0 - number op T eof
→ 4.0 - 2.0 op T eof
→ 4.0 - 2.0 * T eof
→ 4.0 - 2.0 * number eof
→ 4.0 - 2.0 * 3.0 eof
```

- 2\**3\**2
```
L
→ E eof
→ E op T eof
→ E op T op T eof
→ T op T op T eof
→ 2 ** 3 ** 2
```
(Se resume en menos derivaciones, pero se comporta igual que el primer apartado)

- 7-4/2
```
L
→ E eof
→ E op T eof
→ E op T op T eof
→ T op T op T eof
→ 7 - 4 / 2
```
(El mismo caso que el segundo apartado)

#### 1.2 Escriba el árbol de análisis sintáctico (parse tree) para cada una de las frases.

- 4.0-2.0*3.0
```
        E
      / | \
     E  *  T
   / | \    |
  E  -  T   3.0
  |     |
  T     2.0
  |
 4.0
```

Este arbol sintáctico al evaluarse de izquierda a derecha quedaría un resultado como (4.0 - 2.0) * 3.0 lo cual no es correcto matemáticamente

- 2\**3\**2
```
        E
      / | \
     E ** T
   / | \   |
  E ** T   2
  |    |
  2    3
```

Este arbol sintáctico al evaluarse de izquierda a derecha quedaría un resultado como (2 ** 3) ** 2 lo cual no es correcto matemáticamente- Sería correcto 2 ** (3 ** 2)


- 7-4/2
```
        E
      / | \
     E  /  T
   / | \    |
  E  -  T   2
  |     |
  T     4
  |
  7
```

Este arbol sintáctico al evaluarse de izquierda a derecha quedaría un resultado como (7 - 4) / 2 lo cual no es correcto matemáticamente

#### 1.3. ¿En qué orden se evaluan las acciones semánticas para cada una de las frases?

Para todas las frases, es están evaluando de izquierda a derecha sin tener en cuenta la procedencia de los operadores, evaluando lo primero que se encuentra.



