import strutils
import strformat
import sequtils
import sugar
import tables
import algorithm

proc partOne(input: seq[string]): int =
  let sortedInput = input.map(str => str.parseInt).sorted
  let chain = 0 & sortedInput & sortedInput[sortedInput.len-1] + 3

  var diffOneCount = 0
  var diffThreeCount = 0
  for i in countup(1, chain.len-1):
    let diff = chain[i] - chain[i-1]
    if diff == 3:
      diffThreeCount += 1
    elif diff == 1:
      diffOneCount += 1
  
  return diffOneCount * diffThreeCount

proc partTwo(input: seq[string]): int =
  var memoizedResults: Table[int, int] # index -> result

  let sortedInput = input.map(str => str.parseInt).sorted()
  let chain = 0 & sortedInput & sortedInput[sortedInput.len-1] + 3

  func computePermutations(input: seq[int], index: int): int =
    if index == input.len-1:
      return 1

    var numOfPermutations = 0

    for i in countup(index+1, input.len-1):
      if input[i] - input[index] <= 3:
        if not (i in memoizedResults):
          memoizedResults[i] = computePermutations(input, i)

        numOfPermutations += memoizedResults[i]
      else:
        break
    
    return numOfPermutations

  return computePermutations(chain, 0)

let input = readFile("input.txt").split("\p")

let partOneResult = partOne(input)
echo fmt"part one: {partOneResult}"

let partTwoResult = partTwo(input)
echo fmt"part two: {partTwoResult}"