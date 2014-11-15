###
greenhorn.coffee
by Seth Bullock

***THE GREENHORN GAMING ENGINE***

primarily inspired by Andy Harris'
(aharrisbooks.net) simpleGame.js gaming engine
###

#anything attached to game
#is available outside the library
game = this

#enviorment variables
game.env =
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
    #default sound settings
    SOUND_PATH: ""
    SOUND_DEFAULT_URL: ""
    #default timer settings
    TIMER_START_ON_CONSTRUCTION: yes
    #default button settings
    BUTTON_DEFAULT_LABEL: "Launch the Missiles!"
    #default TextBox settings
    TEXTBOX_DEFAULT_TEXT: "This is a TextBox"
    TEXTBOX_DEFAULT_ALIGN: "center"
    TEXTBOX_DEFAULT_WIDTH: 50
    TEXTBOX_DEFAULT_HEIGHT: 50
    TEXTBOX_DEFAULT_X: 25
    TEXTBOX_DEFAULT_Y: 25
    TEXTBOX_DEFAULT_Z: -1
    #TextBox background settings
    TEXTBOX_BACKGROUND_COLOR: "black"
    TEXTBOX_BACKGROUND_ALPHA: 1.0
    TEXTBOX_BACKGROUND_VISIBLE: yes
    #TextBox border settings
    TEXTBOX_BORDER_SIZE: 5
    TEXTBOX_BORDER_COLOR: "white"
    TEXTBOX_BORDER_ALPHA: 1.0
    TEXTBOX_BORDER_VISIBLE: yes
    #TextBox font settings
    TEXTBOX_FONT_NAME: "Arial"
    TEXTBOX_FONT_SIZE: 8
    TEXTBOX_FONT_COLOR: "white"
    TEXTBOX_FONT_ALPHA: 1.0
    #TextBox margins settings
    TEXTBOX_MARGINS_TOP: 5
    TEXTBOX_MARGINS_BOTTOM: 5
    TEXTBOX_MARGINS_RIGHT: 5
    TEXTBOX_MARGINS_LEFT: 5

#generate a sort rule to determine
#in what order the sprites are drawn
makeSortRule = (sortBy, order) ->
    if order is "ascending"
        (sp1, sp2) ->
            sp1.get(sortBy) - sp2.get(sortBy)
    else if order is "decending"
        (sp1, sp2) ->
            sp2.get(sortBy) - sp1.get(sortBy)
    else
        throw new _GameError "order must be ascending or decending"

#keyboard value mapping object
game.KEYS =
    LEFT: 37, RIGHT: 39, UP: 38, DOWN: 40
    SPACE: 32, ESC: 27, PGUP: 33
    PGDOWN: 34, HOME: 36, END: 35
    _0: 48, _1: 49, _2: 50, _3: 51, _4: 52
    _5: 53, _6: 54, _7: 55, _8: 56, _9: 57
    A: 65,  B: 66, C: 67, D: 68, E: 69, F: 70
    G: 71, H: 72, I: 73, J: 74, K: 75, L: 76, M: 77
    N: 78, O: 79, P: 80, Q: 81, R: 82, S: 83
    T: 84, U: 85, V: 86, W: 87, X: 88, Y: 89, Z: 90

#Sprite boundaryAction enumeration
game.BOUND_ACTIONS =
    WRAP: 0
    BOUNCE: 1
    SEMIBOUNCE: 2
    STOP: 3
    DIE: 4
    CONTINUE: 5

#keyboard input tracking array
game.keysDown = (key = false for key in (new Array(256)))

#document event handlers
document.onkeydown = (e) ->
    e.preventDefault()
    keysDown[e.keyCode] = true
document.onkeyup = (e) ->
    e.preventDefault()
    keysDown[e.keyCode] = false
document.onmousemove = (e) ->
    @mouseX = e.pageX
    @mouseY = e.pageY

#audio context for webkit browsers
_webkitAudioContext = new webkitAudioContext?()

#integer ID used to start and stop _masterUpdate
_masterID = null

#handles all behind the scenes update tasks once per frame
_masterUpdate = ->
    #clear previous frame
    Greenhorn.clear()
    
    #call user's update
    #if one is defined
    update?()
    
    #update all Sprites
    Sprites._updateAll()
