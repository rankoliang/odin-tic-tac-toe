# frozen_string_literal: true

class ResultFound < StandardError
end

class WinnerFound < ResultFound
end

class GameTie < ResultFound
end

# Changes display functionality to use symbols instead of numbers
module DisplayMap
  @@DISPLAY_MAP = ['-', 'O', 'X']

  def display
    puts "  #{y_labels.join(' ')} x"
    board.each_with_index { |row, i| puts "#{i} #{row.map { |value| @@DISPLAY_MAP[value] }.join(' ')} |" }
    puts "y #{'-' * (2 * board.size)}"
  end

  private

  def y_labels
    Array(0...board.size)
  end
end

class Board
  attr_reader :board

  def initialize(board_size)
    self.board = []
    board_size.times { board.push(Array.new(board_size, 0)) }
  end

  # Displays the board
  def display
    puts "   #{y_labels.join('  ')}  x"
    board.each_with_index { |row, i| puts "#{i} #{row} |" }
    puts "y #{'-' * (3 * board.size + 1)}"
  end

  def to_s
    board.to_s
  end

  def size
    board.size
  end

  protected

  # returns the board diagonals
  def diagonals
    [board.map.with_index { |row, i| row[i] },
     board.map.with_index { |row, i| row[row.size - i - 1] }]
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

  # Takes input from the player until valid and returns the coordinates
  def take_turn(board, move: move)
    loop do
      print "#{self}'s turn. Input your move in the format x y: " unless move

      input = move ? move.join(' ') : gets.chomp

      if /^ *[0-#{board.size - 1}] *[0-#{board.size - 1}] *$/.match? input
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

  include DisplayMap

  def initialize(board_size = 3, num_players = 2)
    super(board_size)
    self.players = []
    num_players.times do |player_id|
      players.push Player.new(player_id + 1)
    end
  end

  # Starts the game loop
  def play
    winner = nil
    begin
      until winner
        players.each do |player|
          player.take_turn(self) do |x, y|
            update(x, y, player.id)
            display
            winning_id = check_winner
            if winning_id
              winner = winning_id
              raise WinnerFound
            end
            raise GameTie if board.flatten.none? { |element| element.nil? || element.zero? }
          end
        end
      end
    rescue WinnerFound
      puts "The winner is #{players[winner - 1]}"
    rescue GameTie
      puts 'The game is a tie'
    end
  end

  # Checks if the rows, columns, and diagonals are filled with the same element
  # and returns a winner if there is one
  def check_winner
    row_filled_with_same_element = ->(row) { row.reduce(row[0]) { |acc, elem| acc if elem == acc } }
    winners = [board, board.transpose, diagonals].map do |board_version|
      board_version.map(&row_filled_with_same_element).find { |row| row && row != 0 }
    end
    winners.find { |row| row }
  end

  def space_is_occupied?(x, y)
    board[y][x] != 0
  end

  def update(x, y, id)
    board[y][x] = id
  end

  protected

  attr_writer :players, :board
end

# game = TicTacToeGame.new
# game.display
# game.play
