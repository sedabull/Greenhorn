// Generated by CoffeeScript 1.8.0

/*
startup.coffee
Written by Seth Bullock
sedabull@gmail.com
 */
var init;

document.title = 'Heroic Minority';

env.SOUND_PATH = '../sounds/';

env.USE_AUDIO_TAG = true;

init = function() {
  Greenhorn.start();
  return new Sound({
    url: 'heroic_minority.mp3',
    playOnLoad: true
  });
};
