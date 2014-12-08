###
greenhorn.coffee
by Seth Bullock

***THE GREENHORN GAMING ENGINE***

primarily inspired by Andy Harris'
(aharrisbooks.net) simpleGame.js gaming engine
###

#keyboard input tracking array
@isDown = new Array(256)
key = false for key in @isDown

#keyboard value mapping object
@KEYS =
    ESC: 27, SPACE: 32, PGUP: 33
    PGDOWN: 34, END: 35, HOME: 36
    LEFT: 37, UP: 38, RIGHT: 39, DOWN: 40
    _0: 48, _1: 49, _2: 50, _3: 51, _4: 52
    _5: 53, _6: 54, _7: 55, _8: 56, _9: 57
    A: 65, B: 66, C: 67, D: 68, E: 69, F: 70
    G: 71, H: 72, I: 73, J: 74, K: 75, L: 76, M: 77
    N: 78, O: 79, P: 80, Q: 81, R: 82, S: 83
    T: 84, U: 85, V: 86, W: 87, X: 88, Y: 89, Z: 90

#document event handlers
document.onreadystatechange = ->
    if @readyState is 'interactive' then (init ? Greenhorn.start)()
    return
document.onkeydown = (e) ->
    e.preventDefault()
    isDown[e.keyCode] = true
    return
document.onkeyup = (e) ->
    e.preventDefault()
    isDown[e.keyCode] = false
    return
document.onmousemove = (e) ->
    @mouseX = e.pageX
    @mouseY = e.pageY
    return

#integer ID used to start and stop _masterUpdate
_masterID = null

#handles all behind the scenes update tasks once per frame
_masterUpdate = ->
    #clear previous frame
    Greenhorn.clear()
    
    #call user's update
    #if one is defined
    update?()
    
    #draw all Sprites
    Sprites._drawAll()
#end _masterUpdate

