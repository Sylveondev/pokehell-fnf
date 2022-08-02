local defaultNotePos = {};
local DefaultUiPos = {};
local hasreset = false
local somerandom

function onCreate()
    if getPropertyFromClass('ClientPrefs','windowMove') then
	    --setPropertyFromClass('openfl.Lib','application.window.width', 480)
        --setPropertyFromClass('openfl.Lib','application.window.height', 480 / 2)	
    end
end
function onCreatePost()
    if getPropertyFromClass('ClientPrefs','windowMove') then
	--setPropertyFromClass('openfl.Lib','application.window.x', 1280 / 2)
    --setPropertyFromClass('openfl.Lib','application.window.y', 720 / 2)
    end
end
function onDestroy()
    if getPropertyFromClass('ClientPrefs','windowMove') then
	    setPropertyFromClass('openfl.Lib','application.window.width', 1280)
        setPropertyFromClass('openfl.Lib','application.window.height', 720)		
	    setPropertyFromClass('openfl.Lib','application.window.x', 10)
        setPropertyFromClass('openfl.Lib','application.window.y', 20)
    end
end

function onSongStart()

    for i = 0,7 do
 
        x = getPropertyFromGroup('strumLineNotes', i, 'x')
 
        y = getPropertyFromGroup('strumLineNotes', i, 'y')
 
        table.insert(defaultNotePos, {x, y})
 
        --debugPrint("{" .. x .. "," .. y .. "}" .. "i:" .. i)
    end

    table.insert(DefaultUiPos, {getProperty('boyfriend.x'), getProperty('boyfriend.y')})
    table.insert(DefaultUiPos, {getProperty('gf.x'), getProperty('gf.y')})
    table.insert(DefaultUiPos, {getProperty('dad.x'), getProperty('dad.y')})
    table.insert(DefaultUiPos, {getProperty('scoretable.x'), getProperty('scoretable.y')})
    table.insert(DefaultUiPos, {getProperty('healthBar.x'), getProperty('healthBar.y')})
    table.insert(DefaultUiPos, {getProperty('timeBar.x'), getProperty('timeBar.y')})
    table.insert(DefaultUiPos, {getProperty('scoreTxt.x'), getProperty('scoreTxt.y')})
    table.insert(DefaultUiPos, {getProperty('iconP1.x'), getProperty('iconP1.y')})
    table.insert(DefaultUiPos, {getProperty('iconP2.x'), getProperty('iconP2.y')})

end

