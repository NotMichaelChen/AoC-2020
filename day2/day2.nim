import strutils
import sequtils
import sugar
import strformat

func partOne(input: seq[string]): int =
  var validPasswords = 0
  for line in input:
    let lineParts = line.split(" ")
    doAssert(lineParts.len == 3, fmt"line in input does not have three parts: {line}")

    let bounds = lineParts[0].split("-").map(str => str.parseInt)
    doAssert(bounds.len == 2, fmt"character count bounds are not formatted correctly: {lineParts[0]}")

    doAssert(lineParts[1].len == 2, fmt"test char is not formatted correctly: {lineParts[1]}")
    let testChar = lineParts[1][0]

    let password = lineParts[2]

    let charCount = password.count(testChar)
    if charCount >= bounds[0] and charCount <= bounds[1]:
      validPasswords += 1
  
  return validPasswords

func partTwo(input: seq[string]): int =
  var validPasswords = 0
  for line in input:
    let lineParts = line.split(" ")
    doAssert(lineParts.len == 3, fmt"line in input does not have three parts: {line}")

    # subtract 1 to handle 1-based indexing
    let indexes = lineParts[0].split("-").map(str => str.parseInt - 1)
    doAssert(indexes.len == 2, fmt"character count bounds are not formatted correctly: {lineParts[0]}")

    doAssert(lineParts[1].len == 2, fmt"test char is not formatted correctly: {lineParts[1]}")
    let testChar = lineParts[1][0]

    let password = lineParts[2]

    if password[indexes[0]] == testChar xor password[indexes[1]] == testChar:
      validPasswords += 1
  return validPasswords

let input = readFile("input.txt")
  .split("\n")
  .map(str => str.strip)

let partOneResult = partOne(input)
echo fmt"part one: {partOneResult}"

let partTwoResult = partTwo(input)
echo fmt"part two: {partTwoResult}"