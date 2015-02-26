class Pawn < Piece
  def moves
    x, y = @pos
    possible_moves = []
    if color == :black
      if x == 1
        new_x = x + 2
        possible_moves << [new_x, y] if attempt_move([new_x, y]) == 'empty'
      end
      PAWN_DIRS.each do |dir|
        new_pos = [x + dir[0], y + dir[1]]
        if attempt_move(new_pos) == 'empty' && !DIAG_DIRS.include?(dir) ||
           attempt_move(new_pos) == 'eat' && !STRAIGHT_DIRS.include?(dir)
          possible_moves << new_pos
        end
      end
    elsif color == :white
      if x == 6
        new_x = x - 2
        possible_moves << [new_x, y] if attempt_move([new_x, y]) == 'empty'
      end
      PAWN_DIRS.each do |dir|
        new_pos = [x - dir[0], y - dir[1]]
        if attempt_move(new_pos) == 'empty' && !DIAG_DIRS.include?(dir) ||
           attempt_move(new_pos) == 'eat' && !STRAIGHT_DIRS.include?(dir)
          possible_moves << new_pos
        end
      end
    end

    possible_moves
  end

  def symbol
    symbol_encode(color, "\u265F")
  end
end