#end _masterUpdate

#exception class
class _GameError extends Error
    #constructor
    constructor: (@message) ->
        @name = "GameError"
        console.log @message
        return this
    
    #getter
    getName: -> @name
    getMessage: -> @message
    
    #setter
    setMessage: (@message) ->
#end class _GameError

#<canvas> tag wrapper class
class game.Greenhorn
    #create Engine elements
    @_elmnts =
        main: document.createElement "div"
        title: document.createElement "h2"
        leftPanel: document.createElement "div"
        canvas: document.createElement "canvas"
        rightPanel: document.createElement "div"
        bottomPanel: document.createElement "div"
    
    #append all children to @_main
    @_elmnts.main.appendChild @_elmnts.title
    @_elmnts.main.appendChild @_elmnts.leftPanel
    @_elmnts.main.appendChild @_elmnts.canvas
    @_elmnts.main.appendChild @_elmnts.rightPanel
    @_elmnts.main.appendChild @_elmnts.bottomPanel
    
    #mouse position
    @getMouseX = -> document.mouseX - @get("main", "offsetLeft") - @get("canvas", "offsetLeft") - @get("canvas", "width") / 2
    @getMouseY = -> document.mouseY - @get("main", "offsetTop") - @get("canvas", "offsetTop") - @get("canvas", "height") / 2
    
    #generic element getter/setter
    @get = (elmnt, attr) ->
        if attr
            @_elmnts[elmnt][attr]
        else
            @_elmnts[elmnt]
    @set = (elmnt, attr, what) ->
        if Object::toString.call(what) is '[object Object]'
            @_elmnts[elmnt][attr][key] = value for key, value of what
        else
            @_elmnts[elmnt][attr] = what
    
    #add button to one of the panels
    @addButton = (where, label = env.BUTTON_DEFAULT_LABEL, style = {}, whenClicked = =>) ->
        button = document.createElement "button"
        button.setAttribute "type", "button"
        button.innerHTML = label
        button.style[key] = value for key, value of style
        button.onclick = whenClicked
        @_elmnts[where].appendChild button
    
    #game control
    @start = ->
        #change the document body's backgroundColor
        document.body.bgColor = env.BODY_BACKGROUND_COLOR
        #add engine to document body
        document.body.appendChild @_elmnts.main
        
        #basic style formatting for elements
        mainStyle =
            width: "100%"
            display: "inline-block"
            backgroundColor: env.ENGINE_BACKGROUND_COLOR
        titleStyle =
            textAlign: "center"
            cssFloat: "left"
            display: "initial"
            marginTop: "1%"
            marginBottom: "1%"
            backgroundColor: "inherit"
            minWidth: "100%"
            minHeight: "6%"
            maxWidth: "100%"
            maxHeight: "6%"
        leftPanelStyle =
            minWidth: "15%"
            minHeight: "80%"
            maxWidth: "15%"
            maxHeight: "80%"
            cssFloat: "left"
            display: "initial"
            marginLeft: "1%"
            marginRight: "1%"
            overflow: "auto"
            whiteSpace: "pre"
            backgroundColor: "inherit"
        canvasStyle =
            minWidth: "66%"
            minHeight: "80%"
            maxWidth: "66%"
            maxHeight: "80%"
            display: "initial"
            cssFloat: "left"
            backgroundColor: env.ENGINE_CANVAS_COLOR
        rightPanelStyle =
            minWidth: "15%"
            minHeight: "80%"
            maxWidth: "15%"
            maxHeight: "80%"
            display: "initial"
            cssFloat: "left"
            marginLeft: "1%"
            marginRight: "1%"
            overflow: "auto"
            whiteSpace: "pre"
            backgroundColor: "inherit"
        bottomPanelStyle =
            minWidth: "100%"
            minHeight: "10%"
            maxWidth: "100%"
            maxHeight: "10%"
            display: "initial"
            textAlign: "center"
            cssFloat: "left"
            marginTop: "1%"
            marginBottom: "1%"
            backgroundColor: "inherit"
        
        #set the style of each element
        @set "main", "style", mainStyle
        @set "title", "style", titleStyle
        @set "leftPanel", "style", leftPanelStyle
        @set "canvas", "style", canvasStyle
        @set "rightPanel", "style", rightPanelStyle
        @set "bottomPanel", "style", bottomPanelStyle
        
        #set the actual size of the canvas to prevent distortion
        correctWidth = @get "canvas", "offsetWidth"
        correctHeight = @get "canvas", "offsetHeight"
        @set "canvas", "width", correctWidth
        @set "canvas", "height", correctHeight
        
        #center the canvas origin point
        @_elmnts.canvas.getContext("2d").translate(@get("canvas", "width") / 2, @get("canvas", "height") / 2)
        
        #set the innerHTML of each element
        @set "title", "innerHTML", env.ENGINE_TITLE
        @set "leftPanel", "innerHTML", env.ENGINE_LEFT_PANEL
        @set "rightPanel", "innerHTML", env.ENGINE_RIGHT_PANEL
        @set "bottomPanel", "innerHTML", env.ENGINE_BOTTOM_PANEL
        @set "canvas", "innerHTML", env.ENGINE_CANVAS_ERROR
        
        #start running _masterUpdate at env.FRAME_RATE frames/sec
        _masterID = setInterval _masterUpdate, Math.ceil 1000 / env.FRAME_RATE
        return
    @stop = ->
        clearInterval _masterID
    @clear = ->
        @_elmnts.canvas.getContext("2d").clearRect(-@get("canvas", "width") / 2, -@get("canvas", "height") / 2, @get("canvas", "width"), @get("canvas", "height"))
    @hide = ->
        set "main", "style", {"display": "none"}
    @show = ->
        set "main", "style", {"display": "inline-block"}
    @hideCursor = ->
        set "canvas", "style", {"cursor": "none"}
    @showCursor = ->
        set "canvas", "style", {"cursor": "default"}
