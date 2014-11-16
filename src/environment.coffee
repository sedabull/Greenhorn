###
environment.coffee

The Greenhorn Gaming environment object
###

@env =
    #miscellaneous
    FRAME_RATE: 25
    #document body settings
    BODY_BACKGROUND_COLOR: "goldenrod"
    #default engine settings
    ENGINE_TITLE: document.title
    ENGINE_LEFT_PANEL: "LEFT PANEL"
    ENGINE_RIGHT_PANEL: "RIGHT PANEL"
    ENGINE_BOTTOM_PANEL: "BOTTOM PANEL"
    ENGINE_CANVAS_COLOR: "black"
    ENGINE_BACKGROUND_COLOR: "darkgreen"
    ENGINE_CANVAS_ERROR: "your web browser does not support the <canvas> tag"
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
    #default sound settings
    SOUND_PATH: ""
    SOUND_DEFAULT_URL: ""
    #default timer settings
    TIMER_START_ON_CONSTRUCTION: yes
    #default button settings
    BUTTON_DEFAULT_LABEL: "Launch the Missiles!"
#end environment object