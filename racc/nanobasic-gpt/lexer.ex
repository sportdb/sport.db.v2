defmodule NanoBasic.Lexer do
  defstruct source: ""

  @number ~r/^[0-9]+/
  @identifier ~r/^[A-Za-z_]+/
  @string ~r/^"[^"]*"/
  @symbol ~r/^(<>|<=|>=|=|<|>|\+|-|\*|\/|\(|\)|,)/

  @keywords %{
    "PRINT" => :print,
    "IF" => :if,
    "THEN" => :then,
    "LET" => :let,
    "GOTO" => :goto,
    "GOSUB" => :gosub,
    "RETURN" => :return
  }

  def new(source) do
    %__MODULE__{source: source}
  end

  def tokenize(%__MODULE__{source: source}) do
    source
    |> String.split("\n", trim: false)
    |> Enum.with_index(1)
    |> Enum.reduce_while([], fn {line, line_no}, acc ->
      case tokenize_line(line, line_no) do
        {:ok, tokens} ->
          {:cont, [Enum.reverse(tokens) | acc]}

        {:error, reason} ->
          {:halt, {:error, reason}}
      end
    end)
    |> finish_tokens()
  end

  defp finish_tokens({:error, reason}) do
    {:error, reason}
  end

  defp finish_tokens(lines) do
    tokens =
      lines
      |> Enum.reverse()
      |> List.flatten()

    {:ok, tokens}
  end

  defp tokenize_line(line, line_no) do
    scan(line, 0, line_no, [])
  end

  defp scan("", column, line_no, tokens) do
    {:ok,
     [
       {:eol, "\n", line_no, column + 1}
       | tokens
     ]}
  end

  defp scan(rest, column, line_no, tokens) do
    cond do
      whitespace?(rest) ->
        {_, rest} = String.split_at(rest, 1)
        scan(rest, column + 1, line_no, tokens)

      String.starts_with?(rest, "'") ->
        # Apostrophe comments consume the rest of the line.
        scan("", column + byte_size(rest), line_no, tokens)

      rem_comment?(rest) ->
        # REM comments consume the rest of the line.
        scan("", column + byte_size(rest), line_no, tokens)

      match = Regex.run(@string, rest) ->
        [text] = match

        token = {
          :string,
          String.slice(text, 1, String.length(text) - 2),
          line_no,
          column + 1
        }

        scan(
          binary_part(rest, byte_size(text), byte_size(rest) - byte_size(text)),
          column + byte_size(text),
          line_no,
          [token | tokens]
        )

      match = Regex.run(@number, rest) ->
        [text] = match

        token = {
          :number,
          String.to_integer(text),
          line_no,
          column + 1
        }

        scan(
          binary_part(rest, byte_size(text), byte_size(rest) - byte_size(text)),
          column + byte_size(text),
          line_no,
          [token | tokens]
        )

      match = Regex.run(@identifier, rest) ->
        [text] = match

        upper = String.upcase(text)

        kind =
          case Map.get(@keywords, upper) do
            nil -> :variable
            keyword -> keyword
          end

        token = {
          kind,
          upper,
          line_no,
          column + 1
        }

        scan(
          binary_part(rest, byte_size(text), byte_size(rest) - byte_size(text)),
          column + byte_size(text),
          line_no,
          [token | tokens]
        )

      match = Regex.run(@symbol, rest) ->
        [text] = match

        token = {
          :symbol,
          text,
          line_no,
          column + 1
        }

        scan(
          binary_part(rest, byte_size(text), byte_size(rest) - byte_size(text)),
          column + byte_size(text),
          line_no,
          [token | tokens]
        )

      true ->
        {:error,
         %{
           type: :unexpected_character,
           line: line_no,
           column: column + 1,
           character: String.first(rest)
         }}
    end
  end

  defp whitespace?(<<char, _rest::binary>>) do
    char == ?\s or char == ?\t
  end

  defp whitespace?(_) do
    false
  end

  defp rem_comment?(rest) do
    case String.slice(rest, 0, 3) do
      rem when rem in ["REM", "Rem", "rEM", "rem",
                       "ReM", "rEm", "REm", "reM"] ->
        case String.at(rest, 3) do
          nil -> true
          char -> not identifier_char?(char)
        end

      _ ->
        false
    end
  end

  defp identifier_char?(char) do
    char =~ ~r/[A-Za-z_]/
  end
end



-----------


source = """
10 LET X = 10
20 IF X >= 10 THEN PRINT "HELLO"
30 REM THIS IS A COMMENT
40 PRINT X + 1
"""

case NanoBasic.Lexer.tokenize(NanoBasic.Lexer.new(source)) do
  {:ok, tokens} ->
    Enum.each(tokens, &IO.inspect/1)

  {:error, error} ->
    IO.inspect(error)
end