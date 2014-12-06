###
environment.coffee

The Greenhorn Gaming environment object
###

@env =
    _env: this
    #frame rate
    FRAME_RATE: 25
    #Greenhorn engine style
    ENGINE:
        accentColor: 'silver'
        backgroundColor: 'black'
        foregroundColor: 'darkgreen'
        footer: 'BOTTOM PANEL'
        leftHeader: 'LEFT PANEL'
        rightHeader: 'RIGHT PANEL'
    #default Sprite settings
    IMAGE_PATH: ""
    SPRITE_DEFAULT_CONFIG:
        x: 0
        y: 0
        z: 0
        a: 0
        dx: 0
        dy: 0
        dz: 0
        da: 0
        ddx: 0
        ddy: 0
        ddz: 0
        dda: 0
        width: 64
        height: 64
        imageFile: ""
        visible: yes
        boundAction: "WRAP"
    #default TextBox settings
    TEXTBOX_DEFAULT_CONFIG:
        z: -1
        text: "*-TextBox-*"
        align: "center"
        backgroundColor: "black"
        backgroundAlpha: 1.0
        backgroundVisible: yes
        borderSize: 5
        borderColor: "white"
        borderAlpha: 1.0
        borderVisible: yes
        fontName: "Arial"
        fontSize: 8
        fontColor: "white"
        fontAlpha: 1.0
        marginsTop: 5
        marginsBottom: 5
        marginsRight: 5
        marginsLeft: 5
    ANISPRITE_DEFAULT_CONFIG:
        cellWidth: 32
        cellHeight: 32
        frameRate: 5
        numFrames: 8
    #default sound settings
    SOUND_PATH: ""
    USE_AUDIO_TAG: false
    SOUND_DEFAULT_CONFIG:
        url: ""
        playOnLoad: false
    #default timer settings
    TIMER_START_ON_CONSTRUCTION: yes
    #default button settings
    BUTTON_DEFAULT_CONFIG:
        onclick: undefined
        parent: 'rightPanel'
        label: 'Launch the Missiles!'
        style:
            clear: 'left'
            cssFloat: 'left'
            width: '98%'
            color: 'black'
            margin: '1%'
            fontSize: 'small'
            backgroundColor: 'silver'
#end environment object
