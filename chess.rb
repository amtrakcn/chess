require "./slidingModule"
require "./steppingModule"
require "colorize"

class Piece
  attr_reader :move_dirs, :color, :board, :piece_color, :unicode
  attr_accessor :position

  ICONS = {
      KI: "\u2654",
      Q: "\u2655",
      R: "\u2656",
      B: "\u2657",
      KN: "\u2658",
      P: "\u2659"
    }

  def initialize(color, board)
    @color = color
    @board = board
    @color == "B" ? @piece_color = :blue : @piece_color = :white
    # @unicode = ""
  end

  def find_piece(piece, board)
    board.board.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        return [idx1, idx2] if piece == board[idx1, idx2]
      end
    end
    return nil
  end
end

class SlidingPiece < Piece
  include SlidingModule
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
  include SteppingModule
end

class Knight < SteppingPiece
  def initialize(color, board)
    super(color, board)
    @move_dirs = [[1, 2], [1, -2], [-1, -2], [-1, 2], [2, 1], [-2, 1], [2, -1], [-2, -1]]
    @unicode = ICONS[:KN].colorize(@piece_color)
  end
end

class King < SteppingPiece
  def initialize(color, board)
    super(color, board)
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
    #if @moved = false, let move 2 positions
    pos2_piece = @board.board[pos2[0]][pos2[1]]
    if self.color == "B"
      if pos2[0] - self.find_piece(self, @board)[0] != @move_dirs_black1[0]
        return false
      end
      if pos2[1] - self.find_piece(self, @board)[1] != @move_dirs_black1[1]
        return false
      end
      if !@board[pos2[0] - 1, pos2[1]].nil? \
      || !@board[pos2[0], pos2[1]].nil?
        return false
      end

    elsif self.color == "W"
      if pos2[0] -  self.find_piece(self, @board)[0] != @move_dirs_white1[0]
        return false
      end
      if pos2[1] - self.find_piece(self, @board)[1] != @move_dirs_white1[1]
        return false
      end

      if !@board[pos2[0] + 1, pos2[1]].nil? \
      || !@board[pos2[0], pos2[1]].nil?
        return false
      end
    end

    valid
  end

  def valid_moves(pos2)
    if @moved == false
      value = first_valid_moves(pos2) || second_valid_moves(pos2)
    else
      value = second_valid_moves(pos2)
    end
  end

  def second_valid_moves(pos2)

    valid = true

    return true if attack(pos2)

    # if @moved == false
    #   value = first_valid_moves(pos2) || valid_moves(pos2)
    #   return value
    # end

    #if @moved = false, let move 2 positions
    pos2_piece = @board[pos2[0], pos2[1]]
    if self.color == "B"
      if pos2[0] - self.find_piece(self, @board)[0] != @move_dirs_black[0]
        return false
      end
      if pos2[1] - self.find_piece(self, @board)[1] != @move_dirs_black[1]
        return false
      end
    elsif self.color == "W"
      if pos2[0] - self.find_piece(self, @board)[0] != @move_dirs_white[0]
        return false
      end
      if pos2[1] - self.find_piece(self, @board)[1] != @move_dirs_white[1]
        return false
      end
    end

    unless @board[pos2[0], pos2[1]].nil?
      return false
    end
    @moved = true
    valid
  end

  def attack(pos2)
    movement = [pos2[0] - self.find_piece(self, @board)[0], pos2[1] - self.find_piece(self, @board)[1]]

    if valid_attack?(movement)
      return false if @board[pos2[0], pos2[1]].nil?
      return true if @board[pos2[0], pos2[1]].color != self.color
    end
    false
  end

  def valid_attack?(movement)
    if self.color == "W"
      if movement == [-1, 1] || movement == [-1, -1]
        return true
      end
    else
      if movement == [1, 1] || movement == [1, -1]
        return true
      end
    end

    false
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
    pos_king = find_king(color)

    check_spot(color, pos_king)
  end

  def check_spot(color, pos_king)
    enemy_pieces = []
    @board.each_with_index do |row, index1|
      row.each_with_index do |tile, index2|
        next if tile.nil?
        enemy_pieces << tile if tile.color != color
      end
    end

    until enemy_pieces == []
      enemy_piece = enemy_pieces.pop
      return false if enemy_piece.valid_moves(pos_king)
    end
    true
  end

  def find_king(color)
    @board.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        if King == tile.class && tile.color == color
          return [idx1, idx2]
        end
      end
    end
    return nil
  end


  def checkmate?(color)
    pos_king = find_king(color)

    ((-1)..1).each do |index1|
      ((-1)..1).each do |index2|
        trial_pos = [pos_king[0] + index1, pos_king[1] + index2]
        if trial_pos[0] >= 0 && trial_pos[0] <= 7 && trial_pos[1] >= 0 && trial_pos[1] <= 7
          return false if check_spot(color, trial_pos)
        end
      end
    end
    true
  end

  def [](x, y)
    @board[x][y]
  end

  def move(pos1, pos2)
    # if valid_move? && !check? #################################################
    piece = board[pos1[0]][pos1[1]]
    back_up_board = []

    @board.each_with_index do |row, index|
      back_up_board[index] = row.dup
    end

    if piece.valid_moves(pos2)
      @board[pos1[0]][pos1[1]], @board[pos2[0]][pos2[1]] = nil, @board[pos1[0]][pos1[1]]
      if piece.class == Pawn
        piece.moved = true
      end
    end

    color = back_up_board[pos1[0]][pos1[1]].color
    if !check?(color)
      @board = back_up_board
    end
  end
