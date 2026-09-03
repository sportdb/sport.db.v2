/**
 * NanoBASIC lexer
 *
 * Modern TypeScript, dependency-free.
 *
 * Design goals:
 *
 *   - tiny and explicit
 *   - every source character is consumed exactly once
 *   - sticky regexp (`y`) prevents skipped input
 *   - token type and token value are type-safe
 *   - explicit EOL tokens
 *   - comments are lexer trivia
 *   - unary +/- are parser concerns
 */


// ============================================================================
// Token types
// ============================================================================

export const KEYWORDS = [
  "PRINT",
  "LET",
  "IF",
  "THEN",
  "ELSE",
  "GOTO",
  "GOSUB",
  "RETURN",
  "FOR",
  "TO",
  "STEP",
  "NEXT",
  "INPUT",
  "DIM",
  "END",
  "STOP",
  "RUN",
  "LIST",
  "NEW",
  "CLEAR",
] as const;

export type Keyword = typeof KEYWORDS[number];


// Symbols are deliberately their source spelling.
//
// This makes a Racc/Bison-style grammar pleasantly readable:
//
//     expression : expression "+" expression
//
export const SYMBOLS = [
  "<>",
  "<=",
  ">=",
  "=",
  "<",
  ">",
  "+",
  "-",
  "*",
  "/",
  "(",
  ")",
  ",",
  ";",
] as const;

export type Symbol = typeof SYMBOLS[number];


// ============================================================================
// Token model
// ============================================================================
//
// This is where TypeScript earns its keep.
//
// A Token is a discriminated union:
//
//     token.type === "NUMBER"
//         => token.value is number
//
//     token.type === "STRING"
//         => token.value is string
//
//     token.type === "VARIABLE"
//         => token.value is string
//
//     token.type === "+"
//         => token.value is exactly "+"
// ============================================================================

export interface NumberToken {
  readonly type: "NUMBER";
  readonly text: string;
  readonly value: number;
  readonly line: number;
  readonly start: number;
  readonly stop: number;
}

export interface StringToken {
  readonly type: "STRING";
  readonly text: string;
  readonly value: string;
  readonly line: number;
  readonly start: number;
  readonly stop: number;
}

export interface VariableToken {
  readonly type: "VARIABLE";
  readonly text: string;
  readonly value: string;
  readonly line: number;
  readonly start: number;
  readonly stop: number;
}

export interface KeywordToken {
  readonly type: Keyword;
  readonly text: string;
  readonly value: Keyword;
  readonly line: number;
  readonly start: number;
  readonly stop: number;
}

export interface SymbolToken {
  readonly type: Symbol;
  readonly text: string;
  readonly value: Symbol;
  readonly line: number;
  readonly start: number;
  readonly stop: number;
}

export interface EolToken {
  readonly type: "EOL";
  readonly text: "\n";
  readonly value: "\n";
  readonly line: number;
  readonly start: number;
  readonly stop: number;
}


// The parser sees this type.
//
// TypeScript can narrow the union automatically:
//
//     if (token.type === "NUMBER") {
//       token.value.toFixed(2);
//     }
//
export type Token =
  | NumberToken
  | StringToken
  | VariableToken
  | KeywordToken
  | SymbolToken
  | EolToken;


// ============================================================================
// Lexer error
// ============================================================================

export class LexerError extends Error {
  readonly line: number;
  readonly column: number;
  readonly text: string;

  constructor(
    message: string,
    options: {
      line: number;
      column: number;
      text: string;
    },
  ) {
    super(
      `${message} at line ${options.line}, ` +
      `column ${options.column + 1}: ${JSON.stringify(options.text)}`,
    );

    this.name = "LexerError";
    this.line = options.line;
    this.column = options.column;
    this.text = options.text;
  }
}


// ============================================================================
// Internal regexp token kinds
// ============================================================================
//
// These are NOT parser tokens.
//
// They describe which regexp alternative matched.
// ============================================================================

type RegexTokenKind =
  | "COMMENT"
  | "COMMENT_APOSTROPHE"
  | "WHITESPACE"
  | "KEYWORD"
  | "STRING"
  | "NUMBER"
  | "VARIABLE"
  | "SYMBOL"
  | "INVALID";


// ============================================================================
// Lexer
// ============================================================================

export class Lexer {

  /**
   * The `y` flag means "sticky".
   *
   * RegExp.exec() must match exactly at `lastIndex`.
   *
   * Therefore:
   *
   *     position
   *         ↓
   *     [ TOKEN ]
   *               ↓
   *            position
   *
   * No characters can be skipped.
   */
  private static readonly TOKEN_RE = new RegExp(
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

      # Longer operators must precede their prefixes.
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
    "iy",
  );


