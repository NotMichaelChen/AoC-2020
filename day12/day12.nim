import math
import sequtils
import strformat
import strscans
import strutils

proc singleCharMatcher(input: string, charVal: var char, start: int): int =
  if start < input.len:
    charVal = input[start]
    result = 1

proc partOne(input: seq[string]): float =
  proc runAction(currentLocation: (float, float, float), command: (char, int)): (float, float, float) =
    let (action, value) = command
    let (x, y, degrees) = currentLocation
    let floatValue = value.toFloat
    case action:
    of 'N':
      return (x, y + floatValue, degrees)
    of 'S':
      return (x, y - floatValue, degrees)
    of 'E':
      return (x + floatValue, y, degrees)
    of 'W':
      return (x - floatValue, y, degrees)
    of 'L':
      return (x, y, degrees + floatValue)
    of 'R':
      return (x, y, degrees - floatValue)
    of 'F':
      return (x + floatValue * cos(degToRad(degrees)), y + floatValue * sin(degToRad(degrees)), degrees)
    else:
      raise newException(Exception, fmt"invalid action: {command}")

  let location = input.map(proc(command: string): (char, int) =
    var action: char
    var value: int

    if scanf(command, "${singleCharMatcher}$i", action, value):
      return (action, value)
    else:
      raise newException(Exception, fmt"Invalid command: {command}")
  )
  .foldl(runAction(a, b), (0.0, 0.0, 0.0))

  return abs(location[0]) + abs(location[1])

proc partTwo(input: seq[string]): float =
  type Location = tuple[x, y: float]

  proc rotate(location: Location, rad: float): Location =
    (
      location.x * cos(rad) - location.y * sin(rad),
      location.x * sin(rad) + location.y * cos(rad)
    )

  proc runAction(currentLocation: (Location, Location), command: (char, int)): (Location, Location) =
    let (action, value) = command
    let (shipLocation, waypointLocation) = currentLocation

    let floatValue = value.toFloat
    case action:
    of 'N':
      return (
        shipLocation,
        (waypointLocation.x, waypointLocation.y + floatValue)
      )
    of 'S':
      return (
        shipLocation,
        (waypointLocation.x, waypointLocation.y - floatValue)
      )
    of 'E':
      return (
        shipLocation,
        (waypointLocation.x + floatValue, waypointLocation.y)
      )
    of 'W':
      return (
        shipLocation,
        (waypointLocation.x - floatValue, waypointLocation.y)
      )
    of 'L':
      let rad = degToRad(floatValue)
      return (
        shipLocation,
        rotate(waypointLocation, rad)
      )
    of 'R':
      let rad = -degToRad(floatValue)
      return (
        shipLocation,
        rotate(waypointLocation, rad)
      ) 
    of 'F':
      return (
        (shipLocation.x + waypointLocation.x * floatValue, shipLocation.y + waypointLocation.y * floatValue),
        waypointLocation
      )
    else:
      raise newException(Exception, fmt"invalid action: {command}")

  let location = input.map(proc(command: string): (char, int) =
    var action: char
    var value: int

    if scanf(command, "${singleCharMatcher}$i", action, value):
      return (action, value)
    else:
      raise newException(Exception, fmt"Invalid command: {command}")
  )
  .foldl(runAction(a, b), ((0.0, 0.0), (10.0, 1.0)))

  return abs(location[0][0]) + abs(location[0][1])

let input = readFile("input.txt").split("\p")

let partOneResult = partOne(input)
echo fmt"part one: {partOneResult}"

let partTwoResult = partTwo(input)
echo fmt"part two: {partTwoResult}"