import strutils
import sequtils
import sugar
import algorithm
import strformat
import itertools

func partOne(nums: seq[int]): int =
  var bottomIndex = 0
  var topIndex = nums.len - 1
  var currentSum = nums[bottomIndex] + nums[topIndex]

  while currentSum != 2020:
    if currentSum > 2020:
      topIndex -= 1
    else:
      bottomIndex += 1
    currentSum = nums[bottomIndex] + nums[topIndex]
  
  return nums[bottomIndex] * nums[topIndex]

func partTwo(nums: seq[int]): int =
  for triplets in combinations(nums.len-1, 3):
    let sum = nums[triplets[0]] + nums[triplets[1]] + nums[triplets[2]]
    if sum == 2020:
      return nums[triplets[0]] * nums[triplets[1]] * nums[triplets[2]]

  raise newException(Exception, "No combination of triplets added up to 2020")

let input = readFile("input.txt")
  .split("\n")
  .map(str => str.strip.parseInt)
  .sorted()

let partOneResult = partOne(input)
echo fmt"part one: {partOneResult}"

let partTwoResult = partTwo(input)
echo fmt"part two: {partTwoResult}"