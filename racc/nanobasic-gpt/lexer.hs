
module NanoBasic.Lexer
  ( Token(..)
  , TokenKind(..)
  , LexerError(..)
  , tokenize
  ) where

import Data.Char (isAlpha, isAlphaNum, isDigit, toUpper)
import Data.List (isPrefixOf)


-- | What kind of token did we find?
data TokenKind
    = Number
    | StringLiteral
    | Variable

    | Print
    | If
    | Then
    | Let
    | Goto
    | Gosub
    | Return

    | Symbol String
    | Eol
    deriving (Eq, Show)


-- | A token with its original spelling and source location.
data Token = Token
    { tokenKind   :: TokenKind
    , tokenText   :: String
    , tokenLine   :: Int
    , tokenColumn :: Int
    }
    deriving (Eq, Show)


-- | Something went wrong while lexing.
data LexerError
    = UnexpectedCharacter
        { errorLine   :: Int
        , errorColumn :: Int
        , errorChar   :: Char
        }
    | UnterminatedString
        { errorLine   :: Int
        , errorColumn :: Int
        }
    deriving (Eq, Show)


-- | Entry point.
tokenize :: String -> Either LexerError [Token]
tokenize source =
    tokenizeLines 1 (linesPreservingFinal source)


-- Keep the final empty line semantics under our control.
linesPreservingFinal :: String -> [String]
linesPreservingFinal "" = []
linesPreservingFinal source =
    case break (== '\n') source of
        (line, []) ->
            [stripCR line]

        (line, _ : rest) ->
            stripCR line : linesPreservingFinal rest


stripCR :: String -> String
stripCR line =
    case reverse line of
        '\r' : rest -> reverse rest
        _           -> line


tokenizeLines :: Int -> [String] -> Either LexerError [Token]
tokenizeLines _ [] =
    Right []

tokenizeLines lineNo (line : rest) = do
    tokens <- tokenizeLine lineNo line

    remaining <- tokenizeLines (lineNo + 1) rest

    pure (tokens ++ remaining)


tokenizeLine :: Int -> String -> Either LexerError [Token]
tokenizeLine lineNo line = do
    tokens <- scan lineNo 1 line

    pure $
        tokens ++
        [Token
            { tokenKind   = Eol
            , tokenText   = "\n"
            , tokenLine   = lineNo
            , tokenColumn = length line + 1
            }
        ]


scan :: Int -> Int -> String -> Either LexerError [Token]
scan _ _ [] =
    Right []

scan lineNo column input@(c : rest)

    -- Whitespace
    | c == ' ' || c == '\t' =
        scan lineNo (column + 1) rest

    -- Apostrophe comment
    | c == '\'' =
        Right []

    -- REM comment
    | isRemComment input =
        Right []

    -- String
    | c == '"' =
        scanString lineNo column input

    -- Number
    | isDigit c =
        let (digits, remaining) = span isDigit input
            token =
                Token
                    { tokenKind   = Number
                    , tokenText   = digits
                    , tokenLine   = lineNo
                    , tokenColumn = column
                    }
        in
            (token :) <$>
                scan lineNo (column + length digits) remaining

    -- Identifier / keyword
    | isIdentifierStart c =
        let (name, remaining) = span isIdentifierChar input
            upperName = map toUpper name

            kind =
                case keyword upperName of
                    Just k  -> k
                    Nothing -> Variable

            token =
                Token
                    { tokenKind   = kind
                    , tokenText   = name
                    , tokenLine   = lineNo
                    , tokenColumn = column
                    }
        in
            (token :) <$>
                scan lineNo (column + length name) remaining

    -- Operators / punctuation
    | otherwise =
        case symbol input of
            Just op ->
                let token =
                        Token
                            { tokenKind   = Symbol op
                            , tokenText   = op
                            , tokenLine   = lineNo
                            , tokenColumn = column
                            }
                in
                    (token :) <$>
                        scan lineNo (column + length op)
                            (drop (length op) input)

            Nothing ->
                Left UnexpectedCharacter
                    { errorLine   = lineNo
                    , errorColumn = column
                    , errorChar   = c
                    }


scanString :: Int -> Int -> String -> Either LexerError [Token]
scanString lineNo column input =
    case span (/= '"') (tail input) of
        (_, []) ->
            Left UnterminatedString
                { errorLine   = lineNo
                , errorColumn = column
                }

        (contents, '"' : rest) ->
            let text = '"' : contents ++ "\""

                token =
                    Token
                        { tokenKind   = StringLiteral
                        , tokenText   = text
                        , tokenLine   = lineNo
                        , tokenColumn = column
                        }
            in
                (token :) <$>
                    scan lineNo (column + length text) rest


isIdentifierStart :: Char -> Bool
isIdentifierStart c =
    isAlpha c || c == '_'


isIdentifierChar :: Char -> Bool
isIdentifierChar c =
    isAlpha c || c == '_'


keyword :: String -> Maybe TokenKind
keyword name =
    case name of
        "PRINT"  -> Just Print
        "IF"     -> Just If
        "THEN"   -> Just Then
        "LET"    -> Just Let
        "GOTO"   -> Just Goto
        "GOSUB"  -> Just Gosub
        "RETURN" -> Just Return
        _        -> Nothing


isRemComment :: String -> Bool
isRemComment input =
    "REM" `isPrefixOf` upper &&
    boundary
  where
    upper = map toUpper input

    boundary =
        case drop 3 input of
            []    -> True
            c : _ -> not (isIdentifierChar c)


symbol :: String -> Maybe String
symbol input =
    firstMatch
        [ "<>"
        , "<="
        , ">="
        , "="
        , "<"
        , ">"
        , "+"
        , "-"
        , "*"
        , "/"
        , "("
        , ")"
        , ","
        ]
  where
    firstMatch [] = Nothing
    firstMatch (x : xs)
        | x `isPrefixOf` input = Just x
        | otherwise            = firstMatch xs


---

module Main where

import NanoBasic.Lexer


main :: IO ()
main = do
    let source =
            "10 LET X = 10\n" ++
            "20 IF X >= 10 THEN PRINT \"HELLO\"\n" ++
            "30 REM THIS IS A COMMENT\n" ++
            "40 PRINT X + 1\n"

    case tokenize source of
        Left err ->
            print err

        Right tokens ->
            mapM_ print tokens