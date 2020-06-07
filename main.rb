# frozen_string_literal: true

class Board
  attr_reader :board

  def initialize(board_size)
    self.board = Array.new(board_size, Array.new(board_size, 0))
  end

  def display
    board.each { |row| p row }
  end

  private

  attr_writer :board
end

class Player
  attr_reader :name, :symbol

  def initialize(name, symbol)
    self.name = name
    self.symbol = symbol
  end

  private

  attr_writer :name, :symbol
end

Board.new(3).display
