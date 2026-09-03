
// Package nanobasic implements the lexical analysis of NanoBASIC.
package nanobasic

import (
	"fmt"
	"strconv"
	"strings"
	"unicode"
)

// ============================================================================
// Token types
// ============================================================================

type TokenType int

const (
	TokenInvalid TokenType = iota

	TokenNumber
	TokenString
	TokenVariable

	// Keywords.
	TokenPrint
	TokenLet
	TokenIf
	TokenThen
	TokenElse
	TokenGoto
	TokenGosub
	TokenReturn
	TokenFor
	TokenTo
	TokenStep
	TokenNext
	TokenInput
	TokenDim
	TokenEnd
	TokenStop
	TokenRun
	TokenList
	TokenNew
	TokenClear

	// Symbols.
	TokenLessGreater // <>
	TokenLessEqual    // <=
	TokenGreaterEqual // >=
	TokenEqual        // =
	TokenLess         // <
	TokenGreater      // >
	TokenPlus         // +
	TokenMinus        // -
	TokenMultiply     // *
	TokenDivide       // /
	TokenLeftParen    // (
	TokenRightParen   // )
	TokenComma        // ,
	TokenSemicolon    // ;

	TokenEOL
)

func (t TokenType) String() string {
	switch t {
	case TokenInvalid:
		return "INVALID"

	case TokenNumber:
		return "NUMBER"
	case TokenString:
		return "STRING"
	case TokenVariable:
		return "VARIABLE"

	case TokenPrint:
		return "PRINT"
	case TokenLet:
		return "LET"
	case TokenIf:
		return "IF"
	case TokenThen:
		return "THEN"
	case TokenElse:
		return "ELSE"
	case TokenGoto:
		return "GOTO"
	case TokenGosub:
		return "GOSUB"
	case TokenReturn:
		return "RETURN"
	case TokenFor:
		return "FOR"
	case TokenTo:
		return "TO"
	case TokenStep:
		return "STEP"
	case TokenNext:
		return "NEXT"
	case TokenInput:
		return "INPUT"
	case TokenDim:
		return "DIM"
	case TokenEnd:
		return "END"
	case TokenStop:
		return "STOP"
	case TokenRun:
		return "RUN"
	case TokenList:
		return "LIST"
	case TokenNew:
		return "NEW"
	case TokenClear:
		return "CLEAR"

	case TokenLessGreater:
		return "<>"
	case TokenLessEqual:
		return "<="
	case TokenGreaterEqual:
		return ">="
	case TokenEqual:
		return "="
	case TokenLess:
		return "<"
	case TokenGreater:
		return ">"
	case TokenPlus:
		return "+"
	case TokenMinus:
		return "-"
	case TokenMultiply:
		return "*"
	case TokenDivide:
		return "/"
	case TokenLeftParen:
		return "("
	case TokenRightParen:
		return ")"
	case TokenComma:
		return ","
	case TokenSemicolon:
		return ";"

	case TokenEOL:
		return "EOL"

	default:
		return "UNKNOWN"
	}
}


// ============================================================================
// Token
// ============================================================================

type Token struct {
	Type TokenType

	// Original source spelling.
	Text string

	// Parsed value.
	//
	// Number  -> int64 or float64
	// String  -> string without quotes
	// Variable -> upper-case variable name
	// Keyword -> upper-case keyword
	// Symbol  -> symbol itself
	Value any

	Line  int
	Start int
	Stop  int
}

func (t Token) String() string {
	return fmt.Sprintf(
		"Token(%s, %q, value=%#v, @%d:%d..%d)",
		t.Type,
		t.Text,
		t.Value,
		t.Line,
		t.Start,
		t.Stop,
	)
}


// ============================================================================
// Lexer error
// ============================================================================

type LexerError struct {
	Message string
	Line    int
	Column  int
	Text    string
}

func (e *LexerError) Error() string {
	return fmt.Sprintf(
		"%s at line %d, column %d: %q",
		e.Message,
		e.Line,
		e.Column+1,
		e.Text,
	)
}


// ============================================================================
// Lexer
// ============================================================================

type Lexer struct {
	source string
}


// NewLexer creates a lexer for source.
func NewLexer(source string) *Lexer {
	return &Lexer{
		source: source,
	}
}


