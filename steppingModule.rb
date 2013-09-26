module SteppingModule
  def valid_moves(pos2)
    #iterate through moves, and call
    pos1 = self.find_piece(self, @board)
    #if position is in board, no piece in the way,  then valid
    return false unless 0 <= pos2[0] && pos2[0] <= 7 && pos2[1] >= 0 && pos2[1] <= 7
    return false unless valid_dir?(pos2[0] - pos1[0], pos2[1] - pos1[1])

    #if movement is not included in @move_dirs? false
    #if pos2.color == self  then false

    movement = [pos2[0] - self.find_piece(self, @board)[0], pos2[1] - self.find_piece(self, @board)[1]]

    if @move_dirs.include?(movement)
      if @board.board[pos2[0]][pos2[1]].nil? || self.color != @board.board[pos2[0]][pos2[1]].color
        return true
      end
    end
    return false
  end

  def valid_dir?(index1, index2)
    self.move_dirs.include?([index1, index2])
  end

end