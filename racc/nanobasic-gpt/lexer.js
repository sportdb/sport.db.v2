
/**
 * NanoBASIC lexer
 *
 * Small, strict, dependency-free lexer.
 *
 * Fundamental invariant:
 *
 *     every source character is accounted for exactly once.
 *
 * The lexer never searches forward for a token. The `y` (sticky)
 * regexp flag guarantees that a match begins exactly at the current
 * position.
 *
 * The lexer:
 *
 *   - recognizes BASIC keywords
 *   - recognizes variables
 *   - recognizes integer/decimal numbers
 *   - recognizes strings
 *   - recognizes operators and punctuation
 *   - recognizes REM and apostrophe comments
 *   - emits explicit EOL tokens
 *   - reports invalid characters with source location
 *
 * Unary +/- are deliberately parser concerns, not lexer concerns.
 */

"use strict";


// ============================================================================
// Token
// ============================================================================

export class Token {
  constructor(type, text, value, line, start, stop) {
    this.type = type;
    this.text = text;
    this.value = value;
    this.line = line;
    this.start = start;
    this.stop = stop;

    Object.freeze(this);
  }

  toString() {
    return (
      `Token(${JSON.stringify(this.type)}, ` +
      `${JSON.stringify(this.text)}, ` +
      `value=${JSON.stringify(this.value)}, ` +
      `@${this.line}:${this.start}..${this.stop})`
    );
  }
}


// ============================================================================
// Lexer error
// ============================================================================

export class LexerError extends Error {
  constructor(message, { line, column, text }) {
    super(
      `${message} at line ${line}, column ${column + 1}: ` +
      `${JSON.stringify(text)}`
    );

    this.name = "LexerError";
    this.line = line;
    this.column = column;
    this.text = text;
  }
}


// ============================================================================
// Lexer
// ============================================================================

export class Lexer {

  // --------------------------------------------------------------------------
  // Token regexp
  //
  // IMPORTANT:
  //
  // The `y` flag makes this regexp STICKY.
  //
  // RegExp.exec() will only match at regexp.lastIndex.
  //
  // That gives us the lexer invariant:
  //
  //     token.start === current position
  //
  // --------------------------------------------------------------------------

  static TOKEN_RE = new RegExp(
    String.raw`
        (?<COMMENT>             rem\b.*)
      | (?<COMMENT_APOSTROPHE>  '.*)

      | (?<WHITESPACE>          [ \t]+)

      | (?<KEYWORD>
            (?:
                PRINT
              | LET
              | IF
              | THEN
              | ELSE
              | GOTO
              | GOSUB
              | RETURN
              | FOR
              | TO
              | STEP
              | NEXT
              | INPUT
              | DIM
              | END
              | STOP
              | RUN
              | LIST
              | NEW
              | CLEAR
            )
            \b
        )

      | (?<STRING>              "[^"]*")

      | (?<NUMBER>              [0-9]+(?:\.[0-9]+)?)

      | (?<VARIABLE>            [A-Za-z_]+)

      # Longer operators must precede their one-character prefixes.
      | (?<SYMBOL>
            <>
          | <=
          | >=
          | =
          | <
          | >
          | \+
          | -
          | \*
          | /
          | \(
          | \)
          | ,
          | ;
        )

      | (?<INVALID>             .)
    `,
    "iy"
  );

  // --------------------------------------------------------------------------
  // Public constructor
  // --------------------------------------------------------------------------

  constructor(source) {
    this.source = source;
  }


  // --------------------------------------------------------------------------
  // tokens()
  //
  // Returns a generator rather than constructing the entire token array.
  //
  // Usage:
  //
  //     for (const token of lexer.tokens()) {
  //       console.log(token);
  //     }
  //
  // Or:
  //
  //     const tokens = [...lexer.tokens()];
  //
  // --------------------------------------------------------------------------

  *tokens() {

    const lines = this.source.split(/\r?\n/);

    for (let index = 0; index < lines.length; index++) {

      const line = lines[index];
      const lineNumber = index + 1;

      yield* this.#tokenizeLine(line, lineNumber);

      // BASIC is line-oriented, so EOL is an explicit token.
      yield new Token(
        "\n",
        "\n",
        "\n",
        lineNumber,
        line.length,
        line.length
      );
    }
  }


  // --------------------------------------------------------------------------
  // tokenizeLine()
  // --------------------------------------------------------------------------

  *#tokenizeLine(line, lineNumber) {

    let position = 0;

    while (position < line.length) {

      const match = Lexer.TOKEN_RE;

      // The sticky regexp uses lastIndex as its input position.
      match.lastIndex = position;

      const result = match.exec(line);

      // Because INVALID matches one character, this should never happen.
      if (result === null) {
        throw new LexerError(
          "Internal lexer error",
          {
            line: lineNumber,
            column: position,
            text: line.slice(position)
          }
        );
      }

      // Defensive assertion.
      if (result.index !== position) {
        throw new LexerError(
          "Lexer skipped input",
          {
            line: lineNumber,
            column: position,
            text: result[0]
          }
        );
      }

      const text = result[0];
      const start = position;
      const stop = match.lastIndex;

      const kind = result.groups
        ? Object.entries(result.groups)
            .find(([, value]) => value !== undefined)?.[0]
        : undefined;

      // ----------------------------------------------------------------------
      // INVALID
      // ----------------------------------------------------------------------

      if (kind === "INVALID") {
        throw new LexerError(
          "Unexpected character",
          {
            line: lineNumber,
            column: position,
            text
          }
        );
      }

      // ----------------------------------------------------------------------
      // WHITESPACE
      // ----------------------------------------------------------------------

      if (kind === "WHITESPACE") {
        position = stop;
        continue;
      }

      // ----------------------------------------------------------------------
      // COMMENT
      // ----------------------------------------------------------------------

      if (
        kind === "COMMENT" ||
        kind === "COMMENT_APOSTROPHE"
      ) {
        // Comment consumes the remainder of the source line.
        position = stop;
        break;
      }

      // ----------------------------------------------------------------------
      // Convert lexical match into Token
      // ----------------------------------------------------------------------

      let type;
      let value;

      switch (kind) {

        case "KEYWORD":
          type = text.toUpperCase();
          value = type;
          break;

        case "STRING":
          type = "STRING";
          value = text.slice(1, -1);
          break;

        case "NUMBER":
          type = "NUMBER";

          // Keep integer numbers as integers and decimal numbers as
          // JavaScript numbers.
          value = text.includes(".")
            ? Number.parseFloat(text)
            : Number.parseInt(text, 10);

          break;

        case "VARIABLE":
          type = "VARIABLE";

          // BASIC is case-insensitive.
          value = text.toUpperCase();

          break;

        case "SYMBOL":
          // Symbolic tokens use their actual spelling as the token type.
          type = text;
          value = text;
          break;

        default:
          throw new LexerError(
            "Unknown token",
            {
              line: lineNumber,
              column: position,
              text
            }
          );
      }

      yield new Token(
        type,
        text,
        value,
        lineNumber,
        start,
        stop
      );

      position = stop;
    }
  }
}


// ============================================================================
// Example
// ============================================================================

const program = `
10 PRINT "HELLO WORLD"
20 LET X = 1
30 PRINT "LOOP NUMBER " + X
40 LET X = X + 1
50 IF X < 4 THEN 30
60 PRINT "DONE!"
`;

const lexer = new Lexer(program);

for (const token of lexer.tokens()) {
  console.log(token.toString());
}
