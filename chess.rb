require "colored"
require "./slidingModule"
require "./steppingModule"
require "colorize"



class Piece
  attr_reader :move_dirs, :color, :board, :piece_color, :unicode
  attr_accessor :position

  ICONS = {
      Ki: "\u2654",
      Q: "\u2655",
      R: "\u2656",
      B: "\u2657",
      Kn: "\u2658",
      P: "\u2659"
    }

  def initialize(color, board)
    @color = color
    @board = board
    @color == "B" ? @piece_color = :black : @piece_color = :white
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
    


    @unicode = ICONS[:R].colorize(@piece_color)
  end
end

class Bishop < SlidingPiece
  def initialize(color, board)
    super(color, board)
    @move_dirs = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
    @unicode = ICONS[:B].colorize(@piece_color)
  end
end

class Queen < SlidingPiece
  def initialize(color, board)
    super(color, board)
    @move_dirs = [[0, 1], [0, -1], [1, 0], [-1, 0], 
              [1, 1], [1, -1], [-1, 1], [-1, -1]]
    @unicode = ICONS[:Q].colorize(@piece_color)
  end

end

##################


class SteppingPiece < Piece

end

class Knight < SteppingPiece
  def move_dirs(color)
    super(color)
    @move_dirs = [[1, 2], [1, -2], [-1, -2], [-1, 2], [2, 1], [-2, 1], [2, -1], [-2, -1]]
    @unicode = ICONS[:KN].colorize(@piece_color)
  end
end

class King < SteppingPiece
  def move_dirs(color)
    super(color)
    @move_dirs = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
    @unicode = ICONS[:KI].colorize(@piece_color)
  end
end

###############

class Pawn < Piece

  attr_accessor :moved
  def initialize(color, board)
    super(color, board)
    @moved = false
    @move_dirs_black = [1, 0]
    @move_dirs_white = [-1, 0]

    @move_dirs_black1 = [2, 0]
    @move_dirs_white1 = [-2, 0]

    @attack_dirs_black = [[-1,1], [1,1]]
    @attack_dirs_white = [[-1,-1], [1,-1]]

    @unicode = ICONS[:P].colorize(@piece_color)
  end

  def first_valid_moves(pos2)
    valid = true
    @moved = true
    #if @moved = false, let move 2 positions
    pos2_piece = @board.board[pos2[0]][pos2[1]]
    if self.color == "B"
      if pos2[0] - self.find_piece(self, @board)[0] != @move_dirs_black1[0]
        p "1f"
        return false
      end
      if pos2[1] - self.find_piece(self, @board)[1] != @move_dirs_black1[1]
        p "2f"
        return false
      end
      if @board.board[pos2[0] + 1][pos2[1]].nil? \
      || @board.board[pos2[0]][pos2[1]].nil?
      return false
      end

    elsif self.color == "W"
      p pos2[0]
      p self.find_piece(self, @board)[0]
      if pos2[0] -  self.find_piece(self, @board)[0] != @move_dirs_white1[0]
        p "3f"
        return false
      end
      if pos2[1] - self.find_piece(self, @board)[1] != @move_dirs_white1[1]
        p "4f"
        return false
      end
      if @board.board[pos2[0] - 1][pos2[1]].nil? \
      || @board.board[pos2[0]][pos2[1]].nil?
      return false
      end
    end

    valid
  end

  def valid_moves(pos2)
    valid = true

    if @moved == false
      value = first_valid_moves(pos2) || valid_moves(pos2)
      p value
    end

    #if @moved = false, let move 2 positions
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
      p pos2[0]
      p self.find_piece(self, @board)[0]
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
    @moved = true
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

  def [](x, y)
    @board[x][y]
  end

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

        print piece.unicode
        
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



gameboard = Board.new
a = Player.new("a", "B")
a.show(gameboard.board)
#gameboard.move([1,0],[5,5])
a.show(gameboard.board)
gameboard.move([6,1], [4,1])
a.show(gameboard.board)
