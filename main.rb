# frozen_string_literal: true

class Board
  attr_reader :board

  def initialize(board_size)
    self.board = []
    board_size.times { board.push(Array.new(board_size, 0)) }
  end

  def display
    puts "   #{y_labels.join('  ')}  x"
    board.each_with_index { |row, i| puts "#{i} #{row} |" }
    puts "y #{'-' * (3 * board.size + 1)}"
  end

  def update_board(x, y, id)
    board[y][x] = id
  end

  def to_s
    board.to_s
  end

  def space_is_occupied?(x, y)
    board[y][x] != 0
  end

  def size
    board.size
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

  def take_turn(board)
    loop do
      print "#{self}'s turn. Input your move in the format x y: "
      input = gets.chomp
      if /^ *[0-#{board.size}] *[0-#{board.size}] *$/.match? input
        space = input.split.map(&:to_i)
        if !board.space_is_occupied?(*space)
          yield space
          break
        else
          puts 'Space is occupied!'
        end
      else
        puts 'Invalid input!'
      end
    end
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
        player.take_turn(self) do |x, y|
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
