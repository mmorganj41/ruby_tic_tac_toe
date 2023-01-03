class Player
    def initialize(symbol)
        @symbol = symbol
        @wins = 0
    end
end

class TicTacToe
    def initialize(size)
        @board = Array.new(size) {Array.new(size, ' ')}
        @turn = nil
        @players = Array.new
    end

    def add_player(player)
        @players.push(player)
    end

    def goes_first()
        @turn = @players.sample
    end

    def render_board()
        a_int = 'A'.ord
        first = true
        puts "    #{Array(a_int..a_int+@board.length-1).map(&:chr).join('   ')} "
        @board.each.with_index(1) do |row, i|
            puts "   #{(Array.new(row.length, '---').join('|'))}" unless first == true
            first = false if first == true
            puts " #{i}  #{row.join(' | ')} "
        end
    end
end