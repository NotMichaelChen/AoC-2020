import strutils
import strformat
import sets
import strscans

proc partOne(input: seq[string]): int =
  var program = input
  var acc = 0
  var pc = 0

  while pc < program.len:
    var instruction: string
    var arg: int
    
    if scanf(program[pc], "$w $i", instruction, arg):
      program[pc] = ""
      case instruction:
      of "acc":
        acc += arg
        pc += 1
      of "nop":
        pc += 1
      of "jmp":
        pc += arg
    else:
      break

  return acc

type ProgramState = object
  acc, pc: int
  linesVisited: HashSet[int]

proc runProgram(program: seq[string]): int =
  var state = ProgramState(acc: 0, pc: 0)
  var stateStack: seq[tuple[state: ProgramState, instruction: string]]
  var isPushable = true

  while state.pc < program.len:
    var instruction: string
    var arg: int

    if state.pc in state.linesVisited:
      isPushable = false
      (state, instruction) = stateStack.pop()

      case instruction:
      of "nop":
        state.linesVisited.incl(state.pc)
        state.pc += arg
      of "jmp":
        state.linesVisited.incl(state.pc)
        state.pc += 1
      else:
        raise newException(Exception, fmt"Pushed a non jmp/nop instruction to the state stack: {instruction}")

    elif scanf(program[state.pc], "$w $i", instruction, arg):
      case instruction:
      of "acc":
        state.linesVisited.incl(state.pc)
        state.acc += arg
        state.pc += 1
      of "nop":
        if isPushable: stateStack.add((state, "nop"))
        state.linesVisited.incl(state.pc)
        state.pc += 1
      of "jmp":
        if isPushable: stateStack.add((state, "jmp"))
        state.linesVisited.incl(state.pc)
        state.pc += arg
    else:
      raise newException(Exception, fmt"Invalid instruction: {program[state.pc]}")

  return state.acc

proc partTwo(input: seq[string]): int =
  return runProgram(input)

let input = readFile("input.txt").split("\p")

let partOneResult = partOne(input)
echo fmt"part one: {partOneResult}"

let partTwoResult = partTwo(input)
echo fmt"part two: {partTwoResult}"