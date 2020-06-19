# frozen_string_literal: true

require 'rspec'
require_relative '../main'

describe 'TicTacToeGame' do
  let(:game) { TicTacToeGame.new }
  describe ':check_winner' do
    [
      [[[0, 0], [0, 1], [1, 0], [1, 1], [2, 0]], 1],
      [[[2, 2], [1, 1], [0, 0], [2, 1], [1, 0], [2, 0], [0, 1], [0, 2]], 2],
      [[[1, 0], [0, 0], [2, 1], [1, 1], [0, 1], [2, 2]], 2],
      [[[0, 0], [1, 0], [0, 1], [1, 1], [0, 2]], 1],
      [[[2, 0], [1, 0], [2, 1], [1, 1], [2, 2]], 1]
    ].each do |moves, winner|
      context "moves by each player: #{moves.each_with_index.group_by { |_, i| i % 2 }.map { |k, v| [k, v.map { |move| move[0] }] }.to_h}" do
        it 'plays a game' do
          i = 0
          moves.each do |move|
            game.players[i].take_turn(game, move: move) do |x, y|
              game.update(x, y, game.players[i].id)
              break if game.check_winner
            end
            i = (i + 1) % 2
          end
          expect(game.check_winner).to eq winner
        end
      end
    end
  end
end
