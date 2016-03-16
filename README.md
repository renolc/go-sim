# GoSim
Simulate the game [Go](https://en.wikipedia.org/wiki/Go_(game)) in JavaScript.

### Installation

```bash
npm i go-sim -S
```

### Usage

```javascript
const goSim = require('go-sim')

// make a new game
const game = goSim() // defaults board size to 9x9

// make a custom sized game
const largeGame = goSim({size: 19})

// pass turn
game.pass()

// play at position (row, col)
game.play(3, 4)

// get current turn
game.turn // returns 'black' or 'white'

// get current board
game.board // returns board object

// serialize game into vanilla JavaScript object
const state = game.serialize()

// load game from serialized state
game.load(state) // alternatively, load on initial game creation with goSim({load: state})
```

### ToDo

- [ ] end game when 2 consecutive passes
- [ ] implement mark phase
- [ ] calculate end game score (including [komi](https://en.wikipedia.org/wiki/Go_(game)#Komi))
