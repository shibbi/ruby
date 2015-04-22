class SlidingPiece < Piece
  def moves
    straight_arr, diag_arr = straight_moves, diag_moves

    case move_dirs
    when 'horizontal'
      straight_arr
    when 'diagonal'
      diag_arr
    when 'both'
      diag_arr + straight_arr
    end
  end

  private
    def straight_moves
      get_moves(STRAIGHT_DIRS)
    end

    def diag_moves
      get_moves(DIAG_DIRS)
    end

    def get_moves(all_dirs)
      x, y = @pos
      [].tap do |moves|
        all_dirs.each do |off_x, off_y|
          new_pos = [off_x + x, off_y + y]
          attempt_move_result = attempt_move(new_pos)
          until attempt_move_result == 'invalid' || attempt_move_result == 'eat'
            moves << [new_pos[0], new_pos[1]]
            new_pos[0] += off_x
            new_pos[1] += off_y
            attempt_move_result = attempt_move(new_pos)
          end
          moves << new_pos if attempt_move_result == 'eat'
        end
      end
    end
end

class Rook < SlidingPiece
  def move_dirs
    'horizontal'
  end

  def symbol
    symbol_encode(color, "\u265C")
  end
end

class Bishop < SlidingPiece
  def move_dirs
    'diagonal'
  end

  def symbol
    symbol_encode(color, "\u265D")
  end
end

class Queen < SlidingPiece
  def move_dirs
    'both'
  end

  def symbol
    symbol_encode(color, "\u265B")
  end
end