#engine class
class @Greenhorn
    #create Engine elements
    _elmnts =
        main: document.createElement 'div'
        title: document.createElement 'h1'
        leftPanel: document.createElement 'div'
        leftPanelHeader: document.createElement 'h3'
        canvas: document.createElement 'canvas'
        rightPanel: document.createElement 'div'
        rightPanelHeader: document.createElement 'h3'
        bottomPanel: document.createElement 'div'
    
    #give id's to all elements
    _elmnts.main.id = 'gh-main'
    _elmnts.title.id = 'gh-title'
    _elmnts.leftPanel.id = 'gh-left-panel'
    _elmnts.leftPanelHeader.id = 'gh-left-panel-header'
    _elmnts.canvas.id = 'gh-canvas'
    _elmnts.rightPanel.id = 'gh-right-panel'
    _elmnts.rightPanelHeader.id = 'gh-right-panel-header'
    _elmnts.bottomPanel.id = 'gh-bottom-panel'
    
    #append all primary children to main div
    _elmnts.main.appendChild _elmnts.title
    _elmnts.main.appendChild _elmnts.leftPanel
    _elmnts.main.appendChild _elmnts.canvas
    _elmnts.main.appendChild _elmnts.rightPanel
    _elmnts.main.appendChild _elmnts.bottomPanel
    
    #append headers to panels
    _elmnts.leftPanel.appendChild _elmnts.leftPanelHeader
    _elmnts.rightPanel.appendChild _elmnts.rightPanelHeader
    
    #mouse position getters
    @getMouseX = -> document.mouseX - @get('main', 'offsetLeft') - @get('canvas', 'offsetLeft') - @get('canvas', 'width') / 2
    @getMouseY = -> document.mouseY - @get('main', 'offsetTop') - @get('canvas', 'offsetTop') - @get('canvas', 'height') / 2
    
    #generic element getter/setter
    @get = (elmnt, attr) ->
        _elmnts[elmnt][attr]
    @set = (elmnt, attr, what) ->
        if Object::toString.call(what) isnt '[object Object]'
            _elmnts[elmnt][attr] = what
        else
            _elmnts[elmnt][attr][key] = value for own key, value of what
    
    #set the style of each element
    @set 'main', 'style', _style.main
    @set 'title', 'style', _style.title
    @set 'leftPanel', 'style', _style.panel
    @set 'leftPanelHeader', 'style', _style.panelHeader
    @set 'canvas', 'style', _style.canvas
    @set 'rightPanel', 'style', _style.panel
    @set 'rightPanelHeader', 'style', _style.panelHeader
    @set 'bottomPanel', 'style', _style.footer
    
    #unique id for each button created
    _buttonID = 0
    
    #add button to one of the panels
    @addButton = (config = {}) ->
        #increment _buttonID
        _buttonID += 1
        
        #add environment defaults to config
        #if the user has chosen to omit them
        for own key, value of env.BUTTON_DEFAULT_CONFIG when key isnt 'style'
            config[key] ?= value
        for own key, value of env.BUTTON_DEFAULT_CONFIG.style
            config.style ?= {}
            config.style[key] ?= value
        
        #create element
        button = document.createElement 'button'
        
        #set values
        button.id = "gh-button-#{_buttonID}"
        button.setAttribute 'type', 'button'
        button.innerHTML = config.label
        button.onclick = config.onclick
        button.style[key] = value for own key, value of config.style
        
        #append to an element
        _elmnts[config.parent].appendChild button
    
    #start all asynchronous functions
    _startEverything = ->
        _masterID = setInterval _masterUpdate, 1000 / env.FRAME_RATE
        Sprites._startAll()
        return
    
    #used to keep engine from doing
    #unnessecary things more than once
    _firstTime = true
    
    #game control
    @start = =>
        if _firstTime
            #add engine to a user defined '#GREENHORN' div or the document body
            (document.querySelector('#GREENHORN') ? document.body).appendChild _elmnts.main
            
            #change the document body's backgroundColor
            _elmnts.main.parentNode.style.backgroundColor = env.ENGINE.backgroundColor
            
            #set the actual size of the canvas to prevent distortion
            correctWidth = @get 'canvas', 'offsetWidth'
            correctHeight = @get 'canvas', 'offsetHeight'
            @set 'canvas', 'width', correctWidth
            @set 'canvas', 'height', correctHeight
            
            #center the canvas origin point
            _elmnts.canvas.getContext('2d')
            .translate(
                _elmnts.canvas.width / 2,
                _elmnts.canvas.height / 2)
            
            #set the innerHTML of each element
            @set 'title', 'innerHTML', document.title
            @set 'leftPanelHeader', 'innerHTML', env.ENGINE.leftHeader
            @set 'rightPanelHeader', 'innerHTML', env.ENGINE.rightHeader
            @set 'bottomPanel', 'innerHTML', env.ENGINE.footer
            @set 'canvas', 'innerHTML', 'your browser does not support the <canvas> tag'
            
            #draw the start screen
            _ctx = _elmnts.canvas.getContext '2d'
            _ctx.save()
            _ctx.globalAlpha = 1.0
            _ctx.font = "#{env.STARTUP.size}px #{env.STARTUP.font}"
            _ctx.fillStyle = "#{env.ENGINE.foregroundColor}"
            _ctx.fillText(
                env.STARTUP.text,
                -_ctx.measureText(env.STARTUP.text).width / 2,
                env.STARTUP.size / 2)
            _ctx.restore()
            
            #make the entire canvas a button
            #that preloads all sounds and
            #launches all asynchronous updates
            _elmnts.canvas.onclick = ->
                Sounds._playAll()
                _startEverything()
                _elmnts.canvas.onclick = undefined
            
            #set _firstTime to false to avoid unnessecary
            #code being run if the game is stopped then restarted
            _firstTime = false
        
        else
            _startEverything()
    @stop = ->
        Sprites._stopAll()
        Sounds._stopAll()
        clearInterval _masterID
        _masterID = null
    @isRunning = ->
        _masterID?
    @clear = ->
        _elmnts.canvas.getContext('2d')
        .clearRect(
            -@get('canvas', 'width') / 2,
            -@get('canvas', 'height') / 2,
            @get('canvas', 'width'),
            @get('canvas', 'height'))
    @hide = ->
        @set 'main', 'style', {'display': 'none'}
    @show = ->
        @set 'main', 'style', {'display': 'inline-block'}
    @hideCursor = ->
        @set 'canvas', 'style', {'cursor': 'none'}
    @showCursor = ->
        @set 'canvas', 'style', {'cursor': 'default'}
#end class Greenhorn
