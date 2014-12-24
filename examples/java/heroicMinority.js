// Generated by CoffeeScript 1.8.0

/*
startup.coffee
Written by Seth Bullock
sedabull@gmail.com
 */

(function() {
  var bgMusic;

  document.title = 'Heroic Minority';

  env.ENGINE.leftHeader = 'INFORMATION';

  env.ENGINE.rightHeader = 'BUTTONS';

  env.SOUND_PATH = '../sounds/';

  env.USE_AUDIO_TAG = true;

  bgMusic = null;

  this.init = function() {
    var information;
    Greenhorn.start();
    bgMusic = new Sound({
      url: 'heroic_minority.mp3'
    });
    Greenhorn.addButton({
      label: 'PLAY MUSIC',
      onclick: function() {
        return bgMusic.play();
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
    information = '<h4 class=\'gh-panel-sub-header\'>Instructions</h4>\n<p class=\'gh-p\'>\nUse the buttons on the right-hand side to test the\nthree primary Sound functions: play, pause, and stop.\n</p>\n<h4 class=\'gh-panel-sub-header\'>Acknowledgements</h4>\n<p class=\'gh-p\'>\nThis track you\'re listening to is titled <em>Heroic Minority</em>.\nI found it, along with many other great resources on \n<a class=\'gh-a\' href=\'http://opengameart.org\'>OpenGameArt.org</a>.\nThe author\'s name is <a class=\'gh-a\' href=\'http://opengameart.org/content/heroic-minority\'>\nAlexandr Zhelanov</a>. You can check out some of his other work \n<a class=\'gh-a\' href=\'https://soundcloud.com/alexandr-zhelanov\'>here</a>.\n</p>';
    return $('#gh-left-panel').append(information);
  };

}).call(this);