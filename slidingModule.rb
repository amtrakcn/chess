module SlidingModule


  def valid_moves(pos2)
    #iterate through moves, and call
    pos1 = self.find_piece(self, @board)
    clear_path = true
    #if position is in board, no piece in the way,  then valid
    clear_path = false unless 0 <= pos2[0] && pos2[0] <= 7 && pos2[1] >= 0 && pos2[1] <= 7
    #p pos1
    direction = []

    if pos2[0] == pos1[0]
      direction[0] = 0
      direction[1] = (pos2[1] - pos1[1]) / (pos2[1] - pos1[1]).abs
    elsif pos2[1] == pos1[1]
      direction[1] = 0
      direction[0] = (pos2[0] - pos1[0]) / (pos2[0] - pos1[0]).abs
     else
       direction[1] = (pos2[1] - pos1[1]) / (pos2[1] - pos1[1]).abs
       direction[0] = (pos2[0] - pos1[0]) / (pos2[0] - pos1[0]).abs
    end

    clear_path = false unless valid_dir?(direction[0], direction[1])

    until (pos1[0] == (pos2[0] - direction[0])) && (pos1[1] == (pos2[1] - direction[1]))
      pos1[0] += direction[0]
      pos1[1] += direction[1]
      clear_path = false if !valid_move?(pos1[0], pos1[1])
    end

    if clear_path
      if (!@board.board[pos2[0]][pos2[1]].nil?) \
        && (@board.board[pos2[0]][pos2[1]].color == self.color)
        clear_path = false
      end
    end

    return clear_path

  end

  def valid_move?(index1, index2)
    @board.board[index1][index2].nil?

  end

  def valid_dir?(index1, index2)
    self.move_dirs.include?([index1, index2])
  end

end