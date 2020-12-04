import strutils
import sequtils
import sugar
import strformat

func slopeChecker(input: seq[string], deltaX: int, deltaY: int): int =
  # assume all rows are equal in length
  let rowLen = input[0].len

  var xCoord = 0
  var treeCount = 0

  for yCoord in countup(0, input.len - 1, deltaY):
    if input[yCoord][xCoord] == '#':
      treeCount += 1
    xCoord = (xCoord + deltaX) mod rowLen
  
  return treeCount

func partOne(input: seq[string]): int =
  return slopeChecker(input, 3, 1)

func partTwo(input: seq[string]): int =
  return slopeChecker(input, 1, 1) * slopeChecker(input, 3, 1) * slopeChecker(input, 5, 1) * slopeChecker(input, 7, 1) * slopeChecker(input, 1, 2)

let input = readFile("input.txt")
  .split("\n")
  .map(str => str.strip)

let partOneResult = partOne(input)
echo fmt"part one: {partOneResult}"

let partTwoResult = partTwo(input)
echo fmt"part two: {partTwoResult}"