#end class Greenhorn

#core engine class
class game.Sprite
    #<---CLASS-LEVEL--->
    #state values
    _list = []
    _sortRule = makeSortRule "z", "ascending"
    
    #Sprite class methods
    @howMany = -> _list.length
    @_updateAll = -> sp._update() for sp in _list
    #@sortBy = (@_sortRule) -> @resort()
    
    #collective manipulation
    @getAll = (what, excep...) ->
        sp.get what for sp in _list when sp not in excep
    @setAll = (what, to, excep...) ->
        sp.set what, to for sp in _list when sp not in excep
    @changeAll = (what, step, excep...) ->
        sp.change what, step for sp in _list when sp not in excep
    
    #<---INSTANCE-LEVEL--->
    #constructor
    constructor: (config = {}) ->
        forbidden = [
            "display"
            "position"
            "motion"
            "acceleration"
            "config"
            "distance"
            "speed"
            "rate"
            "posAngle"
            "motAngle"
            "accAngle"
        ]#end forbidden config words
        
        #throw an error if a forbidden key is provided in the configuration
        throw new _GameError "#{key} is a forbidden config value" for key in forbidden when config[key]?
        
        #create primary objects
        @_dis = {}
        @_pos = {}
        @_mot = {}
        @_acc = {}
        @_borders = {}
        
        #get the context used to draw sprite
        @_dis.context = Greenhorn._elmnts.canvas.getContext "2d"
        
        #add the environment defaults to config,
        #if the user has chosen to omit them
        for key, value of env.SPRITE_DEFAULT_CONFIG
            config[key] ?= value
        
        #push this instance to the Sprite list
        _list.push @
        
        #set this sprite's configuration
        @set "config", config
    
    #getter
    get: (what) ->
        switch what
            when "display"
                @_dis
            when "position"
                @_pos
            when "motion"
                @_mot
            when "acceleration"
                @_acc
            when "borders"
                @_borders
            when "imageFile"
                @_dis.image.src
            when "width", "height", "visible", "boundAction"
                @_dis[what]
            when "x", "y", "z", "a"
                @_pos[what]
            when "dx", "dy", "dz", "da"
                @_mot[what]
            when "ddx", "ddy", "ddz", "dda"
                @_acc[what]
            when "top", "bottom", "right", "left"
                @_borders[what]
            when "distance"
                Math.sqrt @_pos.x**2 + @_pos.y**2
            when "speed"
                Math.sqrt @_mot.dx**2 + @_mot.dy**2
            when "rate"
                Math.sqrt @_acc.ddx**2 + @_acc.ddy**2
            when "posAngle"
                Math.atan2 @_pos.y, @_pos.x
            when "motAngle"
                Math.atan2 @_mot.dy, @_mot.dx
            when "accAngle"
                Math.atan2 @_acc.ddy, @_acc.ddx
            else
                throw new _GameError "#{what} is not a get-able Sprite attribute"
    
    #setter
    set: (what, to) ->
        switch what
            when "display", "position", "motion", "acceleration", "config"
                @set k, v for k, v of to
            when "imageFile"
                @_dis.image ?= new Image()
                @_dis.image.src = env.IMAGE_PATH.concat to
            when "boundAction"
                @_dis.boundAction = BOUND_ACTIONS[to]
            when "width", "height", "visible"
                @_dis[what] = to
                @_calcBorders() if what is "width" or what is "height"
            when "x", "y", "z", "a"
                @_pos[what] = to
                @_calcBorders() if what is "x" or what is "y"
                _list.sort _sortRule if what is "z"
            when "dx", "dy", "dz", "da"
                @_mot[what] = to
            when "ddx", "ddy", "ddz", "dda"
                @_acc[what] = to
            when "distance"
                proxy =
                    x: to * Math.cos @get "posAngle"
                    y: to * Math.sin @get "posAngle"
                @set "position", proxy
            when "speed"
                proxy =
                    dx: to * Math.cos @get "motAngle"
                    dy: to * Math.sin @get "motAngle"
                @set "motion", proxy
            when "rate"
                proxy =
                    ddx: to * Math.cos @get "accAngle"
                    ddy: to * Math.sin @get "accAngle"
                @set "acceleration", proxy
            when "posAngle"
                proxy =
                    x: @get("distance") * Math.cos to
                    y: @get("distance") * Math.sin to
                @set "position", proxy
            when "motAngle"
                proxy =
                    dx: @get("speed") * Math.cos to
                    dy: @get("speed") * Math.sin to
                @set "motion", proxy
            when "accAngle"
                proxy =
                    ddx: @get("rate") * Math.cos to
                    ddy: @get("rate") * Math.sin to
                @set "acceleration", proxy
            else
                throw new _GameError "#{what} is not a set-able Sprite attribute"
        this
    
    #changer
    change: (what, step) ->
        switch what
            when "display", "position", "motion", "acceleration"
                @change k.slice(1), v for k, v of step
            when "width", "height"
                @_dis[what] += step
                @_calcBorders()
            when "x", "y", "z", "a"
                @_pos[what] += step / env.FRAME_RATE
                @_calcBorders() if what is "x" or what is "y"
                _list.sort _sortRule if what is "z"
            when "dx", "dy", "dz", "da"
                @_mot[what] += step / env.FRAME_RATE
            when "ddx", "ddy", "ddz", "dda"
                @_acc[what] += step / env.FRAME_RATE
            when "distance"
                proxy =
                    dx: step * Math.cos @get "posAngle"
                    dy: step * Math.sin @get "posAngle"
                @change "position", proxy
            when "speed"
                proxy =
                    ddx: step * Math.cos @get "motAngle"
                    ddy: step * Math.sin @get "motAngle"
                @change "motion", proxy
            when "rate"
                proxy =
                    dddx: step * Math.cos @get "accAngle"
                    dddy: step * Math.sin @get "accAngle"
                @change "acceleration", proxy
            when "posAngle"
                proxy =
                    dx: @get("distance") * Math.cos step
                    dy: @get("distance") * Math.sin step
                @change "position", proxy
            when "motAngle"
                proxy =
                    ddx: @get("speed") * Math.cos step
                    ddy: @get("speed") * Math.sin step
                @change "motion", proxy
            when "accAngle"
                proxy =
                    dddx: @get("rate") * Math.cos step
                    dddy: @get("rate") * Math.sin step
                @change "acceleration", proxy
            else
                throw new _GameError "#{what} is not a change-able Sprite attribute"
        this
    
    #collision routines
    collidesWith: (other) ->
        collision = true
        if @_dis.visible and other._dis.visible and @_pos.z == other.get "z"
            if @_borders.bottom > other._borders.top or
            @_borders.top < other._borders.bottom or
            @_borders.right < other._borders.left or
            @_borders.left > other._borders.right
                collision = false
        else collision = false
        collision
    collidesWithMouse: ->
        collision = false
        if @_dis.visible
            if @_borders.left < Greenhorn.getMouseX() < @_borders.right and
            @_borders.bottom < Greenhorn.getMouseY() < @_borders.top
                collision = true
        collision
    distanceTo: (other) ->
        Math.sqrt (@_pos.x - other.get("x"))**2 + (@_pos.y - other.get("y"))**2
    distanceToMouse: ->
        Math.sqrt (@_pos.x - Greenhorn.getMouseX())**2 + (@_pos.y - Greenhorn.getMouseY())**2
    angleTo: (other) ->
        -Math.atan2 other.get("y") - @_pos.y, other.get("x") - @_pos.x
    angleToMouse: ->
        -Math.atan2 Greenhorn.getMouseY() - @_pos.y, Greenhorn.getMouseX() - @_pos.x
    
    #internal adjustments
    _calcBorders: () ->
        @_borders.left = @_pos.x - @_dis.width / 2
        @_borders.right = @_pos.x + @_dis.width / 2
        @_borders.top = @_pos.y + @_dis.height / 2
        @_borders.bottom = @_pos.y - @_dis.height / 2
    
    #update routines
    _draw: ->
        @_dis.context.save()
        @_dis.context.translate @_pos.x, -@_pos.y
        @_dis.context.rotate @_pos.a
        @_dis.context.drawImage @_dis.image, 0 - @_dis.width / 2, 0 - @_dis.height / 2, @_dis.width, @_dis.height
        @_dis.context.restore()
    _checkBounds: ->
        #canvas boundaries
        bounds =
            top: Greenhorn.get("canvas", "height") / 2
            left: -Greenhorn.get("canvas", "width") / 2
            bottom: -Greenhorn.get("canvas", "height") / 2
            right: Greenhorn.get("canvas", "width") / 2
        
        #sprite has completely disappeared offscreen
        offLeft = @_borders.right < bounds.left
        offTop = @_borders.bottom > bounds.top
        offRight = @_borders.left > bounds.right
        offBottom = @_borders.top < bounds.bottom
        
        #sprite has just come into contact with a boundary
        hitLeft = @_borders.left <= bounds.left
        hitTop = @_borders.top >= bounds.top
        hitRight = @_borders.right >= bounds.right
        hitBottom = @_borders.bottom <= bounds.bottom
        
        switch @_dis.boundAction
            when BOUND_ACTIONS.WRAP
                if offLeft
                    @set "x", bounds.right + @_dis.width / 2
                if offTop
                    @set "y", bounds.bottom - @_dis.height / 2
                if offRight
                    @set "x", bounds.left - @_dis.width / 2
                if offBottom
                    @set "y", bounds.top + @_dis.height / 2
            when BOUND_ACTIONS.BOUNCE
                if hitTop
                    @set "y", bounds.top - @_dis.height / 2
                    @_mot.dy *= -1
                if hitBottom
                    @set "y", bounds.bottom + @_dis.height / 2
                    @_mot.dy *= -1
                if hitLeft
                    @set "x", bounds.left + @_dis.width / 2
                    @_mot.dx *= -1
                if hitRight
                    @set "x", bounds.right - @_dis.width / 2
                    @_mot.dx *= -1
            when BOUND_ACTIONS.SEMIBOUNCE
                if hitTop
                    @set "y", bounds.top - @_dis.height / 2
                    @_mot.dy *= -.75
                if hitBottom
                    @set "y", bounds.bottom + @_dis.height / 2
                    @_mot.dy *= -.75
                if hitLeft
                    @set "x", bounds.left + @_dis.width / 2
                    @_mot.dx *= -.75
                if hitRight
                    @set "x", bounds.right - @_dis.width / 2
                    @_mot.dx *= -.75
            when BOUND_ACTIONS.STOP
                if hitLeft or hitTop or hitRight or hitBottom
                    @_mot.dx = 0
                    @_mot.dy = 0
                    @_acc.ddx = 0
                    @_acc.ddy = 0
                    
                    if hitTop
                        @set "y", bounds.top - @_dis.height / 2
                    if hitBottom
                        @set "y", bounds.bottom + @_dis.height / 2
                    if hitLeft
                        @set "x", bounds.left + @_dis.width / 2
                    if hitRight
                        @set "x", bounds.right - @_dis.width / 2
            when BOUND_ACTIONS.DIE
                if offLeft or offTop or offRight or offBottom
                    @_dis.visible = no
        @_dis.boundAction
    _update: ->
        if @_dis.visible
            @change "motion", @_acc
            @change "position", @_mot
            @_checkBounds()
            @_draw()
        this
    
    #debugging
    report: ->
        """
        display:
            width: #{@_dis.width}
            height: #{@_dis.height}
            visible: #{@_dis.visible}
            boundAction: #{@_dis.boundAction}
        position:
            x: #{@_pos.x.toFixed 3}
            y: #{@_pos.y.toFixed 3}
            z: #{@_pos.z.toFixed 3}
            a: #{@_pos.a.toFixed 3}
        motion:
            dx: #{@_mot.dx.toFixed 3}
            dy: #{@_mot.dy.toFixed 3}
            dz: #{@_mot.dz.toFixed 3}
            da: #{@_mot.da.toFixed 3}
        acceleration:
            ddx: #{@_acc.ddx.toFixed 3}
            ddy: #{@_acc.ddy.toFixed 3}
            ddz: #{@_acc.ddz.toFixed 3}
            dda: #{@_acc.dda.toFixed 3}
        """
    log: ->
        console?.log @report()
        return