end

class Game

  def initialize
    game_result = false
    @gameboard = Board.new
    @player1 = Player.new("player1", "B")
    @player2 = Player.new("player2", "W")

  end

  def correct_color?(pos1, color)
    @gameboard.board[pos1[0]][pos1[1]].color == color
  end

  def play
    game_end = false
    @player1.show(@gameboard.board)
    until game_end
      begin
        input = @player1.user_input
        pos1 = [input[0][0], input[0][1]]
        pos2 = [input[1][0], input[1][1]]
      end until correct_color?(pos1, @player1.color)
      @gameboard.move(pos1, pos2)
      @player1.show(@gameboard.board)

      begin
        input = @player2.user_input
        pos1 = [input[0][0], input[0][1]]
        pos2 = [input[1][0], input[1][1]]
      end until correct_color?(pos1, @player2.color)
      @gameboard.move(pos1, pos2)
      @player2.show(@gameboard.board)

      game_end = @gameboard.checkmate?(@player1.color)
      p "#{game_end} game_end"
    end
  end

end

class Player
  attr_reader :color
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

    print "  0 1 2 3 4 5 6 7"
    print "\n"
    board.each_with_index do |row, index1|
      print "#{index1} "
      row.each_with_index do |piece, index2|
        if piece.nil?
          print "_"
        else
          print piece.unicode
        end
        print " "

      end
      print "\n"
    end
    print "\n"
  end

  def user_input
    move = []
    begin
      puts "Please input the origin: "
      origin = gets.chomp.split(",").map(&:to_i)
      puts "Please input the destination: "
      destination = gets.chomp.split(",").map(&:to_i)
    end until origin[0] >= 0 && origin[0] <= 7 && origin[1] >= 0 && origin[1] <= 7

    move << origin
    move << destination
  end
end

a = Game.new
a.play

# gameboard = Board.new
# a = Player.new("a", "B")
# a.show(gameboard.board)
# gameboard.move([1,0],[3,0])
# a.show(gameboard.board)
# gameboard.move([1,1], [3,1])
# a.show(gameboard.board)
# gameboard.move([2,0], [4,1])
# a.show(gameboard.board)
# gameboard.move([4,1], [6,2])
# a.show(gameboard.board)
# gameboard.move([3,3], [2,1])
# a.show(gameboard.board)
