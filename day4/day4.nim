import strutils
import sequtils
import strformat
import strscans
import sets
import re

let hclRegex = re"^#[0-9a-f]{6}$"
let pidRegex = re"^[0-9]{9}$"
let requiredFields = toHashSet([
  "byr",
  "iyr",
  "eyr",
  "hgt",
  "hcl",
  "ecl",
  "pid"
])

proc partOne(input: string): int =
  proc isValidPassport(passport: string): bool =
    let fields = passport
      .splitWhitespace()
      .map(proc(field: string): string =
        var fieldKey, fieldVal: string
        if scanf(field, "$w:$*", fieldKey, fieldVal):
          return fieldKey
        else:
          raise newException(Exception, fmt"Invalid field: {field}")
      )
    
    return requiredFields <= toHashSet(fields)

  return input
    .split("\p\p")
    .foldl(a + ord(isValidPassport(b)), 0)

proc partTwo(input: string): int =
  proc isFieldValid(fieldKey: string, fieldVal: string): bool =
    proc parseAndCheckNumber(str: string, lower: int, upper: int): bool =
      var parsedYear: int
      if scanf(fieldVal, "$i", parsedYear):
        return lower <= parsedYear and parsedYear <= upper
      else:
        return false
    
    case fieldKey:
    of "byr":
      return parseAndCheckNumber(fieldVal, 1920, 2002)
    of "iyr":
      return parseAndCheckNumber(fieldVal, 2010, 2020)
    of "eyr":
      return parseAndCheckNumber(fieldVal, 2020, 2030)
    of "hgt":
      var parsedHeight: int
      if scanf(fieldVal, "$icm", parsedHeight):
        return 150 <= parsedHeight and parsedHeight <= 193
      elif scanf(fieldVal, "$iin", parsedHeight):
        return 59 <= parsedHeight and parsedHeight <= 76
    of "hcl":
      return fieldVal.match(hclRegex)
    of "ecl":
      return toHashSet(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]).contains(fieldVal)
    of "pid":
      return fieldVal.match(pidRegex)
    of "cid":
      return true
    else:
      return false

  proc isValidPassport(passport: string): bool =
    let fieldAndValidations = passport
      .splitWhitespace()
      .map(proc(field: string): (string, bool) =
        var fieldKey, fieldVal: string
        if scanf(field, "$w:$*", fieldKey, fieldVal):
          return (fieldKey, isFieldValid(fieldKey, fieldVal))
        else:
          raise newException(Exception, fmt"Invalid field: {field}")
      )
    
    let (fieldKeySeq, validationSeq) = fieldAndValidations.unzip()
    return (requiredFields <= toHashSet(fieldKeySeq)) and (validationSeq.foldl(a and b))

  return input
    .split("\p\p")
    .foldl(a + ord(isValidPassport(b)), 0)

let input = readFile("input.txt")

let partOneResult = partOne(input)
echo fmt"part one: {partOneResult}"

let partTwoResult = partTwo(input)
echo fmt"part two: {partTwoResult}"