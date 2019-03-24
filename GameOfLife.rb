#***********************************************************************
#* GameOflife.rb
#*
#* Authors: Randy Nguyen and Sam Ventocilla
#* 
#* Source for creating 2D array:
#* https://stackoverflow.com/questions/12874965/creating-and-iterating-
#* a-2d-array-in-ruby
#* 
#* Source for iterating over 2D array:
#* https://stackoverflow.com/questions/2500196/iterating-over-two-
#* dimension-array-and-knowing-current-position
#* 
#* Source for single character input:
#* https://stackoverflow.com/questions/8072623/get-single-char-
#* from-console-immediately
#* 
#* Source for reading JSON:
#* https://stackoverflow.com/questions/5507512/how-to-write-to-a-json
#* -file-in-the-correct-format
#*
#* Source for writing JSON:
#* https://stackoverflow.com/questions/5507512/how-to-write-to-a-json-
#* file-in-the-correct-format
#**********************************************************************/

require 'io/console'
require 'json'

class GameOfLife 

  def initialize ()
    print "Enter Starter File: "
    fileName = gets.chomp
    file = File.open(fileName,"r")
    json = file.read
    parsed = JSON.parse(json)
    x = parsed["height"]
    y = parsed["width"]

    grid_text = parsed["board"]
    grid = get_grid(x, y)
    print "Beginning with grid size #{x}, #{y}.\n"
		
    for i in 0..x-1
      for j in 0..y-1
        grid[i][j] = grid_text[i][j].to_i
      end
    end	

    # Print initial game state
    print_grid(x, y, grid)

    while 1

      print "Press q to quit, w to save to disk,\n"
      print "n to iterate multple times, or any other\n"
      print "key to continue to the next generation.\n"
      print "---------------------------------------\n"

      case STDIN.getch
      when "q"
	# Case 'q' results in exiting the game.
	print "Quitting\n"
	return 0
      when "w"
	# Case 'w' writes the current board to disk as JSON
	print "Enter a filename: "
	writeFile = gets.chomp
	contents = {
          "height" => x,
	  "width" => y,
	  "board" => grid
	}
	File.open(writeFile, "w") do |file|
	  file.write(contents.to_json)
	end
      when "n"
        # 'n' causes us to ask the user how
	# many evolutions to perform in a row,
	# then executes them in a loop.
	print "How many iterations? "
	num = gets.to_i
	print "Iterating #{num} times.\n"
	for i in 1..num
	  grid = mutate(x, y, grid)
	  print_grid(x, y, grid)
	end
      else
 	# Any other key and we evolve one iteration,
	# print, and keep going.
	grid = mutate(x, y, grid)
	print_grid(x, y, grid)
      end
    end
  end

  #*********************************************************************
  #* get_grid creates a 2d array for a grid
  #* 
  #* @param x height of grid
  #* @param y width of grid
  #* @return grid starting memory address for a "grid" 
  #********************************************************************/
  def get_grid(x, y)
    grid = Array.new(x) {Array.new(y){0}}
  end

  #*********************************************************************
  #* print_grid attempts to print an x height
  #* by y width grid stored at the location
  #* provided by grid
  #*
  #* @param x height of grid
  #* @param y width of grid
  #* @param grid memory address for "grid"
  #********************************************************************/
  def print_grid(x, y, grid) 		
    print ("\n")
    # Iterate over 2D Array
    grid.each_with_index do |x, xi|
      x.each_with_index do |y, yi|
        if grid[xi][yi] == 0
	  print "0 "
	elsif grid[xi][yi] == 1
	  print "1 "
	else 
	  print "-1"
	end
      end

      # End of row carriage return
      print "\n"
    end

    # End of display carriage return
    print "\n"
  end
		
  #*********************************************************************
  #* mutate takes a grid and mutates that grid
  #* according to Conway's rules.  A new grid
  #* is returned.
  #*
  #* @param x height of grid
  #* @param y width of grid
  #* @param grid memory address of "grid"
  #* @return newGrid 2d array of mutated grid
  #********************************************************************/
  def mutate(x, y, grid)
		
    # Number of live neighbors
    neighbors = 0

    # Create a new grid
    newGrid = get_grid(x, y)

    # Count the number of live neighbors at every grid location
    # Update newGrid based on Conway rules
    grid.each_with_index do |a, ai|
      a.each_with_index do |b, bi|
	neighbors = get_neighbors(ai, bi, x, y, grid)
	if grid[ai][bi] == 1 
   	  if neighbors < 2 
	    newGrid[ai][bi] = 0
	  elsif neighbors > 3 
	    newGrid[ai][bi] = 0
	  else
	    newGrid[ai][bi] = 1
	end
	else
	  if neighbors == 3
	    newGrid[ai][bi] = 1
	  end
	end
      end
    end
    return newGrid
  end

  #*********************************************************************
  #* get_neighbors is a helper function that returns
  #* the number of live neighbors a cell has.
  #*
  #* @param i the selected height
  #* @param j the selected width
  #* @param x height of grid
  #* @param y width of grid
  #* @param grid memory address to "grid"
  #*
  #* @return neighbors number of live neighbors
  #********************************************************************/
  def get_neighbors(i, j, x, y, grid)
    return 0
  end

  #*********************************************************************
  #* onBoard is a helper function to check if a location is valid
  #*
  #* @param i the selected height
  #* @param j the selected width
  #* @param x height of grid
  #* @param y width of grid
  #*
  #* @return 0 not on board : 1 on board       
  #********************************************************************/
  def onBoard(i, j, x, y)
    return 1
  end


  #*********************************************************************
  #* get_neighbors is a helper function that returns
  #* the number of live neighbors a cell has.
  #*
  #* @param i the selected height
  #* @param j the selected width
  #* @param x height of grid
  #* @param y width of grid
  #* @param grid memory address to "grid"
  #*
  #* @return neighbors number of live neighbors
  #********************************************************************/  
  def get_neighbors(i, j, x, y, grid)

    # Variable to hold the number of alive neighbors.
    neighbors = 0

    # Go through each possible direction.
    # If it does not move, do not increment neighbors
    adjacent1 = [-1, 0, 1]
    adjacent2 = [-1, 0, 1]

    adjacent1.each do |a|
      adjacent2.each do |b|
    if a != 0 ||  b != 0
          valid = onBoard( i+a, j+b, x, y)
      if valid == 1
        if grid[i+a][j+b] == 1
          neighbors += 1
        end
      end
    end
      end
    end
    return neighbors
  end

  #*********************************************************************
  #* onBoard is a helper function to check if a location is valid
  #*
  #* @param i the selected height
  #* @param j the selected width
  #* @param x height of grid
  #* @param y width of grid
  #*
  #* @return 0 not on board : 1 on board
  #********************************************************************/
  def onBoard(i, j, x, y)
    if i < 0 || j < 0 || i >= x || j >= y
      return 0
    else
      return 1
    end
  end




end

g = GameOfLife.new()