// Tokens lexes the complete program.
//
// An explicit EOL token is emitted for every source line.
func (l *Lexer) Tokens() ([]Token, error) {
	var tokens []Token

	lines := strings.Split(
		strings.ReplaceAll(l.source, "\r\n", "\n"),
		"\n",
	)

	for lineIndex, line := range lines {
		lineNumber := lineIndex + 1

		lineTokens, err := l.tokenizeLine(line, lineNumber)
		if err != nil {
			return nil, err
		}

		tokens = append(tokens, lineTokens...)

		tokens = append(tokens, Token{
			Type:  TokenEOL,
			Text:  "\n",
			Value: "\n",
			Line:  lineNumber,
			Start: len(line),
			Stop:  len(line),
		})
	}

	return tokens, nil
}


// ============================================================================
// Line lexer
// ============================================================================

func (l *Lexer) tokenizeLine(
	line string,
	lineNumber int,
) ([]Token, error) {

	var tokens []Token

	position := 0

	for position < len(line) {

		// ------------------------------------------------------------
		// Whitespace
		// ------------------------------------------------------------

		if line[position] == ' ' || line[position] == '\t' {
			position++
			continue
		}

		start := position

		// ------------------------------------------------------------
		// Apostrophe comment
		// ------------------------------------------------------------

		if line[position] == '\'' {
			// Comment consumes the remainder of the line.
			break
		}

		// ------------------------------------------------------------
		// REM comment
		// ------------------------------------------------------------

		if hasWordAt(line, position, "REM") {
			break
		}

		// ------------------------------------------------------------
		// String
		// ------------------------------------------------------------

		if line[position] == '"' {

			position++

			stringStart := position

			for position < len(line) && line[position] != '"' {
				position++
			}

			if position >= len(line) {
				return nil, &LexerError{
					Message: "unterminated string",
					Line:    lineNumber,
					Column:  start,
					Text:    line[start:],
				}
			}

			value := line[stringStart:position]

			// Consume closing quote.
			position++

			tokens = append(tokens, Token{
				Type:  TokenString,
				Text:  line[start:position],
				Value: value,
				Line:  lineNumber,
				Start: start,
				Stop:  position,
			})

			continue
		}

		// ------------------------------------------------------------
		// Number
		// ------------------------------------------------------------

		if isDigit(line[position]) {

			hasDecimal := false

			for position < len(line) &&
				isDigit(line[position]) {

				position++
			}

			if position < len(line) && line[position] == '.' {

				hasDecimal = true
				position++

				for position < len(line) &&
					isDigit(line[position]) {

					position++
				}
			}

			text := line[start:position]

			var value any

			if hasDecimal {
				parsed, err := strconv.ParseFloat(text, 64)
				if err != nil {
					return nil, &LexerError{
						Message: "invalid number",
						Line:    lineNumber,
						Column:  start,
						Text:    text,
					}
				}

				value = parsed

			} else {
				parsed, err := strconv.ParseInt(text, 10, 64)
				if err != nil {
					return nil, &LexerError{
						Message: "invalid number",
						Line:    lineNumber,
						Column:  start,
						Text:    text,
					}
				}

				value = parsed
			}

			tokens = append(tokens, Token{
				Type:  TokenNumber,
				Text:  text,
				Value: value,
				Line:  lineNumber,
				Start: start,
				Stop:  position,
			})

			continue
		}

		// ------------------------------------------------------------
		// Identifier / keyword
		// ------------------------------------------------------------

		if isIdentifierStart(line[position]) {

			for position < len(line) &&
				isIdentifierPart(line[position]) {

				position++
			}

			text := line[start:position]
			upper := strings.ToUpper(text)

			if tokenType, ok := keywordType(upper); ok {

				tokens = append(tokens, Token{
					Type:  tokenType,
					Text:  text,
					Value: upper,
					Line:  lineNumber,
					Start: start,
					Stop:  position,
				})

			} else {

				tokens = append(tokens, Token{
					Type:  TokenVariable,
					Text:  text,
					Value: upper,
					Line:  lineNumber,
					Start: start,
					Stop:  position,
				})
			}

			continue
		}

		// ------------------------------------------------------------
		// Operators / punctuation
		// ------------------------------------------------------------

		tokenType, length := symbolAt(line, position)

		if tokenType != TokenInvalid {

			text := line[position : position+length]

			tokens = append(tokens, Token{
				Type:  tokenType,
				Text:  text,
				Value: text,
				Line:  lineNumber,
				Start: start,
				Stop:  position + length,
			})

			position += length
			continue
		}

		// ------------------------------------------------------------
		// Nothing recognized.
		//
		// This is critical: we NEVER silently skip a character.
		// ------------------------------------------------------------

		return nil, &LexerError{
			Message: "unexpected character",
			Line:    lineNumber,
			Column:  position,
			Text:    line[position : position+1],
		}
	}

	return tokens, nil
}


