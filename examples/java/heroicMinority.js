// Generated by CoffeeScript 1.8.0

/*
heroicMinority.coffee
Written by Seth Bullock
sedabull@gmail.com
 */

(function() {
  var Greenhorn, Sound, env;

  document.title = 'Heroic Minority';

  env = gh.env, Greenhorn = gh.Greenhorn, Sound = gh.Sound;

  env.SOUND_PATH = '../sounds/';

  env.ENGINE.leftHeader = 'INFORMATION';

  env.ENGINE.rightHeader = 'BUTTONS';

  gh.init = function() {
    Greenhorn.start();
    window.bgMusic = new Sound({
      url: 'heroic_minority.mp3'
    });
    Greenhorn.addButton({
      label: 'PLAY MUSIC',
      onclick: function() {
        return bgMusic.play();
      }
    });
    Greenhorn.addButton({
      label: 'RESTART MUSIC',
      onclick: function() {
        return bgMusic.restart();
      }
    });
    Greenhorn.addButton({
      label: 'PAUSE MUSIC',
      onclick: function() {
        return bgMusic.pause();
      }
    });
    Greenhorn.addButton({
      label: 'STOP MUSIC',
      onclick: function() {
        return bgMusic.stop();
      }
    });
    return $('#gh-left-panel').append('<h4 class=\'gh-sub-h\'>Instructions</h4>\n<p class=\'gh-p\'>\nUse the buttons on the right-hand side to test the\nfour primary Sound functions: play, restart, pause, and stop.\n</p>\n<h4 class=\'gh-sub-h\'>Acknowledgements</h4>\n<p class=\'gh-p\'>\nThis track you\'re listening to is titled <em>Heroic Minority</em>.\nI found it, along with many other great resources on \n<a class=\'gh-a\' href=\'http://opengameart.org\'>OpenGameArt.org</a>.\nThe author\'s name is \n<a class=\'gh-a\' href=\'http://opengameart.org/content/heroic-minority\'>\nAlexandr Zhelanov</a>. You can check out some of his other work \n<a class=\'gh-a\' href=\'https://soundcloud.com/alexandr-zhelanov\'>here</a>.\n</p>\n<h4 class=\'gh-sub-h\'>Discussion</h4>\n<p class=\'gh-p\'>\nPlease note that the soundtrack will not start playing back\nuntil the engine has started.\n</p>');
  };

}).call(this);
