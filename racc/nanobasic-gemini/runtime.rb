# runtime.rb

class NanoBasicRuntime
  def initialize(ast)
    @variables = {}
    @program = {}
    ast.each do |line_node|
      next if line_node.nil?
      @program[line_node[:line_num]] = line_node[:stmt]
    end
    @sorted_lines = @program.keys.sort
    @current_line_idx = 0
  end

  def run
    while @current_line_idx < @sorted_lines.length
      current_line_num = @sorted_lines[@current_line_idx]
      statement = @program[current_line_num]

      next_line_idx = @current_line_idx + 1

      case statement[:type]
      when :let
        @variables[statement[:var]] = evaluate_expr(statement[:val])
      when :print
        puts evaluate_expr(statement[:val])
      when :goto
        next_line_idx = find_line_index!(statement[:target])
      when :if
        if evaluate_expr(statement[:condition]) != 0
          next_line_idx = find_line_index!(statement[:target])
        end
      end

      @current_line_idx = next_line_idx
    end
  end

  private

  def evaluate_expr(node)
    return node if node.is_a?(Integer)
    return node if node.is_a?(String) # Base case: String values are evaluated instantly

    case node[:type]
    when :variable
      @variables[node[:name]] || 0
    when :add
      left_val  = evaluate_expr(node[:left])
      right_val = evaluate_expr(node[:right])

      # Handle basic string concatenation or standard math integration
      if left_val.is_a?(String) || right_val.is_a?(String)
        left_val.to_s + right_val.to_s
      else
        left_val + right_val
      end
    when :sub
      evaluate_expr(node[:left]) - evaluate_expr(node[:right])
    when :lt
      evaluate_expr(node[:left]) < evaluate_expr(node[:right]) ? 1 : 0
    when :gt
      evaluate_expr(node[:left]) > evaluate_expr(node[:right]) ? 1 : 0
    when :eq_comp
      evaluate_expr(node[:left]) == evaluate_expr(node[:right]) ? 1 : 0
    else
      raise "Runtime Error: Unknown expression type: #{node[:type]}"
    end
  end

  def find_line_index!(line_number)
    idx = @sorted_lines.index(line_number)
    raise "Runtime Error: Line number #{line_number} not found!" if idx.nil?
    idx
  end
end
