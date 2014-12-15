// Generated by CoffeeScript 1.8.0

/*
bouncingLogos.coffee
Written by Seth Bullock
sedabull@gmail.com
 */
var init, randomConfig;

document.title = 'Bouncing Ubuntu Logos';

env.IMAGE_PATH = '../images/';

env.ENGINE.leftHeader = 'INSTRUCTIONS';

env.ENGINE.rightHeader = 'BUTTONS';

env.SPRITE_DEFAULT_CONFIG.ddy = -50;

env.SPRITE_DEFAULT_CONFIG.imageFile = 'logo.png';

env.SPRITE_DEFAULT_CONFIG.boundAction = 'BOUNCE';

randomConfig = function() {
  var size;
  size = Math.round(Math.random() * 64 + 32);
  return {
    width: size,
    height: size,
    da: Math.random() * 2 - 1,
    dx: Math.random() * 50 - 25,
    x: Math.random() * env.ENGINE.canvasWidth - env.ENGINE.canvasWidth / 2,
    y: Math.random() * env.ENGINE.canvasHeight - env.ENGINE.canvasHeight / 2
  };
};

init = function() {
  var i, instructions, _results;
  Greenhorn.start();
  Greenhorn.addButton({
    label: 'Clear Canvas',
    onclick: function() {
      return Sprites.deleteAll();
    }
  });
  Greenhorn.addButton({
    label: 'Add One',
    onclick: function() {
      return new Sprite(randomConfig());
    }
  });
  Greenhorn.addButton({
    label: 'Add Five',
    onclick: function() {
      var i, _results;
      i = 5;
      _results = [];
      while (i > 0) {
        i -= 1;
        _results.push(new Sprite(randomConfig()));
      }
      return _results;
    }
  });
  Greenhorn.addButton({
    label: 'Add Ten',
    onclick: function() {
      var i, _results;
      i = 10;
      _results = [];
      while (i > 0) {
        i -= 1;
        _results.push(new Sprite(randomConfig()));
      }
      return _results;
    }
  });
  instructions = '<p style=\'white-space: initial\'>\nUse the Buttons on the left hand side\nto add or remove Ubuntu logos.\n</p>';
  $('#gh-left-panel').append(instructions);
  i = Math.round(Math.random() * 9 + 1);
  _results = [];
  while (i > 0) {
    i -= 1;
    _results.push(new Sprite(randomConfig()));
  }
  return _results;
};
