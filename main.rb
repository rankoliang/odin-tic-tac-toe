# frozen_string_literal: true

class Board
  attr_reader :board

  def initialize(board_size)
    self.board = []
    board_size.times { board.push(Array.new(board_size, 0)) }
  end

  def display
    puts "   #{y_labels.join('  ')}  y"
    board.each_with_index { |row, i| puts "#{i} #{row} |" }
    puts 'x -----------'
  end

  def update_board(x, y, id)
    board[x][y] = id
  end

  def to_s
    board.to_s
  end

  private

  attr_writer :board

  def y_labels
    Array(0...board.size)
  end
end

class Player
  attr_reader :name, :id

  def initialize(id, name = "Player #{id}")
    self.id = id
    self.name = name
  end

  def to_s
    name
  end

  def take_turn
    print "#{self}'s turn. Input your move in the format x y: "
    yield gets.chomp.split.map(&:to_i)
  end

  protected

  attr_writer :name, :id
end

class TicTacToeGame < Board
  attr_reader :players

  def initialize(board_size = 3, num_players = 2)
    super(board_size)
    self.players = []
    num_players.times do |player_id|
      players.push Player.new(player_id + 1)
    end
  end

  def play
    winner = nil
    until winner
      players.each do |player|
        player.take_turn do |x, y|
          update_board(x, y, player.id)
          display
        end
      end
    end
  end

  protected

  attr_writer :players, :board
end

game = TicTacToeGame.new
game.display
game.play
