class SteppingPiece < Piece
  def get_moves(all_dirs)
    [].tap do |possible_moves|
      all_dirs.each do |direction|
        new_pos = [@pos[0] + direction[0], @pos[1] + direction[1]]
        if attempt_move(new_pos) == 'empty' || attempt_move(new_pos) == 'eat'
          possible_moves << new_pos
        end
      end
    end
  end
end

class Knight < SteppingPiece
  def moves
    get_moves(KNIGHT_DIRS)
  end

  def symbol
    symbol_encode(color, "\u265E")
  end
end

class King < SteppingPiece
  def moves
    get_moves(STRAIGHT_DIRS + DIAG_DIRS)
  end

  def symbol
    symbol_encode(color, "\u265A")
  end
end