  // --------------------------------------------------------------------------
  // Public API
  // --------------------------------------------------------------------------

  constructor(
    private readonly source: string,
  ) {}


  /**
   * Lazily produce tokens.
   *
   * The caller can either:
   *
   *     for (const token of lexer.tokens()) {
   *       ...
   *     }
   *
   * or:
   *
   *     const tokens = [...lexer.tokens()];
   */
  *tokens(): Generator<Token> {

    const lines = this.source.split(/\r?\n/);

    for (let index = 0; index < lines.length; index++) {

      const line = lines[index];
      const lineNumber = index + 1;

      yield* this.tokenizeLine(line, lineNumber);

      // BASIC is line-oriented.
      yield {
        type: "EOL",
        text: "\n",
        value: "\n",
        line: lineNumber,
        start: line.length,
        stop: line.length,
      };
    }
  }


  // --------------------------------------------------------------------------
  // Line lexer
  // --------------------------------------------------------------------------

  private *tokenizeLine(
    line: string,
    lineNumber: number,
  ): Generator<Token> {

    let position = 0;

    while (position < line.length) {

      const regexp = Lexer.TOKEN_RE;

      regexp.lastIndex = position;

      const match = regexp.exec(line);

      // INVALID matches one character, so this should never happen.
      if (match === null) {
        throw new LexerError(
          "Internal lexer error",
          {
            line: lineNumber,
            column: position,
            text: line.slice(position),
          },
        );
      }

      // Defensive assertion of the lexer invariant.
      if (match.index !== position) {
        throw new LexerError(
          "Lexer skipped input",
          {
            line: lineNumber,
            column: position,
            text: match[0],
          },
        );
      }

      const text = match[0];

      const start = position;
      const stop = regexp.lastIndex;

      const kind = this.matchKind(match);

      // ---------------------------------------------------------------
      // Invalid character
      // ---------------------------------------------------------------

      if (kind === "INVALID") {
        throw new LexerError(
          "Unexpected character",
          {
            line: lineNumber,
            column: position,
            text,
          },
        );
      }

      // ---------------------------------------------------------------
      // Whitespace
      // ---------------------------------------------------------------

      if (kind === "WHITESPACE") {
        position = stop;
        continue;
      }

      // ---------------------------------------------------------------
      // Comment
      // ---------------------------------------------------------------

      if (
        kind === "COMMENT" ||
        kind === "COMMENT_APOSTROPHE"
      ) {
        // Comment consumes the remainder of the source line.
        position = stop;
        break;
      }

      // ---------------------------------------------------------------
      // Token conversion
      // ---------------------------------------------------------------

      switch (kind) {

        case "KEYWORD": {
          const value = text.toUpperCase() as Keyword;

          yield {
            type: value,
            text,
            value,
            line: lineNumber,
            start,
            stop,
          };

          break;
        }

        case "STRING": {
          yield {
            type: "STRING",
            text,
            value: text.slice(1, -1),
            line: lineNumber,
            start,
            stop,
          };

          break;
        }

        case "NUMBER": {
          const value = text.includes(".")
            ? Number.parseFloat(text)
            : Number.parseInt(text, 10);

          yield {
            type: "NUMBER",
            text,
            value,
            line: lineNumber,
            start,
            stop,
          };

          break;
        }

        case "VARIABLE": {
          yield {
            type: "VARIABLE",
            text,
            value: text.toUpperCase(),
            line: lineNumber,
            start,
            stop,
          };

          break;
        }

        case "SYMBOL": {
          const value = text as Symbol;

          yield {
            type: value,
            text,
            value,
            line: lineNumber,
            start,
            stop,
          };

          break;
        }

        default:
          // TypeScript's `never` check makes adding a new RegexTokenKind
          // without handling it here a compile-time error.
          this.assertNever(kind);
      }

      position = stop;
    }
  }


  // --------------------------------------------------------------------------
  // Identify the regexp alternative that matched
  // --------------------------------------------------------------------------

  private matchKind(match: RegExpExecArray): RegexTokenKind {

    const groups = match.groups;

    if (!groups) {
      throw new Error("Runtime does not support named regexp groups");
    }

    for (const kind of [
      "COMMENT",
      "COMMENT_APOSTROPHE",
      "WHITESPACE",
      "KEYWORD",
      "STRING",
      "NUMBER",
      "VARIABLE",
      "SYMBOL",
      "INVALID",
    ] as const) {

      if (groups[kind] !== undefined) {
        return kind;
      }
    }

    throw new Error("Internal lexer error: no regexp group matched");
  }


  // --------------------------------------------------------------------------
  // Exhaustiveness helper
  // --------------------------------------------------------------------------

  private assertNever(value: never): never {
    throw new Error(`Unhandled lexer token kind: ${value}`);
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
  console.log(token);
}
