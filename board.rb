class Board
  attr_reader :grid_size, :num_bombs

  def initialize(grid_size, num_bombs)
    @grid_size, @num_bombs = grid_size, num_bombs

    generate_board
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def lost?
    @grid.flatten.any? { |tile| tile.bombed? && tile.explored? }
  end

  def render(reveal = false)
    system('clear')
    # debugger
    # reveal is used to fully reveal the board at game end
    @grid.each_index { |index| print "   #{index}" }
    print "\n"
    @grid.each_with_index do |row, index|
      row_string = "#{index}"
      row.each do |tile|
        char = reveal ? tile.reveal : tile.render
        row_string << "  " << char << " "
      end
      puts row_string
    end
    return nil
  end

  def reveal
    render(true)
  end

  def won?
    @grid.flatten.none? { |tile| tile.bombed? != tile.explored? }
  end

  private
  def generate_board
    @grid = Array.new(@grid_size) do |row|
      Array.new(@grid_size) { |col| Tile.new(self, [row, col]) }
    end

    plant_bombs
  end

  def plant_bombs
    total_bombs = 0
    while total_bombs < @num_bombs
      rand_pos = Array.new(2) { rand(@grid_size) }

      tile = self[rand_pos]
      next if tile.bombed?

      tile.plant_bomb
      total_bombs += 1
    end

    nil
  end
end