function opponentNoteHit()
    triggerEvent('Screen Shake', '0.1, 0.01', '0.1, 0.01');
    triggerEvent('Add Camera Zoom', '0.025', '0.025');
    if curBeat >= 128 and curBeat <= 191 then
        somerandom = math.random(1, 3)
		if somerandom == 3 and getPropertyFromClass('ClientPrefs','windowMove') then
			the = math.random(16, 720)
			setPropertyFromClass('openfl.Lib','application.window.width', the)
    		setPropertyFromClass('openfl.Lib','application.window.height', the / 2)
			
			setPropertyFromClass('openfl.Lib','application.window.x', math.random(0,1280 - the))
    		setPropertyFromClass('openfl.Lib','application.window.y', math.random(0,720 - (the / 2)))
		elseif somerandom == 2 then
			for i = 0,7 do 
                setPropertyFromGroup('strumLineNotes', i, 'x', math.random(280, 1000))
                setPropertyFromGroup('strumLineNotes', i, 'y', math.random(180, 540))
                setPropertyFromGroup('strumLineNotes', i, 'angle', math.random(-360, 360))
                setPropertyFromGroup('strumLineNotes', i, 'alpha', math.random(0.25, 1))
            end
		elseif somerandom == 1 then
            	setProperty('scoretable.x',  math.random(280, 1000))
                setProperty('scoretable.y',  math.random(180, 540))
                setProperty('scoretable.angle',  math.random(-360, 360))
                setProperty('scoretable.alpha', math.random(0.25, 1))
                setProperty('timeBar.x',  math.random(280, 1000))
                setProperty('timeBar.y',  math.random(180, 540))
                setProperty('timeBar.angle',  math.random(-360, 360))
                setProperty('timeBar.alpha', math.random(0.25, 1))
                setProperty('healthBar.x',  math.random(280, 1000))
                setProperty('healthBar.y',  math.random(180, 540))
                setProperty('healthBar.angle',  math.random(-360, 360))
                setProperty('healthBar.alpha', math.random(0.25, 1))
                setProperty('scoreTxt.x',  math.random(280, 1000))
                setProperty('scoreTxt.y',  math.random(180, 540))
                setProperty('scoreTxt.angle',  math.random(-360, 360))
                setProperty('scoreTxt.alpha', math.random(0.25, 1))
                setProperty('iconP1.x',  math.random(280, 1000))
                setProperty('iconP1.y',  math.random(180, 540))
                setProperty('iconP1.alpha', math.random(0.25, 1))
                setProperty('iconP2.x',  math.random(280, 1000))
                setProperty('iconP2.y',  math.random(180, 540))
                setProperty('iconP2.alpha', math.random(0.25, 1))
                
                setProperty('boyfriend.x',  math.random(280, 1000))
                setProperty('boyfriend.y',  math.random(180, 540))
                setProperty('boyfriend.angle',  math.random(-360, 360))
                setProperty('boyfriend.alpha', math.random(0.25, 1))

				setProperty('gf.x',  math.random(280, 1000))
                setProperty('gf.y',  math.random(180, 540))
                setProperty('gf.angle',  math.random(-360, 360))
                setProperty('gf.alpha', math.random(0.25, 1))

                setProperty('dad.x',  math.random(280, 1000))
                setProperty('dad.y',  math.random(180, 540))
                setProperty('dad.angle',  math.random(-360, 360))
                setProperty('dad.alpha', math.random(0.25, 1))

                setProperty('CamHUD.angle',  math.random(-30, 30))
                setProperty('camera.angle',  math.random(-30, 30))
        end
    elseif curBeat >= 200 and hasreset == false then
        hasreset = true
        doTweenAngle('tweenA','CamHUD',0, 5, 'CircInOut')
        doTweenAngle('tweenB','camera',0, 5, 'CircInOut')

        for i = 0,7 do
            noteTweenX('notetweena'..i, i , defaultNotePos[i + 1][1], 5, 'circInOut');
            noteTweenY('notetweenb'..i, i , defaultNotePos[i + 1][2], 5, 'circInOut');
            noteTweenAngle('noteangle'..i, i , 0, 5, 'circInOut');
            noteTweenAlpha('notealpha'..i, i , 1, 5, 'circInOut');
        end

        doTweenAngle('tweenC','dad', 0, 5, 'CircInOut')
        doTweenAlpha('tweenD','dad', 1, 5, 'CircInOut')
        doTweenX('tweenE','dad', DefaultUiPos[3][1], 5, 'CircInOut')
        doTweenY('tweenF','dad', DefaultUiPos[3][2], 5, 'CircInOut')

        doTweenAngle('tweenG','boyfriend', 0, 5, 'CircInOut')
        doTweenAlpha('tweenH','boyfriend', 1, 5, 'CircInOut')
        doTweenX('tweenI','boyfriend', DefaultUiPos[1][1], 5, 'CircInOut')
        doTweenY('tweenJ','boyfriend', DefaultUiPos[1][2], 5, 'CircInOut')

        doTweenAngle('tweenK','gf', 0, 5, 'CircInOut')
        doTweenAlpha('tweenL','gf', 1, 5, 'CircInOut')
        doTweenX('tweenM','gf', DefaultUiPos[2][1], 5, 'CircInOut')
        doTweenY('tweenN','gf', DefaultUiPos[2][2], 5, 'CircInOut')

        doTweenAngle('tweenO','scoretable', 0, 5, 'CircInOut')
        doTweenAlpha('tweenP','scoretable', 1, 5, 'CircInOut')
        doTweenX('tweenQ','scoretable', DefaultUiPos[4][1] + 104, 5, 'CircInOut')
        doTweenY('tweenR','scoretable', DefaultUiPos[4][2], 5, 'CircInOut')

        doTweenAngle('tweenS','healthBar', 0, 5, 'CircInOut')
        doTweenAlpha('tweenT','healthBar', 1, 5, 'CircInOut')
        doTweenX('tweenU','healthBar', DefaultUiPos[5][1], 5, 'CircInOut')
        doTweenY('tweenV','healthBar', DefaultUiPos[5][2], 5, 'CircInOut')

        doTweenAngle('tweenW','timeBar', 0, 5, 'CircInOut')
        doTweenAlpha('tweenX','timeBar', 1, 5, 'CircInOut')
        doTweenX('tweenY','timeBar', DefaultUiPos[6][1], 5, 'CircInOut')
        doTweenY('tweenZ','timeBar', DefaultUiPos[6][2], 5, 'CircInOut')

        doTweenAngle('tweenAA','scoreTxt', 0, 5, 'CircInOut')
        doTweenAlpha('tweenAB','scoreTxt', 1, 5, 'CircInOut')
        doTweenX('tweenAC','scoreTxt', DefaultUiPos[7][1], 5, 'CircInOut')
        doTweenY('tweenAD','scoreTxt', DefaultUiPos[7][2], 5, 'CircInOut')

        doTweenAngle('tweenAE','iconP1', 0, 5, 'CircInOut')
        doTweenAlpha('tweenAF','iconP1', 1, 5, 'CircInOut')
        doTweenX('tweenAG','iconP1', DefaultUiPos[8][1], 5, 'CircInOut')
        doTweenY('tweenAH','iconP1', DefaultUiPos[8][2], 5, 'CircInOut')

        doTweenAngle('tweenAI','iconP2', 0, 5, 'CircInOut')
        doTweenAlpha('tweenAJ','iconP2', 1, 5, 'CircInOut')
        doTweenX('tweenAK','iconP2', DefaultUiPos[9][1], 5, 'CircInOut')
        doTweenY('tweenAL','iconP2', DefaultUiPos[9][2], 5, 'CircInOut')
    end
end