// ============================================================================
// Keywords
// ============================================================================

func keywordType(word string) (TokenType, bool) {
	switch word {

	case "PRINT":
		return TokenPrint, true
	case "LET":
		return TokenLet, true
	case "IF":
		return TokenIf, true
	case "THEN":
		return TokenThen, true
	case "ELSE":
		return TokenElse, true
	case "GOTO":
		return TokenGoto, true
	case "GOSUB":
		return TokenGosub, true
	case "RETURN":
		return TokenReturn, true
	case "FOR":
		return TokenFor, true
	case "TO":
		return TokenTo, true
	case "STEP":
		return TokenStep, true
	case "NEXT":
		return TokenNext, true
	case "INPUT":
		return TokenInput, true
	case "DIM":
		return TokenDim, true
	case "END":
		return TokenEnd, true
	case "STOP":
		return TokenStop, true
	case "RUN":
		return TokenRun, true
	case "LIST":
		return TokenList, true
	case "NEW":
		return TokenNew, true
	case "CLEAR":
		return TokenClear, true

	default:
		return TokenInvalid, false
	}
}


// ============================================================================
// Symbols
// ============================================================================

func symbolAt(
	line string,
	position int,
) (TokenType, int) {

	// Longest operators FIRST.
	//
	// Otherwise "<=" would become "<" followed by "=".
	if position+2 <= len(line) {

		switch line[position : position+2] {

		case "<>":
			return TokenLessGreater, 2

		case "<=":
			return TokenLessEqual, 2

		case ">=":
			return TokenGreaterEqual, 2
		}
	}

	if position >= len(line) {
		return TokenInvalid, 0
	}

	switch line[position] {

	case '=':
		return TokenEqual, 1

	case '<':
		return TokenLess, 1

	case '>':
		return TokenGreater, 1

	case '+':
		return TokenPlus, 1

	case '-':
		return TokenMinus, 1

	case '*':
		return TokenMultiply, 1

	case '/':
		return TokenDivide, 1

	case '(':
		return TokenLeftParen, 1

	case ')':
		return TokenRightParen, 1

	case ',':
		return TokenComma, 1

	case ';':
		return TokenSemicolon, 1

	default:
		return TokenInvalid, 0
	}
}


// ============================================================================
// Character helpers
// ============================================================================

func isDigit(c byte) bool {
	return c >= '0' && c <= '9'
}


func isIdentifierStart(c byte) bool {
	return (
		(c >= 'A' && c <= 'Z') ||
		(c >= 'a' && c <= 'z') ||
		c == '_'
	)
}


func isIdentifierPart(c byte) bool {
	return isIdentifierStart(c)
}


func hasWordAt(
	line string,
	position int,
	word string,
) bool {

	end := position + len(word)

	if end > len(line) {
		return false
	}

	if !strings.EqualFold(line[position:end], word) {
		return false
	}

	// REM must be a complete word.
	//
	// Thus:
	//
	//     REM       -> comment
	//     REMARK    -> variable
	//
	if end < len(line) && isIdentifierPart(line[end]) {
		return false
	}

	return true
}


// ============================================================================
// Example
// ============================================================================

func main() {

	program := `
10 PRINT "HELLO WORLD"
20 LET X = 1
30 PRINT "LOOP NUMBER " + X
40 LET X = X + 1
50 IF X < 4 THEN 30
60 PRINT "DONE!"
`

	lexer := NewLexer(program)

	tokens, err := lexer.Tokens()
	if err != nil {
		panic(err)
	}

	for _, token := range tokens {
		fmt.Println(token)
	}
}