#end class Sprite

#more natural alias when calling class methods
game.Sprites = game.Sprite

#simple sound class
class game.Sound
    #constructor
    constructor: (url = env.SOUND_DEFAULT_URL) ->
        #instance variable
        @_url = env.SOUND_PATH.concat url
        
        if webkitAudioContext?
            #webkit instance variables
            @_source = _webkitAudioContext.createBufferSource()
            @_gainNode = _webkitAudioContext.createGainNode()
            
            #request setup
            request = new XMLHttpRequest()
            request.responseType = 'arraybuffer'
            request.open 'GET', @_url, true
            
            #request event handlers
            request.successCallback = (buffer) =>
                @_source.buffer = buffer
                @_source.connect @_gainNode
                @_gainNode.connect _webkitAudioContext.destination
                return
            request.failureCallback = ->
                throw new _GameError "Webkit Sound Error"
            request.onload = ->
                _webkitAudioContext.decodeAudioData @response, @successCallback, @failureCallback
            
            #send request
            request.send()
        
        else
            #non-webkit instance variable
            @_audio = document.createElement 'audio'
            @_audio.setAttribute 'controls', 'none'
            @_audio.style.display = 'none'
            
            #_audio sources
            mp3_src = document.createElement 'source'
            ogg_src = document.createElement 'source'
            wav_src = document.createElement 'source'
            
            mp3_src.type = 'audio/mpeg'
            ogg_src.type = 'audio/ogg'
            wav_src.type = 'audio/wav'
            
            #determine source extension
            if @_url.indexOf('.mp3') isnt -1
                mp3_src.src = @_url
                ogg_src.src = @_url.replace '.mp3', '.ogg'
                wav_src.src = @_url.replace '.mp3', '.wav'
            else if @_url.indexOf('.ogg') isnt -1
                ogg_src.src = @_url
                mp3_src.src = @_url.replace '.ogg', '.mp3'
                wav_src.src = @_url.replace '.ogg', '.wav'
            else if @_url.indexOf('.wav') isnt -1
                wav_src.src = @_url
                mp3_src.src = @_url.replace '.wav', '.mp3'
                ogg_src.src = @_url.replace '.wav', '.ogg'
            else throw new _GameError "Sound url must be .mp3, .ogg, or .wav extension"
            
            #append sources to audio tag
            @_audio.appendChild mp3_src
            @_audio.appendChild ogg_src
            @_audio.appendChild wav_src
            
            #append audio tag to document body
            Greenhorn._elmnts.canvas.appendChild @_audio
        return
    
    #sound control
    play: (opt = {}) ->
        if webkitAudioContext?
            @_gainNode.gain.value = opt.gainValue if opt.gainValue?
            @_source.loop = opt.loop if opt.loop?
            @_source.start 0
        else
            @_audio.loop = opt.loop if opt.loop?
            @_audio.play()
        return
    stop: ->
        if webkitAudioContext?
            @_source.stop 0
        else
            @_audio.pause()
            @_audio.currentTime = 0
        return
