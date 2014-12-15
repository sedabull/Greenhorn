// Generated by CoffeeScript 1.8.0

/*
bouncingLogos.coffee
Written by Seth Bullock
sedabull@gmail.com
 */
var init, randomConfig, update;

document.title = 'Bouncing Logos';

env.IMAGE_PATH = '../images/';

env.ENGINE.bounceDecay = .2;

env.ENGINE.footer = '\\/ Check out the source code below \\/';

env.SPRITE_DEFAULT_CONFIG.imageFile = 'logo.png';

env.SPRITE_DEFAULT_CONFIG.boundAction = 'BOUNCE';

randomConfig = function() {
  var size;
  size = Math.round(Math.random() * 64 + 32);
  return {
    x: Math.random() * env.ENGINE.canvasWidth - env.ENGINE.canvasWidth / 2,
    y: Math.random() * env.ENGINE.canvasHeight - env.ENGINE.canvasHeight / 2,
    dx: Math.random() * 50 - 25,
    da: Math.random() * 2 - 1,
    width: size,
    height: size
  };
};

init = function() {
  var i, _results;
  Greenhorn.start();
  i = Math.round(Math.random() * 9 + 1);
  _results = [];
  while (i > 0) {
    i -= 1;
    _results.push(new Sprite(randomConfig()));
  }
  return _results;
};

update = function() {
  if (isDown[KEYS.SPACE]) {
    new Sprite(randomConfig());
  }
  return Sprites.changeAll('dy', -50);
};
