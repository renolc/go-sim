// Generated by CoffeeScript 1.7.1
var GoGame,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

GoGame = (function() {
  var Images;

  GoGame.prototype.canvas = null;

  GoGame.prototype.drawingContext = null;

  GoGame.prototype.board = null;

  GoGame.prototype.mousePosition = null;

  GoGame.prototype.cellSize = 20;

  GoGame.prototype.boardSize = 19;

  GoGame.prototype.FPS = 30;

  GoGame.prototype.currentAlpha = 0.5;

  Images = {
    INERSECTION: new Image(),
    TOPLEFT: new Image(),
    TOPRIGHT: new Image(),
    BOTTOMLEFT: new Image(),
    BOTTOMRIGHT: new Image(),
    TOP: new Image(),
    RIGHT: new Image(),
    LEFT: new Image(),
    BOTTOM: new Image(),
    BLACK: new Image(),
    WHITE: new Image()
  };

  function GoGame() {
    this.onMouseClick = __bind(this.onMouseClick, this);
    this.onMouseMove = __bind(this.onMouseMove, this);
    this.initCanvasAndContext();
    this.initBoard();
    this.loadImagesAndDraw();
  }

  GoGame.prototype.initCanvasAndContext = function() {
    this.canvas = document.createElement('canvas');
    this.canvas.height = this.cellSize * this.boardSize;
    this.canvas.width = this.canvas.height;
    this.drawingContext = this.canvas.getContext('2d');
    document.body.appendChild(this.canvas);
    this.canvas.onmousemove = this.onMouseMove;
    return this.canvas.onclick = this.onMouseClick;
  };

  GoGame.prototype.initBoard = function() {
    var col, row, _i, _ref, _results;
    this.board = [];
    _results = [];
    for (row = _i = 0, _ref = this.boardSize; 0 <= _ref ? _i < _ref : _i > _ref; row = 0 <= _ref ? ++_i : --_i) {
      this.board[row] = [];
      _results.push((function() {
        var _j, _ref1, _results1;
        _results1 = [];
        for (col = _j = 0, _ref1 = this.boardSize; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; col = 0 <= _ref1 ? ++_j : --_j) {
          _results1.push(this.board[row][col] = this.createCell(row, col));
        }
        return _results1;
      }).call(this));
    }
    return _results;
  };

  GoGame.prototype.createCell = function(row, col) {
    return {
      piece: null,
      row: row,
      col: col,
      x: col * this.cellSize,
      y: row * this.cellSize
    };
  };

  GoGame.prototype.loadImagesAndDraw = function() {
    var imagesLoadedCount, k, v;
    imagesLoadedCount = 0;
    for (k in Images) {
      v = Images[k];
      imagesLoadedCount++;
      v.onload = (function(_this) {
        return function() {
          imagesLoadedCount--;
          if (imagesLoadedCount === 0) {
            return _this.draw();
          }
        };
      })(this);
    }
    Images.TOP.src = 'img/topEdge.png';
    Images.RIGHT.src = 'img/rightEdge.png';
    Images.BOTTOM.src = 'img/bottomEdge.png';
    Images.LEFT.src = 'img/leftEdge.png';
    Images.TOPRIGHT.src = 'img/topRight.png';
    Images.TOPLEFT.src = 'img/topLeft.png';
    Images.BOTTOMRIGHT.src = 'img/bottomRight.png';
    Images.BOTTOMLEFT.src = 'img/bottomLeft.png';
    Images.INERSECTION.src = 'img/intersection.png';
    Images.BLACK.src = 'img/black.png';
    return Images.WHITE.src = 'img/white.png';
  };

  GoGame.prototype.draw = function() {
    var col, fillStyle, row, _i, _j, _ref, _ref1;
    fillStyle = 'rgb(195, 142, 72)';
    this.drawingContext.fillStyle = fillStyle;
    this.drawingContext.fillRect(0, 0, this.canvas.width, this.canvas.height);
    for (row = _i = 0, _ref = this.boardSize; 0 <= _ref ? _i < _ref : _i > _ref; row = 0 <= _ref ? ++_i : --_i) {
      for (col = _j = 0, _ref1 = this.boardSize; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; col = 0 <= _ref1 ? ++_j : --_j) {
        this.drawCell(this.board[row][col]);
      }
    }
    this.drawCurrentPiece();
    return setTimeout(((function(_this) {
      return function() {
        return _this.draw();
      };
    })(this)), 1000 / this.FPS);
  };

  GoGame.prototype.drawCurrentPiece = function() {
    if (this.mousePosition) {
      this.drawingContext.save();
      this.drawingContext.globalAlpha = this.currentAlpha;
      this.drawingContext.drawImage(Images.BLACK, this.mousePosition.x, this.mousePosition.y, this.cellSize, this.cellSize);
      return this.drawingContext.restore();
    }
  };

  GoGame.prototype.drawCell = function(cell) {
    var img;
    if (cell.row === 0 && cell.col === 0) {
      img = Images.TOPLEFT;
    } else if (cell.row === 0 && cell.col === this.boardSize - 1) {
      img = Images.TOPRIGHT;
    } else if (cell.row === this.boardSize - 1 && cell.col === 0) {
      img = Images.BOTTOMLEFT;
    } else if (cell.row === this.boardSize - 1 && cell.col === this.boardSize - 1) {
      img = Images.BOTTOMRIGHT;
    } else if (cell.row === 0) {
      img = Images.TOP;
    } else if (cell.row === this.boardSize - 1) {
      img = Images.BOTTOM;
    } else if (cell.col === 0) {
      img = Images.LEFT;
    } else if (cell.col === this.boardSize - 1) {
      img = Images.RIGHT;
    } else {
      img = Images.INERSECTION;
    }
    this.drawingContext.drawImage(img, cell.x, cell.y, this.cellSize, this.cellSize);
    if (cell.piece) {
      return this.drawingContext.drawImage(cell.piece, cell.x, cell.y, this.cellSize, this.cellSize);
    }
  };

  GoGame.prototype.onMouseMove = function(e) {
    var col, row;
    if (e.offsetX) {
      col = Math.floor(e.offsetX / this.cellSize);
      row = Math.floor(e.offsetY / this.cellSize);
      return this.mousePosition = {
        cellCol: col,
        cellRow: row,
        x: col * this.cellSize,
        y: row * this.cellSize
      };
    } else if (e.layerX) {
      col = Math.floor(e.layerX / this.cellSize);
      row = Math.floor(e.layerY / this.cellSize);
      return this.mousePosition = {
        cellCol: col,
        cellRow: row,
        x: col * this.cellSize,
        y: row * this.cellSize
      };
    }
  };

  GoGame.prototype.onMouseClick = function() {
    var cell;
    cell = this.board[this.mousePosition.cellRow][this.mousePosition.cellCol];
    return cell.piece = Images.BLACK;
  };

  return GoGame;

})();

window.onload = function() {
  return new GoGame();
};
