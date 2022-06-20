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
    if curBeat == 32 then
        bumpnotex = true
    elseif curBeat == 48 then
        bumpnotex = false
        resetNotePos()
        bumpnotey = true
        bumpgui = true
    elseif curBeat == 80 then
        bumpnotey = false
        bumpgui = false
        resetNotePos()
        spin = true
    elseif curBeat == 112 then
        spin = false
        resetNotePos()
    elseif curBeat == 176 then
        bumpnotey = true
    elseif curBeat == 240 then
        bumpnotey = false
        resetNotePos()
    elseif curBeat == 296 then
        spin = true
    elseif curBeat == 620 then
        spin = false
        resetNotePos()
    elseif curBeat == 624 then
        bumpnoteangle = true
    elseif curBeat == 884 then
        bumpnoteangle = false
        resetNotePos()
    elseif curBeat == 892 then
        bumpgui = true
        bumpnotex = true
    elseif curBeat == 1056 then
        bumpgui = false
        bumpnotex = false
        resetNotePos()
    elseif curBeat == 1060 then
        bumpnotesides = true
    elseif curBeat == 1124 then
        bumpnotesides = false
        resetNotePos()
    end

    if bumpgui == true then
        setProperty('camHUD.angle',invert * 10)
        doTweenAngle('turn', 'camHUD', 0, stepCrochet*0.008, 'elasticOut')
    end

    --Complicated thingy because enabling both would break for some reason
    if bumpnotex == true then
        noteTweenX('A',0 , defaultNotePos[0 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('B',1 , defaultNotePos[1 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('C',2 , defaultNotePos[2 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('D',3 , defaultNotePos[3 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('E',4 , defaultNotePos[4 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('F',5 , defaultNotePos[5 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('G',6 , defaultNotePos[6 + 1][1] + -invert * 32 , stepCrochet*0.005, 'elasticOut');
        noteTweenX('H',7 , defaultNotePos[7 + 1][1] + invert * 32 , stepCrochet*0.005, 'elasticOut');
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
    for i = 0,7 do
        setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1])
        setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2])
        setPropertyFromGroup('strumLineNotes', i, 'angle', 0)
    end
end

function onUpdate(elapsed)
    songPos = getPropertyFromClass('Conductor', 'songPosition');

    currentBeat = (songPos / 1000) * (bpm / 60)

    print(currentBeat)

    if spin == true then
        for i = 0,7 do
            setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] + 16 * math.sin((currentBeat + i*0.25) * math.pi))
            setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2] + 16 * math.sin((currentBeat + i*0.25) * math.pi))
        end
    end
end