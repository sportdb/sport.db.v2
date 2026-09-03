package nanobasic

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

type TokenType string

const (
	NUMBER    TokenType = "NUMBER"
	STRING    TokenType = "STRING"
	VARIABLE  TokenType = "VARIABLE"
	PRINT     TokenType = "PRINT"
	IF        TokenType = "IF"
	THEN      TokenType = "THEN"
	LET       TokenType = "LET"
	GOTO      TokenType = "GOTO"
	GOSUB     TokenType = "GOSUB"
	RETURN    TokenType = "RETURN"
	SYMBOL    TokenType = "SYMBOL"
	EOL       TokenType = "EOL"
)

type Token struct {
	Type  TokenType
	Text  string
	Value any
	Line  int
	Start int
}

type LexerError struct {
	Line   int
	Column int
	Char   string
}

func (e *LexerError) Error() string {
	return fmt.Sprintf(
		"unexpected character %q at line %d, column %d",
		e.Char, e.Line, e.Column,
	)
}

var (
	numberRE   = regexp.MustCompile(`^[0-9]+`)
	variableRE = regexp.MustCompile(`^[A-Za-z_]+`)
	stringRE   = regexp.MustCompile(`^"[^"]*"`)

	// Longest operators first.
	symbolRE = regexp.MustCompile(`^(<>|<=|>=|=|<|>|\+|-|\*|/|\(|\)|,)`)
)

var keywords = map[string]TokenType{
	"PRINT":  PRINT,
	"IF":     IF,
	"THEN":   THEN,
	"LET":    LET,
	"GOTO":   GOTO,
	"GOSUB":  GOSUB,
	"RETURN": RETURN,
}

// Lexer tokenizes NanoBASIC source.
type Lexer struct {
	source string
}

// NewLexer creates a lexer for source.
func NewLexer(source string) *Lexer {
	return &Lexer{source: source}
}

// Tokens returns all tokens in the source.
func (l *Lexer) Tokens() ([]Token, error) {
	var tokens []Token

	lines := strings.SplitAfter(l.source, "\n")

	for lineNo, line := range lines {
		// If the source ends with '\n', SplitAfter gives us a final
		// empty element. There is no additional BASIC line there.
		if line == "" && lineNo == len(lines)-1 && strings.HasSuffix(l.source, "\n") {
			break
		}

		// Remove the physical newline for scanning.
		hasNewline := strings.HasSuffix(line, "\n")
		if hasNewline {
			line = strings.TrimSuffix(line, "\n")
			line = strings.TrimSuffix(line, "\r")
		}

		pos := 0

		for pos < len(line) {
			rest := line[pos:]

			// Whitespace.
			if rest[0] == ' ' || rest[0] == '\t' {
				pos++
				continue
			}

			// Apostrophe comment.
			if rest[0] == '\'' {
				break
			}

			// REM comment.
			if len(rest) >= 3 &&
				strings.EqualFold(rest[:3], "REM") &&
				(len(rest) == 3 || !isIdentifierChar(rest[3])) {
				break
			}

			// String.
			if m := stringRE.FindString(rest); m != "" {
				value := m[1 : len(m)-1]

				tokens = append(tokens, Token{
					Type:  STRING,
					Text:  m,
					Value: value,
					Line:  lineNo + 1,
					Start: pos,
				})

				pos += len(m)
				continue
			}

			// Number.
			if m := numberRE.FindString(rest); m != "" {
				value, err := strconv.Atoi(m)
				if err != nil {
					return nil, err
				}

				tokens = append(tokens, Token{
					Type:  NUMBER,
					Text:  m,
					Value: value,
					Line:  lineNo + 1,
					Start: pos,
				})

				pos += len(m)
				continue
			}

			// Variable or keyword.
			if m := variableRE.FindString(rest); m != "" {
				upper := strings.ToUpper(m)

				if typ, ok := keywords[upper]; ok {
					tokens = append(tokens, Token{
						Type:  typ,
						Text:  m,
						Value: upper,
						Line:  lineNo + 1,
						Start: pos,
					})
				} else {
					tokens = append(tokens, Token{
						Type:  VARIABLE,
						Text:  m,
						Value: upper,
						Line:  lineNo + 1,
						Start: pos,
					})
				}

				pos += len(m)
				continue
			}

			// Operators and punctuation.
			if m := symbolRE.FindString(rest); m != "" {
				tokens = append(tokens, Token{
					Type:  SYMBOL,
					Text:  m,
					Value: m,
					Line:  lineNo + 1,
					Start: pos,
				})

				pos += len(m)
				continue
			}

			return nil, &LexerError{
				Line:   lineNo + 1,
				Column: pos + 1,
				Char:   rest[:1],
			}
		}

		// BASIC is line-oriented, so EOL is significant.
		if hasNewline || lineNo < len(lines)-1 {
			tokens = append(tokens, Token{
				Type:  EOL,
				Text:  "\n",
				Line:  lineNo + 1,
				Start: len(line),
			})
		}
	}

	return tokens, nil
}

func isIdentifierChar(c byte) bool {
	return c >= 'A' && c <= 'Z' ||
		c >= 'a' && c <= 'z' ||
		c == '_'
}