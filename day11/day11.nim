import sequtils
import strformat
import strutils
import sugar

proc coordinatesInRange(coordinates: tuple[row, column: int], dimensions: tuple[height, width: int]): bool =
  return coordinates.row >= 0 and
          coordinates.row < dimensions.height and
          coordinates.column >= 0 and
          coordinates.column < dimensions.width

proc adjacentOccupiedCount(grid: seq[seq[char]], coordinates: tuple[row, column: int], dimensions: tuple[height, width: int]): int =
  var count = 0

  for rowOffset in countup(-1, 1):
    for columnOffset in countup(-1, 1):
      if rowOffset == 0 and columnOffset == 0:
        continue

      let testCoordinates = (row: coordinates.row - rowOffset, column: coordinates.column - columnOffset)
      if coordinatesInRange(testCoordinates, dimensions) and
        grid[testCoordinates.row][testCoordinates.column] == '#':
          count += 1
  
  return count

proc stepGrid(grid: seq[seq[char]], dimensions: tuple[height, width: int]): (bool, seq[seq[char]]) =
  var nextGrid = newSeqWith(dimensions.height, newSeq[char](dimensions.width))
  var hasModified = false

  for rowIndex in countup(0, dimensions.height-1):
    for columnIndex in countup(0, dimensions.width-1):
      let seatState = grid[rowIndex][columnIndex]
      let occupiedSeats = adjacentOccupiedCount(grid, (rowIndex, columnIndex), dimensions)

      let newSeatState =
        if seatState == 'L' and occupiedSeats == 0:
          hasModified = true
          '#'
        elif seatState == '#' and occupiedSeats >= 4:
          hasModified = true
          'L'
        else:
          seatState
      
      nextGrid[rowIndex][columnIndex] = newSeatState
  
  return (hasModified, nextGrid)


proc partOne(input: seq[string]): int =
  doAssert(input.len > 0)

  let seatGrid = input.map(str => toSeq(str.items))
  let gridHeight = seatGrid.len
  # Assume all lines have the same length
  let gridWidth = seatGrid[0].len

  var currentGrid = seatGrid
  var hasModified = true
  while hasModified:
    (hasModified, currentGrid) = stepGrid(currentGrid, (gridHeight, gridWidth))

  var seatCount = 0
  for row in currentGrid:
    for seat in row:
      if seat == '#':
        seatCount += 1
  
  return seatCount

proc visibleOccupiedCount(grid: seq[seq[char]], coordinates: tuple[row, column: int], dimensions: tuple[height, width: int]): int =
  var count = 0

  for rowDelta in countup(-1, 1):
    for columnDelta in countup(-1, 1):
      if rowDelta == 0 and columnDelta == 0:
        continue
      
      var testCoordinates: tuple[row, column: int] = (coordinates.row + rowDelta, coordinates.column + columnDelta)
      while coordinatesInRange(testCoordinates, dimensions):
        let seat = grid[testCoordinates.row][testCoordinates.column]
        if seat == '#':
          count += 1
          break
        elif seat == 'L':
          break
        
        testCoordinates = (testCoordinates.row + rowDelta, testCoordinates.column + columnDelta)

  return count

proc stepGridPartTwo(grid: seq[seq[char]], dimensions: tuple[height, width: int]): (bool, seq[seq[char]]) =
  var nextGrid = newSeqWith(dimensions.height, newSeq[char](dimensions.width))
  var hasModified = false

  for rowIndex in countup(0, dimensions.height-1):
    for columnIndex in countup(0, dimensions.width-1):
      let seatState = grid[rowIndex][columnIndex]
      let occupiedSeats = visibleOccupiedCount(grid, (rowIndex, columnIndex), dimensions)

      let newSeatState =
        if seatState == 'L' and occupiedSeats == 0:
          hasModified = true
          '#'
        elif seatState == '#' and occupiedSeats >= 5:
          hasModified = true
          'L'
        else:
          seatState
      
      nextGrid[rowIndex][columnIndex] = newSeatState
  
  return (hasModified, nextGrid)

proc partTwo(input: seq[string]): int =
  doAssert(input.len > 0)

  let seatGrid = input.map(str => toSeq(str.items))
  let gridHeight = seatGrid.len
  # Assume all lines have the same length
  let gridWidth = seatGrid[0].len

  var currentGrid = seatGrid
  var hasModified = true
  while hasModified:
    (hasModified, currentGrid) = stepGridPartTwo(currentGrid, (gridHeight, gridWidth))

  var seatCount = 0
  for row in currentGrid:
    for seat in row:
      if seat == '#':
        seatCount += 1
  
  return seatCount

let input = readFile("input.txt").split("\p")

let partOneResult = partOne(input)
echo fmt"part one: {partOneResult}"

let partTwoResult = partTwo(input)
echo fmt"part two: {partTwoResult}"