module PieceModule


  def valid_moves
    #iterate through moves, and call
  end

  def valid_move?(pos)
    #if position is in board, no piece in the way, false, then valid
    if 0 <= pos[0] && pos[0] <= 7 && pos[1] >= 0 && pos[1] <= 7
  end
end

class Piece
  attr_reader :move_dirs
  attr_accessor :position

  def initialize(color, board)
    @color = color
    @board = board
  end

  def find_piece(piece, board)
    board.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        return [idx1, idx2] if piece == board[idx1, idx2]
      end
    end
  end
end


class SlidingPiece < Piece

  def moves(steps)
    move_dirs.map do |pos|
      pos * steps
    end
  end
end

class Rook < SlidingPiece
  def initialize(color)
    super(color)
    @move_dirs = [[0, 1], [0, -1], [1, 0], [-1, 0]]
  end
end

class Bishop < SlidingPiece
  def initialize(color)
    super(color)
    @move_dirs = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
  end
end

class Queen < SlidingPiece
  def initialize(color)
    super(color)
    @move_dirs = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end

end

##################

class SteppingPiece < Piece

end

class Knight < SteppingPiece
  def move_dirs(color)
    super(color)
    @move_dirs = [[1, 2], [1, -2], [-1, -2], [-1, 2], [2, 1], [-2, 1], [2, -1], [-2, -1]]
  end
end

class King < SteppingPiece
  def move_dirs(color)
    super(color)
    @move_dirs = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end

###############

class Pawn < Piece
  def initialize(color)
    super(color)
    @move_dirs = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
  end
end



class Board

  def initialize
    @board = []
  end

  def create_board
    @board = Array.new(8) { Array.new(8) }
  end

  def check?(color)
  end

  def checkmate?(color)
  end

  def [](pos)
    @board[pos[0]][pos[1]]
  end

  def move(pos1, pos2)
    # if valid_move?
    @board[pos1], @board[pos2] = @board[pos2], @board[pos1]
  end
end

class Game

end

class Player
  def initialize(name)
    @name = name
  end

  def show(board)
    #prints board
  end

  def user_input

  end
end