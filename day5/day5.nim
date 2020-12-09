import strutils
import sequtils
import sugar
import strformat
import algorithm

func partOne(input: seq[string]): int =
  return input
    .map(proc(seatCode: string): int =
      let rowNum = cast[string](
          seatCode
            .substr(0, 6)
            .map(c => (if c == 'B': '1' else: '0'))
        )
        .fromBin[:int]()
      
      let columnNum = cast[string](
        seatCode
          .substr(7)
          .map(c => (if c == 'R': '1' else: '0'))
      )
      .fromBin[:int]()

      return rowNum * 8 + columnNum
    )
    .max

proc partTwo(input: seq[string]): int =
  let sortedIds = input
    .map(proc(seatCode: string): int =
      let rowNum = cast[string](
          seatCode
            .substr(0, 6)
            .map(c => (if c == 'B': '1' else: '0'))
        )
        .fromBin[:int]()
      
      let columnNum = cast[string](
        seatCode
          .substr(7)
          .map(c => (if c == 'R': '1' else: '0'))
      )
      .fromBin[:int]()

      return rowNum * 8 + columnNum
    )
    .sorted
  
  for i in countup(1, sortedIds.len - 2):
    if sortedIds[i] - sortedIds[i-1] != 1:
      return sortedIds[i]-1
  raise newException(Exception, "no valid id found")

let input = readFile("input.txt")
  .split("\p")
  .map(str => str.strip)

let partOneResult = partOne(input)
echo fmt"part one: {partOneResult}"

let partTwoResult = partTwo(input)
echo fmt"part two: {partTwoResult}"