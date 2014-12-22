// Generated by CoffeeScript 1.8.0

/*
circleOfFriends.coffee
Written by Seth Bullock
sedabull@gmail.com
 */

(function() {
  var randomConfig;

  document.title = 'Circle of Friends';

  env.IMAGE_PATH = '../images/';

  env.ENGINE.leftHeader = 'INFORMATION';

  env.ENGINE.rightHeader = 'BUTTONS';

  env.SPRITE_DEFAULT_CONFIG.ddy = -50;

  env.SPRITE_DEFAULT_CONFIG.imageFile = 'logo.png';

  env.SPRITE_DEFAULT_CONFIG.boundAction = 'BOUNCE';

  randomConfig = function() {
    var canvasHeight, canvasWidth, size;
    size = Math.round(Math.random() * 64 + 32);
    canvasWidth = $('#gh-canvas')[0].width;
    canvasHeight = $('#gh-canvas')[0].height;
    return {
      width: size,
      height: size,
      da: Math.random() * 2 - 1,
      dx: Math.random() * 50 - 25,
      x: Math.random() * canvasWidth - canvasWidth / 2,
      y: Math.random() * canvasHeight - canvasHeight / 2
    };
  };

  this.init = function() {
    var i, information;
    Greenhorn.start();
    $('#gh-right-panel').append('<h4 class="gh-panel-sub-header">ENGINE CONTROL</h4>');
    Greenhorn.addButton({
      label: 'START',
      onclick: function() {
        return Greenhorn.start();
      }
    });
    Greenhorn.addButton({
      label: 'PAUSE',
      onclick: function() {
        return Greenhorn.stop();
      }
    });
    $('#gh-right-panel').append('<h4 class="gh-panel-sub-header">BOUND ACTIONS</h4>');
    Greenhorn.addButton({
      label: 'BOUNCE',
      onclick: function() {
        env.SPRITE_DEFAULT_CONFIG.boundAction = 'BOUNCE';
        return Sprites.setAll('boundAction', 'BOUNCE');
      }
    });
    Greenhorn.addButton({
      label: 'WRAP',
      onclick: function() {
        env.SPRITE_DEFAULT_CONFIG.boundAction = 'WRAP';
        return Sprites.setAll('boundAction', 'WRAP');
      }
    });
    Greenhorn.addButton({
      label: 'STOP',
      onclick: function() {
        env.SPRITE_DEFAULT_CONFIG.boundAction = 'STOP';
        return Sprites.setAll('boundAction', 'STOP');
      }
    });
    Greenhorn.addButton({
      label: 'DIE',
      onclick: function() {
        env.SPRITE_DEFAULT_CONFIG.boundAction = 'DIE';
        return Sprites.setAll('boundAction', 'DIE');
      }
    });
    $('#gh-right-panel').append('<h4 class="gh-panel-sub-header">ADD/REMOVE SPRITES</h4>');
    Greenhorn.addButton({
      label: 'ADD ONE',
      onclick: function() {
        return new Sprite(randomConfig());
      }
    });
    Greenhorn.addButton({
      label: 'ADD FIVE',
      onclick: function() {
        var i;
        i = 5;
        while (i > 0) {
          i -= 1;
          new Sprite(randomConfig());
        }
      }
    });
    Greenhorn.addButton({
      label: 'ADD TEN',
      onclick: function() {
        var i;
        i = 10;
        while (i > 0) {
          i -= 1;
          new Sprite(randomConfig());
        }
      }
    });
    Greenhorn.addButton({
      label: 'ADD FIFTY',
      onclick: function() {
        var i;
        i = 50;
        while (i > 0) {
          i -= 1;
          new Sprite(randomConfig());
        }
      }
    });
    Greenhorn.addButton({
      label: 'REMOVE ALL',
      onclick: function() {
        return Sprites.removeAll();
      }
    });
    information = '<div>\n<h4 class=\'gh-panel-sub-header\'>Instructions</h4>\n<p class=\'gh-p\'>\nUse the Buttons on the left hand side\nto start and stop the engine, change the\ndefault boundary action, or add\nand remove Circles of Friends.\n</p>\n<h4 class=\'gh-panel-sub-header\'>Trademark</h4>\n<p class=\'gh-p\'>\nPlease note that the logo used in this\nexample, which is known as\nThe Circle of Friends,\nis a registered trademark of\nCanonical Ltd.\n</p>\n<h4 class=\'gh-panel-sub-header\'>Discussion</h4>\n<p class=\'gh-p\'>\nTry this if you\'re not sure where to start. \nCreate about 150 Sprites, then change the \nboundary action from BOUNCE to WRAP to BOUNCE\nto STOP to DIE, with about 5-10 seconds inbetween. Have fun!\n</p>\n</div>';
    $('#gh-left-panel').append(information);
    i = Math.round(Math.random() * 9 + 1);
    while (i > 0) {
      i -= 1;
      new Sprite(randomConfig());
    }
  };

  this.update = function() {
    $('#gh-title').html("" + document.title + ": " + (Sprites.howMany()));
    $('.gh-button').each(function() {
      if (this.innerHTML === env.SPRITE_DEFAULT_CONFIG.boundAction) {
        return this.style.color = '#006400';
      } else {
        return this.style.color = '#C0C0C0';
      }
    });
  };

}).call(this);
