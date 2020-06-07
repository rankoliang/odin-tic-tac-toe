class Board
  attr_reader :board

  def initialize(board_size)
    self.board = Array.new(board_size,Array.new(board_size, 0))
  end

  def display
    self.board.each {|row| p row}
  end

  private

  attr_writer :board
end

Board.new(3).display