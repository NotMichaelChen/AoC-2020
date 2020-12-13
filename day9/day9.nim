import strutils
import strformat
import sequtils
import sugar
import algorithm

func canSum(nums: seq[int], target: int): bool =
  var bottomIndex = 0
  var topIndex = nums.len - 1
  var currentSum = nums[bottomIndex] + nums[topIndex]

  while currentSum != target:
    if currentSum > target:
      topIndex -= 1
    else:
      bottomIndex += 1
    
    if topIndex == bottomIndex:
      return false

    currentSum = nums[bottomIndex] + nums[topIndex]

  return true


proc partOne(input: seq[string]): int =
  let numbers = input.map(str => str.parseInt)
  var slidingWindow = numbers[0..24].sorted

  for i in countup(25, numbers.len):
    if canSum(slidingWindow, numbers[i]):
      # look for and remove (i-25)th number
      slidingWindow.delete(slidingWindow.binarySearch(numbers[i-25]))
      # insert ith number
      slidingWindow.insert(numbers[i], slidingWindow.lowerBound(numbers[i]))
    else:
      return numbers[i]

  raise newException(Exception, "No invalid numbers found")

proc searchForRange(nums: seq[int], startingIndex: int, target: int): (bool, int) =
  var sum = nums[startingIndex]
  
  for i in countup(startingIndex+1, nums.len-1):
    sum += nums[i]
    if sum == target:
      let sortedRange = nums[startingIndex..i].sorted
      return (true, sortedRange[0] + sortedRange[sortedRange.len-1])
    elif sum > target:
      return (false, -1)
  
  return (false, -1)

proc partTwo(input: seq[string]): int =
  let numbers = input.map(str => str.parseInt)
  for i in countup(0, numbers.len-1):
    let (wasSuccess, resultNum) = numbers.searchForRange(i, 15353384)
    if wasSuccess:
      return resultNum
  
  raise newException(Exception, "No contiguous set of numbers found")

let input = readFile("input.txt").split("\p")

let partOneResult = partOne(input)
echo fmt"part one: {partOneResult}"

let partTwoResult = partTwo(input)
echo fmt"part two: {partTwoResult}"