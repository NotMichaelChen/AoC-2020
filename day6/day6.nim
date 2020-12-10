import strutils
import sequtils
import strformat
import sets
import sugar

proc partOne(input: seq[string]): int =
  return input
    .map(proc(group: string): int =
      return group
        .filter(c => c.isAlphaNumeric)
        .toHashSet()
        .len()
    )
    .foldl(a + b)

proc partTwo(input: seq[string]): int =
  return input
    .map(proc(group: string): int =
      let individualResponses = group.splitWhitespace()

      proc getCommonAnswers(commonAnswers: HashSet, individualAnswers: string): HashSet =
        return intersection(
          commonAnswers,
          toHashSet(toSeq(individualAnswers.items))
        )

      let commonAnswers = individualResponses.foldl(
        getCommonAnswers(a, b),
        toHashSet(toSeq(individualResponses[0].items))
      )
      return commonAnswers.len
    )
    .foldl(a + b)

let input = readFile("input.txt").split("\p\p")

let partOneResult = partOne(input)
echo fmt"part one: {partOneResult}"

let partTwoResult = partTwo(input)
echo fmt"part two: {partTwoResult}"