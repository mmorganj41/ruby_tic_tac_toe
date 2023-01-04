class Player
  attr_reader :symbol
  attr_accessor :wins
  def initialize(symbol)
    @symbol = symbol
    @wins = 0
  end
end

class TicTacToe
  def initialize(size)
    @squares = size**2
    @board = Array.new(size) {Array.new(size, ' ')}
    @turn = nil
    @players = Array.new
    @moves = 0
    @draws = 0
  end
  
  def new_board()
    @board = Array.new(@board.length) {Array.new(@board.length, ' ')}
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
    @board.each.with_index do |row, i|
      puts "   #{(Array.new(row.length, '---').join('|'))}" unless first == true
      first = false if first == true
      puts " #{i}  #{row.join(' | ')} "
    end
    puts "\n"
  end

  def next_player()
    player_index = @players.find_index(@turn) + 1
    @turn = (player_index == @players.length) ? @players[0] : @players[player_index] 
  end

  def player_move(row, col)
    if @board[row][col] == ' '
      @board[row][col] = @turn.symbol
      return true
    else
      return false
    end
  end

  def check_row?()
    @board.each do |row|
      return true if row.all? {|square| square == @turn.symbol}
    end
    false
  end

  def check_col?()
    (0...@board.length).each do |col|
        return true if @board.all? {|row| row[col] == @turn.symbol}
    end
    false
  end
  
  def check_diag?()
    return true if @board.each_with_index.all? {|row, col| row[col] == @turn.symbol} 
    return true if @board.each_with_index.all? {|row, col| row[@board.length-1-col] == @turn.symbol}
    false
  end

  def game_over?()
    return true if check_diag?()
    return true if check_row?()
    return true if check_col?()
    false
  end

  def one_turn()
    moved = false
    until moved
      puts "Player #{@turn.symbol}, choose a square to move (EX: A1): "
      square = gets.chomp
      puts "\n"
      unless /[a-z][\d*]/i.match?(square)
        puts "Incorrect Formatting, try again!"
        next
      end
      row = /[\d*]/.match(square)[0].to_i
      col = square[0].upcase.ord-'A'.ord
      unless row < @board.length and col < @board.length
        puts "Nonexistant square."
        next
      end
      unless player_move(row, col) 
        puts "Square occupied."
        next
      end
      moved = true
      @moves += 1
      if game_over?()
        return true
      else
        next_player() 
        return false
      end
    end
  end

  def play()
    goes_first()
    game_over = false
    render_board()
    until game_over or @moves >= @squares
      game_over = one_turn()
      render_board()
    end
    if game_over
      puts "Player #{@turn.symbol} won."
      @turn.wins += 1
    else
      puts "Cat's game."
      @draws += 1
    end
  end

  def game_loop()
    loop do
      play()
      puts "\n"
      print "Stats: "
      @players.each do |player| 
        print "#{player.symbol} Wins-#{player.wins} "
      end
      print "Draws- #{@draws}\n"

      puts "Type anything to play again (q to quit)?"
      play_again = gets.chomp
      break if play_again == 'q'
      new_board()
      @moves = 0
    end
  end
end

tic_tac_toe = TicTacToe.new(3)
player_x = Player.new('X')
player_o = Player.new('O')
tic_tac_toe.add_player(player_x)
tic_tac_toe.add_player(player_o)
tic_tac_toe.game_loop