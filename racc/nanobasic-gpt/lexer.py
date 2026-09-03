"""
NanoBASIC lexer.

The lexer works one source line at a time and produces a stream of Token
objects.

Important invariant:

    every character is consumed exactly once.

The lexer never searches forward for the next token.  A token must begin
exactly at the current position.  Anything not recognized by the lexer is
an error.

This lexer intentionally keeps the language small.  More sophisticated
features should be added only when the grammar needs them.
"""

from __future__ import annotations

from dataclasses import dataclass
import re


# ---------------------------------------------------------------------------
# Token
# ---------------------------------------------------------------------------

@dataclass(frozen=True, slots=True)
class Token:
    type: str
    text: str
    value: object
    lineno: int
    start: int
    stop: int

    def __repr__(self) -> str:
        return (
            f"Token({self.type!r}, {self.text!r}, "
            f"value={self.value!r}, "
            f"@{self.lineno}:{self.start}..{self.stop})"
        )


# ---------------------------------------------------------------------------
# Lexer errors
# ---------------------------------------------------------------------------

class LexerError(Exception):

    def __init__(
        self,
        message: str,
        *,
        lineno: int,
        position: int,
        text: str,
    ) -> None:

        self.lineno = lineno
        self.position = position
        self.text = text

        super().__init__(
            f"{message} at line {lineno}, "
            f"column {position + 1}: {text!r}"
        )


# ---------------------------------------------------------------------------
# Lexer
# ---------------------------------------------------------------------------

class Lexer:

    # -----------------------------------------------------------------------
    # Token patterns
    #
    # Order matters.
    #
    #   COMMENT before VARIABLE
    #   KEYWORD before VARIABLE
    #   multi-character operators before their prefixes
    #
    # The final INVALID alternative guarantees that a character can never
    # silently disappear from the input.
    # -----------------------------------------------------------------------

    _TOKEN_RE = re.compile(
        r"""
        (?P<COMMENT>           rem\b.*)
      | (?P<COMMENT_APOSTROPHE> '.*)

      | (?P<WHITESPACE>        [ \t]+)

      | (?P<KEYWORD>
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

      | (?P<STRING>            "[^"]*")

      | (?P<NUMBER>            [0-9]+(?:\.[0-9]+)?)

      | (?P<VARIABLE>          [A-Za-z_]+)

      # Longer operators must precede their one-character prefixes.
      | (?P<SYMBOL>
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

      | (?P<INVALID>           .)
        """,
        re.IGNORECASE | re.VERBOSE,
    )

    def __init__(self, source: str) -> None:
        self.source = source

    # -----------------------------------------------------------------------
    # Public API
    # -----------------------------------------------------------------------

    def tokens(self) -> list[Token]:
        """
        Return the complete token stream.

        An explicit EOL token is emitted for every source line.
        """

        result: list[Token] = []

        for lineno, line in enumerate(self.source.splitlines(), start=1):
            result.extend(self._tokenize_line(line, lineno))

            # EOL is deliberately a real token.  BASIC is line-oriented.
            result.append(
                Token(
                    type="\n",
                    text="\n",
                    value="\n",
                    lineno=lineno,
                    start=len(line),
                    stop=len(line),
                )
            )

        return result

    # -----------------------------------------------------------------------
    # Line lexer
    # -----------------------------------------------------------------------

    def _tokenize_line(
        self,
        line: str,
        lineno: int,
    ) -> list[Token]:

        result: list[Token] = []
        pos = 0

        while pos < len(line):

            match = self._TOKEN_RE.match(line, pos)

            if match is None:
                # This should be impossible because INVALID matches one
                # character, but keep the invariant explicit.
                raise LexerError(
                    "internal lexer error",
                    lineno=lineno,
                    position=pos,
                    text=line[pos:],
                )

            # Python's re.Pattern.match() already requires the match to
            # begin at pos.  This assertion documents that invariant.
            if match.start() != pos:
                raise LexerError(
                    "lexer skipped input",
                    lineno=lineno,
                    position=pos,
                    text=match.group(),
                )

            text = match.group()
            start = pos
            stop = pos + len(text)

            # ---------------------------------------------------------------
            # Invalid character
            # ---------------------------------------------------------------

            if match.group("INVALID") is not None:
                raise LexerError(
                    "unexpected character",
                    lineno=lineno,
                    position=pos,
                    text=text,
                )

            # ---------------------------------------------------------------
            # Whitespace
            # ---------------------------------------------------------------

            if match.group("WHITESPACE") is not None:
                pos = stop
                continue

            # ---------------------------------------------------------------
            # Comments
            # ---------------------------------------------------------------

            if (
                match.group("COMMENT") is not None
                or match.group("COMMENT_APOSTROPHE") is not None
            ):
                # A comment consumes the rest of the source line.
                pos = stop
                break

            # ---------------------------------------------------------------
            # Determine token type/value
            # ---------------------------------------------------------------

            if match.group("KEYWORD") is not None:

                value = text.upper()

                token_type = value

            elif match.group("STRING") is not None:

                # Remove the surrounding quotes.
                value = text[1:-1]

                token_type = "STRING"

            elif match.group("NUMBER") is not None:

                if "." in text:
                    value = float(text)
                else:
                    value = int(text)

                token_type = "NUMBER"

            elif match.group("VARIABLE") is not None:

                # BASIC is traditionally case-insensitive.
                value = text.upper()

                token_type = "VARIABLE"

            elif match.group("SYMBOL") is not None:

                # Symbolic tokens use their source spelling as their type.
                token_type = text
                value = text

            else:
                raise LexerError(
                    "unknown token",
                    lineno=lineno,
                    position=pos,
                    text=text,
                )

            result.append(
                Token(
                    type=token_type,
                    text=text,
                    value=value,
                    lineno=lineno,
                    start=start,
                    stop=stop,
                )
            )

            pos = stop

        return result


# ---------------------------------------------------------------------------
# Example
# ---------------------------------------------------------------------------

if __name__ == "__main__":

    program = """\
10 PRINT "HELLO WORLD"
20 LET X = 1
30 PRINT "LOOP NUMBER " + X
40 LET X = X + 1
50 IF X < 4 THEN 30
60 PRINT "DONE!"
"""

    lexer = Lexer(program)

    for token in lexer.tokens():
        print(token)
