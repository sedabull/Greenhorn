###
greenhorn.coffee
Written by Seth Bullock
sedabull@gmail.com
###

#automatic initialization
document.onreadystatechange = ->
    if @readyState is 'interactive'
        Greenhorn.emit 'ready'

#keyboard value mapping object
KEYS =
    SHIFT: 16, CTRL: 17, ALT: 18
    ESC: 27, SPACE: 32, PGUP: 33
    PGDOWN: 34, END: 35, HOME: 36
    LEFT: 37, UP: 38, RIGHT: 39, DOWN: 40
    '0': 48, '1': 49, '2': 50, '3': 51, '4': 52
    '5': 53, '6': 54, '7': 55, '8': 56, '9': 57
    A: 65, B: 66, C: 67, D: 68, E: 69, F: 70
    G: 71, H: 72, I: 73, J: 74, K: 75, L: 76, M: 77
    N: 78, O: 79, P: 80, Q: 81, R: 82, S: 83
    T: 84, U: 85, V: 86, W: 87, X: 88, Y: 89, Z: 90
gh.KEYS = KEYS

#Engine class
class Greenhorn extends EventEmitter
    #Greenhorn configuration object
    @config:
        frameRate: 25
        title: 'GH-TITLE'
        leftHeader: 'GH-LEFT-PANEL'
        rightHeader: 'GH-RIGHT-PANEL'
        footer: 'GH-FOOTER'
        startUp:
            size: 50
            color: '#006400'
            font: 'sans-serif'
            text: 'CLICK HERE TO START!'

    #Greenhorn button defaults
    @buttonDefaults:
        type: 'button'
        onclick: undefined
        parent: 'gh-right-panel'
        label: 'Launch the Missiles!'

    #asynchronous ID
    _masterID = null
    #draws on canvas once per frame
    _masterUpdate = ->
        Greenhorn.clear()
        Greenhorn.emit 'update'
        Sprite._drawAll()

    #keyboard input tracking array (read only)
    _isDown = new Array 128
    key = false for key in _isDown

    #listen for key events
    document.onkeydown = (e) ->
        e.preventDefault()
        _isDown[e.keyCode] = true
    document.onkeyup = (e) ->
        e.preventDefault()
        _isDown[e.keyCode] = false

    #call EventEmitter constructor
    constructor: -> super()

    #raw DOM manipulation
    _main = document.createElement 'div'
    _title = document.createElement 'h1'
    _leftPanel = document.createElement 'div'
    _leftPanelHeader = document.createElement 'h3'
    @canvas = document.createElement 'canvas'
    _rightPanel = document.createElement 'div'
    _rightPanelHeader = document.createElement 'h3'
    _footer = document.createElement 'div'
    _context = @canvas.getContext '2d'

    #give id's to primary children
    _main.id = 'gh-main'
    _title.id = 'gh-title'
    _leftPanel.id = 'gh-left-panel'
    @canvas.id = 'gh-canvas'
    _rightPanel.id = 'gh-right-panel'
    _footer.id = 'gh-footer'

    #assign gh-h class to panelHeaders
    _leftPanelHeader.classList.add 'gh-h'
    _rightPanelHeader.classList.add 'gh-h'

    #append all primary children to main div
    _main.appendChild _title
    _main.appendChild _leftPanel
    _main.appendChild @canvas
    _main.appendChild _rightPanel
    _main.appendChild _footer

    #append headers to panels
    _leftPanel.appendChild _leftPanelHeader
    _rightPanel.appendChild _rightPanelHeader

    #keep track of mouse events over canvas
    @canvas.onmousemove = (e) ->
        @mouseX = e.pageX
        @mouseY = e.pageY
        Sprite.emitAll 'mouse:move', e
    @canvas.onmousedown = (e) ->
        Sprite.emitAll 'mouse:down', e
    @canvas.onmouseup = (e) ->
        Sprite.emitAll 'mouse:up', e
    @canvas.ondblclick = (e) ->
        Sprite.emitAll 'mouse:doubleClick', e
    @canvas.oncontextmenu = (e) ->
        e.preventDefault()
        Sprite.emitAll 'mouse:rightClick', e

    #keyPress tester
    @isDown = (key) ->
        _isDown[key]

    #mouse position getters
    @getMouseX = ->
        @canvas.mouseX - @canvas.offsetLeft - @canvas.width / 2
    @getMouseY = ->
        -@canvas.mouseY + @canvas.offsetTop + @canvas.height / 2

    #add button to one of the panels
    @addButton = (config = {}) ->
        #add missing keys to config
        for own key, value of @buttonDefaults
            config[key] ?= value

        #create element
        button = document.createElement 'button'

        #set values
        button.type = config.type
        button.innerHTML = config.label
        button.onclick = config.onclick
        button.classList.add 'gh-button'

        #append to an element
        main.getElementById(config.parent).appendChild button

    #game state functions + helper
    _currentState = 'INITIALIZING'
    @currentState = -> _currentState
    @changeState = (newState) ->
        @emit "state-change-from:#{_currentState}"
        @emit 'state-change', _currentState, newState
        @emit "state-change-to:#{newState}"
        _currentState = newState

    #game control
    @isRunning = ->
        _masterID?
    @stop = ->
        Sprite._stopAll()
        Sound._pauseAll()
        clearInterval _masterID
        _masterID = null
    @clear = ->
        _context.clearRect -@canvas.width / 2, -@canvas.height / 2, @canvas.width, @canvas.height

    #start function + helpers
    _firstTime = true
    _start = ->
        _masterID = setInterval _masterUpdate, 1000 / @config.frameRate
        Sprite._startAll()
        Sound._playAll()
        return
    @start = (stateName) =>
        #prevent starting without properly stopping first
        unless @isRunning()
            if _firstTime
                #add engine to a user defined '#gh' div
                if mainDiv = document.querySelector '#gh'
                    mainDiv.appendChild _elmnts.main
                else
                    console.log "There is no '#gh' element!"

                #set the innerHTML of each element
                _title.innerHTML = @config.title
                _leftPanelHeader.innerHTML = @config.leftHeader
                _rightPanelHeader.innerHTML = @config.rightHeader
                _footer.innerHTML = @config.footer
                @canvas.innerHTML = 'Your browser does not support the &ltcanvas&gt tag'

                #set the size of the canvas
                @canvas.width = @canvas.clientWidth
                @canvas.height = @canvas.clientHeight

                #center the canvas origin point
                _context.translate @canvas.width / 2, @canvas.height / 2

                #draw the start screen
                _context.save()
                _context.globalAlpha = 1.0
                _context.textAlign = 'center'
                _context.textBaseline = 'middle'
                _context.font = "#{@config.startUp.size}px #{@config.startUp.font}"
                _context.fillStyle = @config.startUp.color
                _context.fillText @config.startUp.text, 0, 0
                _context.restore()

                #make the entire canvas a start button
                @canvas.onclick = ->
                    _start()
                    Greenhorn.changeState stateName ? 'GREENHORN'
                    @canvas.onclick = (e) ->
                        Sprite.emitAll 'mouse:click', e

                #don't do all this a second time
                _firstTime = false
            else
                _start()
                if stateName then @changeState stateName

#add to namespace object
gh.Greenhorn = Greenhorn
