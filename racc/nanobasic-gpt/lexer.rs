use regex::Regex;
use std::collections::HashMap;

#[derive(Debug, Clone, PartialEq)]
pub enum TokenKind {
    Number,
    String,
    Variable,

    Print,
    If,
    Then,
    Let,
    Goto,
    Gosub,
    Return,

    Symbol(String),
    Eol,
}

#[derive(Debug, Clone, PartialEq)]
pub struct Token {
    pub kind: TokenKind,
    pub text: String,
    pub line: usize,
    pub column: usize,
}

#[derive(Debug)]
pub struct LexerError {
    pub line: usize,
    pub column: usize,
    pub character: char,
}

impl std::fmt::Display for LexerError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "unexpected character {:?} at line {}, column {}",
            self.character,
            self.line,
            self.column
        )
    }
}

impl std::error::Error for LexerError {}

pub struct Lexer {
    number_re: Regex,
    identifier_re: Regex,
    string_re: Regex,
    symbol_re: Regex,

    keywords: HashMap<&'static str, TokenKind>,
}

impl Lexer {
    pub fn new() -> Self {
        let mut keywords = HashMap::new();

        keywords.insert("PRINT", TokenKind::Print);
        keywords.insert("IF", TokenKind::If);
        keywords.insert("THEN", TokenKind::Then);
        keywords.insert("LET", TokenKind::Let);
        keywords.insert("GOTO", TokenKind::Goto);
        keywords.insert("GOSUB", TokenKind::Gosub);
        keywords.insert("RETURN", TokenKind::Return);

        Self {
            number_re: Regex::new(r"^[0-9]+").unwrap(),
            identifier_re: Regex::new(r"^[A-Za-z_]+").unwrap(),
            string_re: Regex::new(r#"^"[^"]*""#).unwrap(),

            // Longest operators first.
            symbol_re: Regex::new(
                r"^(<>|<=|>=|=|<|>|\+|-|\*|/|\(|\)|,)"
            )
            .unwrap(),

            keywords,
        }
    }

    pub fn tokenize(&self, source: &str) -> Result<Vec<Token>, LexerError> {
        let mut tokens = Vec::new();

        for (line_index, line) in source.lines().enumerate() {
            let line_number = line_index + 1;
            let mut pos = 0;

            while pos < line.len() {
                let rest = &line[pos..];

                // Whitespace.
                if let Some(ch) = rest.chars().next() {
                    if ch == ' ' || ch == '\t' {
                        pos += ch.len_utf8();
                        continue;
                    }
                }

                // Apostrophe comment.
                if rest.starts_with('\'') {
                    break;
                }

                // REM comment.
                if self.is_rem(rest) {
                    break;
                }

                // String.
                if let Some(m) = self.string_re.find(rest) {
                    let text = m.as_str();

                    tokens.push(Token {
                        kind: TokenKind::String,
                        text: text.to_owned(),
                        line: line_number,
                        column: pos + 1,
                    });

                    pos += text.len();
                    continue;
                }

                // Number.
                if let Some(m) = self.number_re.find(rest) {
                    let text = m.as_str();

                    tokens.push(Token {
                        kind: TokenKind::Number,
                        text: text.to_owned(),
                        line: line_number,
                        column: pos + 1,
                    });

                    pos += text.len();
                    continue;
                }

                // Identifier or keyword.
                if let Some(m) = self.identifier_re.find(rest) {
                    let text = m.as_str();
                    let upper = text.to_ascii_uppercase();

                    let kind = match self.keywords.get(upper.as_str()) {
                        Some(kind) => kind.clone(),
                        None => TokenKind::Variable,
                    };

                    tokens.push(Token {
                        kind,
                        text: text.to_owned(),
                        line: line_number,
                        column: pos + 1,
                    });

                    pos += text.len();
                    continue;
                }

                // Operator / punctuation.
                if let Some(m) = self.symbol_re.find(rest) {
                    let text = m.as_str();

                    tokens.push(Token {
                        kind: TokenKind::Symbol(text.to_owned()),
                        text: text.to_owned(),
                        line: line_number,
                        column: pos + 1,
                    });

                    pos += text.len();
                    continue;
                }

                // Nothing matched.
                let ch = rest.chars().next().unwrap();

                return Err(LexerError {
                    line: line_number,
                    column: pos + 1,
                    character: ch,
                });
            }

            tokens.push(Token {
                kind: TokenKind::Eol,
                text: "\n".to_owned(),
                line: line_number,
                column: line.len() + 1,
            });
        }

        Ok(tokens)
    }

    fn is_rem(&self, text: &str) -> bool {
        if text.len() < 3 {
            return false;
        }

        if !text[..3].eq_ignore_ascii_case("REM") {
            return false;
        }

        match text.as_bytes().get(3) {
            None => true,
            Some(b) if !is_identifier_char(*b as char) => true,
            _ => false,
        }
    }
}

fn is_identifier_char(ch: char) -> bool {
    ch.is_ascii_alphabetic() || ch == '_'
}