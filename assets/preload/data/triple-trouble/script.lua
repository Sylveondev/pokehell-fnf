--PS, the ; is optional.
local defaultNotePos = {};
local triggerEeeee = false;

local invert = 1;

local spin = false;
local bumpgui = false;
local bumpcam = false;
local bumpnotex = false;
local bumpnotey = false;
local bumpbothnotes = false;
local bumpnoteangle = false;
local bumpnotesides = false;
local defaultbfx;
local defaultbfy;
local defaultdadx;
local defaultdady;
local somerandom;


function onSongStart()

    defaultbfx = getCharacterX('bf')
    defaultbfy = getCharacterY('bf')
    defaultdadx = getCharacterX('dad')
    defaultdady = getCharacterY('dad')

    for i = 0,9 do
 
        x = getPropertyFromGroup('strumLineNotes', i, 'x')
 
        y = getPropertyFromGroup('strumLineNotes', i, 'y')
 
        table.insert(defaultNotePos, {x, y})
 
        --debugPrint("{" .. x .. "," .. y .. "}" .. "i:" .. i)
    end
 
end

--Basically the magic
function onBeatHit()

    somerandom = math.random(1, 50)
    if somerandom == 1 and triggerEeeee == true then
        triggerEvent('Screen Shake', '0.25, 0.1', '0.25, 0.1');
        triggerEvent('Jumpscare', 'eeeeeJumpscare', 'scream,1');

    end

    invert = invert / -1;
    if curBeat == 260 then
        triggerEvent('Flash camera', '1', '');
        triggerEvent('Default Camera Zoom', '1.5', '6');

        bumpnotex = true
        evolveMode(true)
    elseif curBeat == 324 then
        triggerEvent('Flash camera', '1', '');
        triggerEvent('Default Camera Zoom', '1', '1');
        bumpnotex = false
        evolveMode(false)
        --Reposition sunshine
        setCharacterY('dad', defaultdady + 100)
        resetNotePos()
    elseif curBeat == 580 then
        triggerEvent('Flash camera', '1', '');
        triggerEvent('Default Camera Zoom', '1.5', '2');
        evolveMode(true)
        flipCharacters(true)
    elseif curBeat == 707 then
        flipCharacters(false)
        evolveMode(false)
    elseif curBeat == 740 then
        triggerEvent('Flash camera', '1', '');
        triggerEvent('Default Camera Zoom', '1', '1');
        spin = true
    elseif curBeat == 1028 then
        triggerEvent('Flash camera', '1', '');
        triggerEvent('Default Camera Zoom', '1.5', '2');
        evolveMode(true)
    end

    if bumpgui == true then
        setProperty('camHUD.angle',-invert * 10)
        setProperty('camera.angle',invert * 10)
        doTweenAngle('turn', 'camHUD', 0, stepCrochet*0.008, 'elasticOut')
        doTweenAngle('turnagain', 'camera', 0, stepCrochet*0.008, 'elasticOut')
    end

    if bumpcam == true then
        
        
    end

    --Complicated thingy because enabling both would break for some reason
    if bumpnotex == true then
        noteTweenX('A',0 , defaultNotePos[0 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('B',1 , defaultNotePos[1 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('C',2 , defaultNotePos[2 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('D',3 , defaultNotePos[3 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('E',4 , defaultNotePos[4 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('F',5 , defaultNotePos[5 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('G',6 , defaultNotePos[6 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('H',7 , defaultNotePos[7 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('I',8 , defaultNotePos[8 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('J',9 , defaultNotePos[9 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');

    end
    if bumpnotey == true then
        noteTweenY('A',0 , defaultNotePos[0 + 1][2] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('B',1 , defaultNotePos[1 + 1][2] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('C',2 , defaultNotePos[2 + 1][2] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('D',3 , defaultNotePos[3 + 1][2] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('E',4 , defaultNotePos[4 + 1][2] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('F',5 , defaultNotePos[5 + 1][2] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('G',6 , defaultNotePos[6 + 1][2] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('H',7 , defaultNotePos[7 + 1][2] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('I',8 , defaultNotePos[8 + 1][2] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('J',9 , defaultNotePos[9 + 1][2] + invert * 32 , stepCrochet*0.005, 'elasticOut');
    end

    --Doesn't work as intended, sorry
    if bumpbothnotes == true then
        noteTweenX('A',0 , defaultNotePos[0 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('A',0 , defaultNotePos[0 + 1][2] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('B',1 , defaultNotePos[1 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('B',1 , defaultNotePos[1 + 1][2] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('C',2 , defaultNotePos[2 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('C',2 , defaultNotePos[2 + 1][2] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('D',3 , defaultNotePos[3 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('D',3 , defaultNotePos[3 + 1][2] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('E',4 , defaultNotePos[4 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('E',4 , defaultNotePos[4 + 1][2] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('F',5 , defaultNotePos[5 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('F',5 , defaultNotePos[5 + 1][2] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('G',6 , defaultNotePos[6 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('G',6 , defaultNotePos[6 + 1][2] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('H',7 , defaultNotePos[7 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('H',7 , defaultNotePos[7 + 1][2] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('I',8 , defaultNotePos[8 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('I',8 , defaultNotePos[8 + 1][2] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('J',9 , defaultNotePos[9 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenY('J',9 , defaultNotePos[9 + 1][2] + invert * 32 , stepCrochet*0.005, 'elasticOut');
    end

    if bumpnotesides == true then
        if invert == 1 then
            noteTweenX('A',0 , defaultNotePos[4 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('B',1 , defaultNotePos[5 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('C',2 , defaultNotePos[6 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('D',3 , defaultNotePos[7 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('E',4 , defaultNotePos[0 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('F',5 , defaultNotePos[1 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('G',6 , defaultNotePos[2 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('H',7 , defaultNotePos[3 + 1][1], stepCrochet*0.005, 'elasticOut');
        else
            noteTweenX('A',0 , defaultNotePos[0 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('B',1 , defaultNotePos[1 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('C',2 , defaultNotePos[2 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('D',3 , defaultNotePos[3 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('E',4 , defaultNotePos[4 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('F',5 , defaultNotePos[5 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('G',6 , defaultNotePos[6 + 1][1], stepCrochet*0.005, 'elasticOut');
            noteTweenX('H',7 , defaultNotePos[7 + 1][1], stepCrochet*0.005, 'elasticOut');
        end
    end

    if bumpnoteangle == true then
        noteTweenAngle('A',0 , -invert * 45 , stepCrochet*0.005, 'elasticOut');
        noteTweenAngle('B',1 , invert * 45 , stepCrochet*0.005, 'elasticOut');
        noteTweenAngle('C',2 , -invert * 45 , stepCrochet*0.005, 'elasticOut');
        noteTweenAngle('D',3 , invert * 45 , stepCrochet*0.005, 'elasticOut');
        noteTweenAngle('E',4 , -invert * 45 , stepCrochet*0.005, 'elasticOut');
        noteTweenAngle('F',5 , invert * 45 , stepCrochet*0.005, 'elasticOut');
        noteTweenAngle('G',6 , -invert * 45 , stepCrochet*0.005, 'elasticOut');
        noteTweenAngle('H',7 , invert * 45 , stepCrochet*0.005, 'elasticOut');
    end
end

--Reset the note position and disable tweens so it doesn't screw stuff up
function resetNotePos()
    for i = 0,9 do
        setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1])
        setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2])
        setPropertyFromGroup('strumLineNotes', i, 'angle', 0)
    end
end

function onUpdate(elapsed)
    songPos = getPropertyFromClass('Conductor', 'songPosition');

    currentBeat = (songPos / 1000) * (bpm / 60)

    if spin == true then
        for i = 0,9 do
            setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] + 16 * math.sin((currentBeat + i*0.25) * math.pi))
            setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2] + 16 * math.sin((currentBeat + i*0.25) * math.pi))
        end
    end
end

function evolveMode(enabled)
    triggerEeeee = enabled
    if enabled == true then
        setProperty('dad.scale.x', 2)
        setProperty('dad.scale.y', 2)
        setCharacterX('dad', defaultbfx - 125)
        setCharacterY('dad', defaultbfy - 25)
    elseif enabled == false then
        setCharacterX('dad', defaultdadx)
        setCharacterY('dad', defaultdady)
    end
end

function flipCharacters(doflip)
    bfx = getCharacterX('bf')
    bfy = getCharacterY('bf')
    dadx = getCharacterX('dad')
    dady = getCharacterY('dad')
    
    setCharacterX('bf',dadx)
    setCharacterY('bf',dady)
    setCharacterX('dad',bfx)
    setCharacterY('dad',bfy)
    
    if doflip == true then
        setProperty('boyfriend.flipX',true)
        setProperty('dad.flipX',true)
    else
        setProperty('boyfriend.flipX',false)
        setProperty('dad.flipX',false)
    end

    if doflip == true then
        noteTweenX('A',0 , defaultNotePos[5 + 1][1], 2, 'elasticInOut');
        noteTweenX('B',1 , defaultNotePos[6 + 1][1], 2.5, 'elasticInOut');
        noteTweenX('C',2 , defaultNotePos[7 + 1][1], 3, 'elasticInOut');
        noteTweenX('D',3 , defaultNotePos[8 + 1][1], 3.5, 'elasticInOut');
        noteTweenX('E',4 , defaultNotePos[9 + 1][1], 4, 'elasticInOut');
        noteTweenX('F',5 , defaultNotePos[0 + 1][1], 4, 'elasticInOut');
        noteTweenX('G',6 , defaultNotePos[1 + 1][1], 3.5, 'elasticInOut');
        noteTweenX('H',7 , defaultNotePos[2 + 1][1], 3, 'elasticInOut');
        noteTweenX('I',8 , defaultNotePos[3 + 1][1], 2.5, 'elasticInOut');
        noteTweenX('J',9 , defaultNotePos[4 + 1][1], 2, 'elasticInOut');
    else
        noteTweenX('A',0 , defaultNotePos[0 + 1][1], 0.5, 'elasticInOut');
        noteTweenX('B',1 , defaultNotePos[1 + 1][1], 1, 'elasticInOut');
        noteTweenX('C',2 , defaultNotePos[2 + 1][1], 1.5, 'elasticInOut');
        noteTweenX('D',3 , defaultNotePos[3 + 1][1], 2, 'elasticInOut');
        noteTweenX('E',4 , defaultNotePos[4 + 1][1], 2.5, 'elasticInOut');
        noteTweenX('F',5 , defaultNotePos[5 + 1][1], 2.5, 'elasticInOut');
        noteTweenX('G',6 , defaultNotePos[6 + 1][1], 2, 'elasticInOut');
        noteTweenX('H',7 , defaultNotePos[7 + 1][1], 1.5, 'elasticInOut');
        noteTweenX('I',8 , defaultNotePos[8 + 1][1], 1, 'elasticInOut');
        noteTweenX('J',9 , defaultNotePos[9 + 1][1], 0.5, 'elasticInOut');
    end
end

function onCreate()
    setProperty('gf.visible', false)
end