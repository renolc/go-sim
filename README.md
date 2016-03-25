# go-sim [![npm version](https://badge.fury.io/js/go-sim.svg)](https://badge.fury.io/js/go-sim)
Simulate the game [Go](https://en.wikipedia.org/wiki/Go_(game)) in JavaScript.

### Installation

```bash
npm i go-sim -S
```

### Usage

```javascript
const goSim = require('go-sim')

// make a new game
// defaults board size to 9x9
const game = goSim()

// make a custom sized game
const largeGame = goSim(50)

// get current game phase ('play', 'mark', or 'end')
game.phase

// get current turn ('black' or 'white')
game.turn

// get current board state
game.board

// get board size
game.board.size

// 1D array of board cells
game.board.cells

// get cell at (row, col)
const cell = game.board.at(2, 3)

// current cell value ('empty', 'black', or 'white')
cell.value

// check if cell has certain value (true or false)
cell.is('empty')

// serialize game into vanilla JavaScript object
const state = game.serialize()

// load the state into the current instance
game.load(state)

// or load a new game from serialized state
const newGame = goSim(state)

// see what the previous play was
// will have type of 'play' or 'pass'
// if 'play', will also have position last played as [row, col]
game.previousPlay
```

There are many more undocumented functions, but they will probably be less useful for creating a UI around the simulation.

### Phases

Go is played in a series of phases. A new game starts in the **Play** phase. While in each phase, certain functions will be available.

#### Play

```javascript
// play at the designated (row, col)
// the turn automatically advances to the next player
// any invalid move is ignored
game.play(2, 3)

// pass the current turn to the next player
// game advances to the Mark phase on consecutive passes
game.pass()
```

#### Mark

```javascript
// mark the cluster of pieces attached to (row, col) as dead
game.mark(2, 3)

// propose the marked clusters to the next player
// next player may mark/unmark clusters and counter propose
game.propose()

// reject the proposal and return to the Play phase to resolve disputes
game.reject()

// accept the proposal and advance to the End phase
game.accept()
```

#### End

```javascript
// retrieve the final calculated score
// komi is included at 6.5
game.score
```