#end class Sound

#simple timer class
class game.Timer
    #constructor
    constructor: (start_now = env.TIMER_START_ON_CONSTRUCTION) ->
        @_elapsedTime = 0
        @_startTime = if start_now then @getCurrentTime() else null
        return this
    
    #getters
    getStartTime: -> @_startTime
    getCurrentTime: -> (new Date()).getTime()
    getElapsedTime: ->
        unless @_startTime
            @_elapsedTime
        else
            @_elapsedTime + @getCurrentTime() - @_startTime
    
    #timer control
    start: ->
        unless @_startTime
            @_startTime = @getCurrentTime()
            return
    pause: ->
        if @_startTime
            @_elapsedTime += @getCurrentTime() - @getStartTime()
            @_startTime = null
            return
    restart: ->
        @_elapsedTime = 0
        @_startTime = @getCurrentTime()
        return
    stop: ->
        @_elapsedTime = 0
        @_startTime = null
        return
#end class Timer

#simple button class
#NOTE TO SELF:
#needs serious remodel
class game.Button
    #constructor
    constructor: (label = env.BUTTON_DEFAULT_LABEL) ->
        #instance variables
        @_clicked = false
        @_button = document.createElement "button"
        
        #button setup
        @_button.innerHTML = label
        @_button.setAttribute "type", "button"
        
        #button event handlers
        @_button.onmousedown = =>
            @_clicked = true
            return
        @_button.onmouseup = =>
            @_clicked = false
            return
        
        #add button to document
        document.body.appendChild @_button
        return this
    
    #getters
    isClicked: -> @_clicked
