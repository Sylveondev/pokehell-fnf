--PS, the ; is optional.
local defaultNotePos = {};

local invert = 1;

local spin = false;
local bumpgui = false;
local bumpnotex = false;
local bumpnotey = false;
local bumpbothnotes = false;
local bumpnoteangle = false;
local bumpnotesides = false;

function onSongStart()

    for i = 0,7 do
 
        x = getPropertyFromGroup('strumLineNotes', i, 'x')
 
        y = getPropertyFromGroup('strumLineNotes', i, 'y')
 
        table.insert(defaultNotePos, {x, y})
 
        --debugPrint("{" .. x .. "," .. y .. "}" .. "i:" .. i)
    end
 
end

--Basically the magic
function onBeatHit()
    invert = invert / -1;
    --[[
    if curBeat == 64 then
        bumpnotex = true
    elseif curBeat == 96 then
        bumpnotex = false
        resetNotePos()
    elseif curBeat == 128 then
        bumpnotex = true
    elseif curBeat == 160 then
        bumpnotex = false
        resetNotePos()
        bumpnotey = true
        bumpgui = true
    elseif curBeat == 192 then
        bumpnotey = false
        bumpgui = false
        resetNotePos()
    elseif curBeat == 224 then
        bumpnotex = true
    else]]if curBeat == 256 then
        spin = true
        bumpnoteangle = true
    end

    if bumpgui == true then
        setProperty('camHUD.angle',invert * 10)
        doTweenAngle('turn', 'camHUD', 0, stepCrochet*0.003, 'quadOut')
    end

    --Complicated thingy because enabling both would break for some reason
    if bumpnotex == true then
        noteTweenX('A',0 , defaultNotePos[0 + 1][1] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('B',1 , defaultNotePos[1 + 1][1] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('C',2 , defaultNotePos[2 + 1][1] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('D',3 , defaultNotePos[3 + 1][1] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('E',4 , defaultNotePos[4 + 1][1] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('F',5 , defaultNotePos[5 + 1][1] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('G',6 , defaultNotePos[6 + 1][1] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('H',7 , defaultNotePos[7 + 1][1] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
    end
    if bumpnotey == true then
        noteTweenY('A',0 , defaultNotePos[0 + 1][2] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('B',1 , defaultNotePos[1 + 1][2] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('C',2 , defaultNotePos[2 + 1][2] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('D',3 , defaultNotePos[3 + 1][2] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('E',4 , defaultNotePos[4 + 1][2] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('F',5 , defaultNotePos[5 + 1][2] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('G',6 , defaultNotePos[6 + 1][2] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('H',7 , defaultNotePos[7 + 1][2] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
    end

    --Doesn't work as intended, sorry
    if bumpbothnotes == true then
        noteTweenX('A',0 , defaultNotePos[0 + 1][1] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('A',0 , defaultNotePos[0 + 1][2] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('B',1 , defaultNotePos[1 + 1][1] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('B',1 , defaultNotePos[1 + 1][2] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('C',2 , defaultNotePos[2 + 1][1] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('C',2 , defaultNotePos[2 + 1][2] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('D',3 , defaultNotePos[3 + 1][1] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('D',3 , defaultNotePos[3 + 1][2] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('E',4 , defaultNotePos[4 + 1][1] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('E',4 , defaultNotePos[4 + 1][2] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('F',5 , defaultNotePos[5 + 1][1] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('F',5 , defaultNotePos[5 + 1][2] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('G',6 , defaultNotePos[6 + 1][1] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('G',6 , defaultNotePos[6 + 1][2] + -invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenX('H',7 , defaultNotePos[7 + 1][1] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
        noteTweenY('H',7 , defaultNotePos[7 + 1][2] + invert * 32 , stepCrochet*0.0025, 'quadInOut');
    end

    if bumpnotesides == true then
        if invert == 1 then
            noteTweenX('A',0 , defaultNotePos[4 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('B',1 , defaultNotePos[5 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('C',2 , defaultNotePos[6 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('D',3 , defaultNotePos[7 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('E',4 , defaultNotePos[0 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('F',5 , defaultNotePos[1 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('G',6 , defaultNotePos[2 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('H',7 , defaultNotePos[3 + 1][1], stepCrochet*0.0025, 'quadInOut');
        else
            noteTweenX('A',0 , defaultNotePos[0 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('B',1 , defaultNotePos[1 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('C',2 , defaultNotePos[2 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('D',3 , defaultNotePos[3 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('E',4 , defaultNotePos[4 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('F',5 , defaultNotePos[5 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('G',6 , defaultNotePos[6 + 1][1], stepCrochet*0.0025, 'quadInOut');
            noteTweenX('H',7 , defaultNotePos[7 + 1][1], stepCrochet*0.0025, 'quadInOut');
        end
    end

    if bumpnoteangle == true then
        noteTweenAngle('A',0 , -invert * 45 , stepCrochet*0.0025, 'quadInOut');
        noteTweenAngle('B',1 , invert * 45 , stepCrochet*0.0025, 'quadInOut');
        noteTweenAngle('C',2 , -invert * 45 , stepCrochet*0.0025, 'quadInOut');
        noteTweenAngle('D',3 , invert * 45 , stepCrochet*0.0025, 'quadInOut');
        noteTweenAngle('E',4 , -invert * 45 , stepCrochet*0.0025, 'quadInOut');
        noteTweenAngle('F',5 , invert * 45 , stepCrochet*0.0025, 'quadInOut');
        noteTweenAngle('G',6 , -invert * 45 , stepCrochet*0.0025, 'quadInOut');
        noteTweenAngle('H',7 , invert * 45 , stepCrochet*0.0025, 'quadInOut');
    end
end

--Reset the note position and disable tweens so it doesn't screw stuff up
function resetNotePos()
    for i = 0,7 do
        setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1])
        setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2])
        setPropertyFromGroup('strumLineNotes', i, 'angle', 0)
    end
end

local spinlength = 0
function onUpdate(elapsed)
    songPos = getPropertyFromClass('Conductor', 'songPosition');

    rawBeat = (songPos / 1000) * (bpm / 60)

    currentBeat = math.floor(rawBeat)

    print(currentBeat)

    if spin == true then
        for i = 0,7 do
            setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] + 16 * math.sin((rawBeat + i*0.25) * math.pi))
            setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2] + 16 * math.sin((rawBeat + i*0.25) * math.pi))
        end
    end

    if currentBeat >= 64 and currentBeat < 96 then
        if spinlength < 32 then spinlength = spinlength + 0.5 end
        for i = 0,7 do
            setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] + spinlength * math.sin((rawBeat + i*0.25) * math.pi))
        end
    elseif currentBeat >= 96 and currentBeat < 110 then
        if spinlength > 0 then spinlength = spinlength - 0.5 end
        for i = 0,7 do
            setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] + spinlength * math.sin((rawBeat + i*0.25) * math.pi))
        end
    elseif currentBeat == 110 then
        resetNotePos()
    end
end