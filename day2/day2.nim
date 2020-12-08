import strutils
import sequtils
import sugar
import strformat
import strscans

proc singleCharMatcher(input: string, charVal: var char, start: int): int =
  if start < input.len:
    charVal = input[start]
    result = 1

proc partOne(input: seq[string]): int =
  var validPasswords = 0
  for line in input:
    var lowerbound, upperbound: int
    var testChar: char
    var password: string

    if scanf(line, "$i-$i ${singleCharMatcher}: $w", lowerbound, upperbound, testChar, password):
      let charCount = password.count(testChar)
      if charCount >= lowerbound and charCount <= upperbound:
        validPasswords += 1
    else:
      raise newException(Exception, fmt"line did not conform to expected pattern, line={line}")
  
  return validPasswords

func partTwo(input: seq[string]): int =
  var validPasswords = 0
  for line in input:
    var firstIndex, secondIndex: int
    var testChar: char
    var password: string

    if scanf(line, "$i-$i ${singleCharMatcher}: $w", firstIndex, secondIndex, testChar, password):
      if password[firstIndex-1] == testChar xor password[secondIndex-1] == testChar:
        validPasswords += 1
    else:
      raise newException(Exception, fmt"line did not conform to expected pattern, line={line}")

  return validPasswords

let input = readFile("input.txt")
  .split("\n")
  .map(str => str.strip)

let partOneResult = partOne(input)
echo fmt"part one: {partOneResult}"

let partTwoResult = partTwo(input)
echo fmt"part two: {partTwoResult}"