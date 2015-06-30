# GoSim
Simulate the game [Go](https://en.wikipedia.org/wiki/Go_(game)) in CoffeeScript/JavaScript.

### Usage

##### Create a new game
```javascript
var game = new Game();

// can pass in an arbitrary board size (defaults to 19)
var bigGame = new Game(50); 
```

##### Game functions
```javascript
// play at the (x, y) position, 0-indexed. Turn auto advances
game.play(4, 3);

// pass the current turn
game.pass();
```

##### Enums
```javascript
Cell.PIECE.EMPTY // null,  represents an empty cell
Cell.PIECE.BLACK // false, represents a cell with a black piece present
Cell.PIECE.WHITE // true,  represents a cell with a white piece present
```

##### Utility functions
```javascript
// get the current turn (will equate to Cell.PIECE.{BLACK, WHITE})
var turn = game.turn;

// get the size of the game board
var size = game.board.size;

// get the cell at the (x, y) position, 0-indexed
var cell = game.board.at(4, 3);

// check if the cell has a specific value
var bool = cell.is(Cell.PIECE.EMPTY);

// get the cell value (will equate to a Cell.PIECE)
var value = cell.value;
```

##### ToDo

- [ ] enforce [ko rule](https://en.wikipedia.org/wiki/Go_(game)#The_ko_rule)
- [ ] end game when 2 consecutive passes
- [ ] keep track of captured stones
- [ ] end game dead cluster mark
- [ ] calculate end game score (including [komi](https://en.wikipedia.org/wiki/Go_(game)#Komi))
