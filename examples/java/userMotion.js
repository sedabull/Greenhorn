// Generated by CoffeeScript 1.8.0

/*
userMotion.coffee

user controls the motion of
a sprite with the keyboard
 */

(function() {
  var init, logo, update;

  document.title = 'User Controlled Motion';

  env.IMAGE_PATH = '../images/';

  env.ENGINE_BOTTOM_PANEL = 'Use the arrow keys to move\nand the space bar to spin';

  logo = null;

  init = function() {
    logo = new Sprite({
      imageFile: 'logo.png'
    });
    return Greenhorn.start();
  };

  update = function() {
    if (keysDown[KEYS.UP]) {
      logo.change('y', 50);
    }
    if (keysDown[KEYS.DOWN]) {
      logo.change('y', -50);
    }
    if (keysDown[KEYS.RIGHT]) {
      logo.change('x', 50);
    }
    if (keysDown[KEYS.LEFT]) {
      logo.change('x', -50);
    }
    if (keysDown[KEYS.SPACE]) {
      logo.change('a', 2);
    }
    return Greenhorn.set('leftPanel', 'innerHTML', logo.report());
  };

}).call(this);
