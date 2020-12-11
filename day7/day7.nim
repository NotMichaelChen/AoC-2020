import strutils
import sequtils
import strformat
import sets
import tables
import sugar
import strscans
import strmisc

proc parseBags(bags: string): seq[(string, int)] =
  bags
    .split(",")
    .map(proc(rawBag: string): (string, int) =
      let strippedBag = rawBag.strip()
      var bagCount: int
      var bagName: string

      if scanf(strippedBag, "$i $*", bagCount, bagName):
        return (bagName.dup(removeSuffix({'s', '.'})), bagCount)
      else:
        return (strippedBag.dup(removeSuffix({'s', '.'})), 0)
    )

proc buildInvertedIndex(input: seq[string]): Table[string, HashSet[string]] =
  var index: Table[string, HashSet[string]]

  for line in input:
    let (rawValue, _, keys) = partition(line, "contain")
    let value = rawValue.strip().dup(removeSuffix('s'))

    for (key, _) in parseBags(keys):
      if index.hasKeyOrPut(key, toHashSet([value])):
        index[key].incl(value)

  return index

proc canBeContainedBy(invertedIndex: Table[string, HashSet[string]], bagName: string): HashSet[string] =
  if not (bagName in invertedIndex):
    return initHashSet[string]()

  var containedBy = invertedIndex[bagName]

  for containedBag in invertedIndex[bagName]:
    containedBy = containedBy + canBeContainedBy(invertedIndex, containedBag)

  return containedBy

proc partOne(input: seq[string]): int =
  buildInvertedIndex(input).canBeContainedBy("shiny gold bag").len

proc buildIndex(input: seq[string]): Table[string, HashSet[(string, int)]] =
  var index: Table[string, HashSet[(string, int)]]

  for line in input:
    let (rawKey, _, values) = partition(line, "contain")
    let key = rawKey.strip().dup(removeSuffix('s'))

    index[key] = toHashSet(parseBags(values))

  return index

proc countBagsContained(index: Table[string, HashSet[(string, int)]], outerBag: string): int =
  if not (outerbag in index):
    return 0

  var sum = 0
  for (bagName, bagCount) in index[outerbag]:
    sum += countBagsContained(index, bagName) * bagCount + bagCount

  return sum

proc partTwo(input: seq[string]): int =
  return buildIndex(input).countBagsContained("shiny gold bag")

let input = readFile("input.txt").split("\p")

let partOneResult = partOne(input)
echo fmt"part one: {partOneResult}"

let partTwoResult = partTwo(input)
echo fmt"part two: {partTwoResult}"