#end class GameButton

#simple textbox
class game.TextBox extends Sprite
    #constructor
    constructor: (text = env.TEXTBOX_DEFAULT_TEXT, config = {}) ->
        #adjust the configuration if nesseccary
        config.imageFile = ""
        config.width ?= env.TEXTBOX_DEFAULT_WIDTH
        config.height ?= env.TEXTBOX_DEFAULT_HEIGHT
        config.x ?= env.TEXTBOX_DEFAULT_X
        config.y ?= env.TEXTBOX_DEFAULT_Y
        config.z ?= env.TEXTBOX_DEFAULT_Z
        
        #call Sprite constructor
        super config
        
        #instance variables
        @_text = text.split '\n'
        #background object
        @_background =
            color: config.backgroundColor ? env.TEXTBOX_BACKGROUND_COLOR
            alpha: config.backgroundAlpah ? env.TEXTBOX_BACKGROUND_ALPHA
            visible: config.backgroundVisible ? env.TEXTBOX_BACKGROUND_VISIBLE
        #border object
        @_border =
            size: config.borderSize ? env.TEXTBOX_BORDER_SIZE
            color: config.borderColor ? env.TEXTBOX_BORDER_COLOR
            alpha: config.borderAlpha ? env.TEXTBOX_BORDER_ALPHA
            visible: config.borderVisible ? env.TEXTBOX_BORDER_VISIBLE
        #font object
        @_font =
            name: config.fontName ? env.TEXTBOX_FONT_NAME
            size: config.fontSize ? env.TEXTBOX_FONT_SIZE
            color: config.fontColor ? env.TEXTBOX_FONT_COLOR
            alpha: config.fontAlpha ? env.TEXTBOX_FONT_ALPHA
        #margins object
        @_margins =
            top: config.marginsTop ? env.TEXTBOX_MARGINS_TOP
            bottom: config.marginsBottom ? env.TEXTBOX_MARGINS_BOTTOM
            right: config.marginsRight ? env.TEXTBOX_MARGINS_RIGHT
            left: config.marginsLeft ? env.TEXTBOX_MARGINS_LEFT
        
        #initialize TextBox
        @_dis.context.textAlign = config.textAlign ? env.TEXTBOX_DEFAULT_ALIGN
        @_fitText()
        return this
    
    #getters
    getText: -> @_text.join '\n'
    getAlign: -> @_dis.context.textAlign
    getBackground: -> @_background
    getBorder: -> @_border
    getFont: -> @_font
    getMargins: -> @_margins
    
    #setters
    setText: (new_text) ->
        @_text = new_text.split '\n'
        @_fitText()
        return
    setAlign: (new_align) ->
        @_dis.context.textAlign = new_align
        return
    setBackground: (new_background) ->
        @_background.color = new_background.color?
        @_background.alpha = new_background.alpha?
        @_background.visible = new_background.visible?
        return
    setBorder: (new_border) ->
        @_border.size = new_border.size?
        @_border.color = new_border.color?
        @_border.alpha = new_border.alpha?
        @_border.visible = new_border.visible?
        @_fitText()
        return
    setFont: (new_font) ->
        @_font.name = new_font.name?
        @_font.size = new_font.size?
        @_font.color = new_font.color?
        @_font.alpha = new_font.alpha?
        @_fitText()
        return
    setMargins: (new_margins) ->
        @_margins.top = new_margins.top?
        @_margins.bottom = new_margins.bottom?
        @_margins.right = new_margins.right?
        @_margins.left = new_margins.left?
        @_fitText()
        return
    
    #style control
    showBackground: ->
        @_background.visible = yes
        return
    hideBackground: ->
        @_background.visible = no
        return
    showBorder: ->
        @_border.visible = yes
        @_fitText()
        return
    hideBorder: ->
        @_border.visible = no
        @_fitText()
        return
    
    #internal control
    _fitText: ->
        #preserve old data
        old_width = @_dis.width
        old_height = @_dis.height
        
        #calculate new values
        @_dis.width = 0
        @_dis.height = (@_font.size * @_text.length) + ((@_font.size // 3) * (@_text.length - 1))
        for line in @_text
            len = @_dis.context.measureText line.width
            @_dis.width = len if @_dis.width < len
        
        #adjust for margins and border
        @_dis.width += @_margins.left + @_margins.right
        @_dis.height += @_margins.top + @_margins.bottom
        if @_border.visible
            @_dis.width += 2 * @_border.size
            @_dis.height += 2 * @_border.size
        
        #keep coordinate (top, left) in same position
        if @_dis.width < old_width then @changeXby(-Math.abs(@_dis.width - old_width) / 2)
        else @changeXby(Math.abs(@_dis.width - old_width) / 2)
        if @_dis.height < old_height then @changeYby(-Math.abs(@_dis.height - old_height) / 2)
        else @changeYby(Math.abs(@_dis.height - old_height) / 2)
        
        return
    _writeText: ->
        #calculate offset
        xOffset = @_margins.left
        yOffset = @_margins.top
        if @_border.visible
            xOffset += @_border.size
            yOffset += @_border.size
        
        #initialize context
        @_dis.context._font = "#{@_font.size}px #{@_font.name}"
        @_dis.context.fillStyle = @_font.color
        @_dis.context.globalAlpha = @_font.alpha
        
        #draw text on canvas
        if @_text.length > 1
            for line, i in @_text
                @_dis.context.fillText line,
                @_pos.x + xOffset - (@_dis.width / 2),
                @_pos.y + yOffset - (@_dis.height / 2) + (@_font.size * i) + ((@_font.size // 3) if i isnt 0)
        else
            @_dis.context.fillText @_text[0], @_pos.x + xOffset - (@_dis.width / 2), @_pos.y + yOffset - (@_dis.height / 2)
        return
    _draw: ->
        #save current context
        @_dis.context.save()
        
        #draw background
        if @_background.visible
            @_dis.context.fillStyle = @_background.color
            @_dis.context.globalAlpha = @_background.alpha
            @_dis.context.fillRect @_pos.x - @_dis.width / 2, @_pos.y - @_dis.height / 2, @_dis.width, @_dis.height
        
        #draw borders
        if @_border.visible
            @_dis.context.strokeStyle = @_border.color
            @_dis.context.lineWidth = @_border.size
            @_dis.context.globalAlpha = @_border.alpha
            @_dis.context.strokeRect @_pos.x - (@_dis.width / 2), @_pos.y - (@_dis.height / 2), @_dis.width, @_dis.height
        
        #draw text
        @_writeText()
        
        #restore old context
        @_dis.context.restore()
        return
#end class TextBox