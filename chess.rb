require "colored"
require "./slidingModule"
require "./steppingModule"



class Piece
  attr_reader :move_dirs, :color, :board
  attr_accessor :position

  def initialize(color, board)
    @color = color
    @board = board
  end

  def find_piece(piece, board)
    board.board.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        return [idx1, idx2] if piece == board.board[idx1][idx2]
      end
    end
    return nil
  end
end


class SlidingPiece < Piece
  include SlidingModule

  # def moves(steps)
  #   move_dirs.map do |pos|
  #     pos * steps
  #   end
  # end
end

class Rook < SlidingPiece
  def initialize(color, board)
    super(color, board)
    @move_dirs = [[0, 1], [0, -1], [1, 0], [-1, 0]]
  end
end

class Bishop < SlidingPiece
  def initialize(color, board)
    super(color, board)
    @move_dirs = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
  end
end

class Queen < SlidingPiece
  def initialize(color, board)
    super(color, board)
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
  def initialize(color, board, moved = false)
    super(color, board)
    @moved = true
    @move_dirs_black = [0, 1]
    @move_dirs_white = [0, -1]

    @attack_dirs_black = [[-1,1], [1,1]]
    @attack_dirs_white = [[-1,-1], [1,-1]]
  end

  def valid_moves(pos2)
    valid = true
    pos2_piece = @board.board[pos2[0]][pos2[1]]
    if self.color == "B"
      if pos2[0] - self.find_piece(self, @board)[0] != @move_dirs_black[0]
        p "1"
        return false
      end
      if pos2[1] - self.find_piece(self, @board)[1] != @move_dirs_black[1]
        p "2"
        return false
      end

    elsif self.color == "W"
      if pos2[0] - self.find_piece(self, @board)[0] != @move_dirs_white[0]
        p "3"
        return false
      end
      if pos2[1] - self.find_piece(self, @board)[1] != @move_dirs_white[1]
        p "4"
        return false
      end
    end

    unless @board.board[pos2[0]][pos2[1]].nil?
      return false
    end
    valid
  end

  def move
  end

  def attack
  end
end



class Board
  attr_accessor :board

  def initialize
    @board = []
    create_board
  end

  def create_board
    @board = Array.new(8) { Array.new(8) }

    @board[1].map! do |tile|
      tile = Pawn.new("B", self)
    end

    @board[6].map! do |tile|
      tile = Pawn.new("W", self)
    end

    @board[0][0] = Rook.new("B", self)
    @board[0][1] = Knight.new("B", self)
    @board[0][2] = Bishop.new("B", self)
    @board[0][3] = Queen.new("B", self)
    @board[0][4] = King.new("B", self)
    @board[0][5] = Bishop.new("B", self)
    @board[0][6] = Knight.new("B", self)
    @board[0][7] = Rook.new("B", self)

    @board[7][0] = Rook.new("W", self)
    @board[7][1] = Knight.new("W", self)
    @board[7][2] = Bishop.new("W", self)
    @board[7][3] = Queen.new("W", self)
    @board[7][4] = King.new("W", self)
    @board[7][5] = Bishop.new("W", self)
    @board[7][6] = Knight.new("W", self)
    @board[7][7] = Rook.new("W", self)
  end


  def check?(color)
  end

  def checkmate?(color)
  end

  # def [](x, y)
  #   @board[x][y]
  # end

  def move(pos1, pos2)
    # if valid_move? && !check?
    piece = board[pos1[0]][pos1[1]]

    if piece.valid_moves(pos2)
      @board[pos1[0]][pos1[1]], @board[pos2[0]][pos2[1]] = nil, @board[pos1[0]][pos1[1]]
    end
  end
end

class Game

  def initialize
    game_result = false
    gameboard = Board.new
    player1 = Player.new("player1")


  end

  def play
    until game_result
      player1.show(gameboard.board)
      game_result = true
    end
  end

end

class Player
  def initialize(name, color)
    @name = name
    @color = color
  end

  def show(board)
    syms = {
      WKi: "\u2654",
      WQ: "\u2655",
      WR: "\u2656",
      WB: "\u2657",
      WKn: "\u2658",
      WP: "\u2659",
      BKi: "\u265A",
      BQ: "\u265B",
      BR: "\u265C",
      BB: "\u265D",
      BKn: "\u265E",
      BP: "\u265F"
    }

    board.each do |row|
      row.each do |piece|

        case piece
        when nil
          print " "
        when King
          if piece.color == "B"
            print syms[:WKi].encode("UTF-8")
          else
            print syms[:BKi].encode("UTF-8")
          end
        when Queen
          if piece.color == "B"
            print syms[:WQ].encode("UTF-8")
          else
            print syms[:BQ].encode("UTF-8")
          end
        when Rook
          if piece.color == "B"
            print syms[:WR].encode("UTF-8")
          else
            print syms[:BR].encode("UTF-8")
          end
        when Bishop
          if piece.color == "B"
            print syms[:WB].encode("UTF-8")
          else
            print syms[:BB].encode("UTF-8")
          end
        when Knight
          if piece.color == "B"
            print syms[:WKn].encode("UTF-8")
          else
            print syms[:BKn].encode("UTF-8")
          end
        when Pawn
          if piece.color == "B"
            print syms[:WP].encode("UTF-8")
          else
            print syms[:BP].encode("UTF-8")
          end
        end
        print " "

      end
      print "\n"
    end
    print "\n"
  end

  def user_input
    puts "Please input the origin: "
    gets.chomp
    puts "Please input the destination: "
    gets.chomp

  end
end

#if $PROGRAM_NAME == __FILE__


gameboard = Board.new
a = Player.new("a", "B")
a.show(gameboard.board)
#gameboard.move([1,0],[5,5])
a.show(gameboard.board)
gameboard.move([1,1], [2,1])
a.show(gameboard.board)


  #end