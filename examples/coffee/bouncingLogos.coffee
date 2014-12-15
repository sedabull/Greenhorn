###
bouncingLogos.coffee
Written by Seth Bullock
sedabull@gmail.com
###

#name the document
document.title = 'Bouncing Ubuntu Logos'

#setup the environment
env.IMAGE_PATH = '../images/'
env.ENGINE.leftHeader = 'INSTRUCTIONS'
env.ENGINE.rightHeader = 'BUTTONS'
env.SPRITE_DEFAULT_CONFIG.ddy = -50
env.SPRITE_DEFAULT_CONFIG.imageFile = 'logo.png'
env.SPRITE_DEFAULT_CONFIG.boundAction = 'BOUNCE'

#helper function to randomize Sprite config objects
randomConfig = ->
    size = Math.round(Math.random() * 64 + 32)
    {
        width: size
        height: size
        da: Math.random() * 2 - 1
        dx: Math.random() * 50 - 25
        x: Math.random() * env.ENGINE.canvasWidth - env.ENGINE.canvasWidth / 2
        y: Math.random() * env.ENGINE.canvasHeight - env.ENGINE.canvasHeight / 2
    }

#define init() to set up the document
init = ->
    #start the engine
    Greenhorn.start()

    #add control buttons
    Greenhorn.addButton({label: 'Clear Canvas', onclick: ->
        Sprites.deleteAll()
    })#end Clear Canvas
    Greenhorn.addButton({label: 'Add One', onclick: ->
        new Sprite(randomConfig())
    })#end Add One
    Greenhorn.addButton({label: 'Add Five', onclick: ->
        i = 5
        while i > 0
            i -= 1
            new Sprite(randomConfig())
    })#end Add Five
    Greenhorn.addButton({label: 'Add Ten', onclick: ->
        i = 10
        while i > 0
            i -= 1
            new Sprite(randomConfig())
    })#end Add Ten

    #add instructions
    instructions =
        '''
        <p style='white-space: initial'>
        Use the Buttons on the left hand side
        to add or remove Ubuntu logos.
        </p>
        '''
    $('#gh-left-panel').append(instructions)

    #create random number of logos to start
    i = Math.round(Math.random() * 9 + 1)
    while i > 0
        i -= 1
        new Sprite(randomConfig())
