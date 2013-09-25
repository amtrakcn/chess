module SteppingModule
  def valid_moves(pos2)
    #iterate through moves, and call
    pos1 = self.find_piece(self, @board)
    #if position is in board, no piece in the way,  then valid
    return false unless 0 <= pos2[0] && pos2[0] <= 7 && pos2[1] >= 0 && pos2[1] <= 7
    return false unless valid_dir?(pos2[0] - pos1[0], pos2[1] - pos1[1])
    return true
  end

  def valid_dir?(index1, index2)
    self.move_dirs.include?([index1, index2])
  end

end