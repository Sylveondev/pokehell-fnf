local defaultNotePos = {};
function onSongStart()

    for i = 0,7 do
 
        x = getPropertyFromGroup('strumLineNotes', i, 'x')
 
        y = getPropertyFromGroup('strumLineNotes', i, 'y')
 
        table.insert(defaultNotePos, {x, y})
 
        --debugPrint("{" .. x .. "," .. y .. "}" .. "i:" .. i)
    end
 
end

function onBeatHit()
    if (curBeat == 8) then
        --Enable this early so the camera zooms back
        setProperty('camZooming',true)
    end
    if (curBeat >= 8 and curBeat < 208) then
        setProperty('camGame.zoom', 1.3)
        setProperty('camHUD.zoom', 1.15)
        setProperty('camHUD.angle',((curBeat % 2 == 0) and 8 or -8))
        doTweenAngle('turn', 'camHUD', 0, stepCrochet*0.008, 'backOut')
        doTweenAngle('turn2', 'camGame', 0, stepCrochet*0.008, 'backOut')
        for i = 0,7 do
            setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] + ((curBeat % 2 == 0) and -1 or 1) * ((i % 2 == 0) and -1 or 1) * 32)
        end
        noteTweenX('A',0 , defaultNotePos[0 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('B',1 , defaultNotePos[1 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('C',2 , defaultNotePos[2 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('D',3 , defaultNotePos[3 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('E',4 , defaultNotePos[4 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('F',5 , defaultNotePos[5 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('G',6 , defaultNotePos[6 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('H',7 , defaultNotePos[7 + 1][1], stepCrochet*0.005, 'backOut');
    elseif curBeat == 208 then
        setProperty('camHUD.angle',0)
        doTweenAngle('turn', 'camHUD', 0, stepCrochet*0.008, 'backOut')
        doTweenAngle('turn2', 'camGame', 0, stepCrochet*0.008, 'backOut')
        noteTweenX('A',0 , defaultNotePos[0 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('B',1 , defaultNotePos[1 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('C',2 , defaultNotePos[2 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('D',3 , defaultNotePos[3 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('E',4 , defaultNotePos[4 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('F',5 , defaultNotePos[5 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('G',6 , defaultNotePos[6 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('H',7 , defaultNotePos[7 + 1][1], stepCrochet*0.005, 'backOut');
    elseif (curBeat >= 212 and curBeat < 276) then
        setProperty('camGame.zoom', 1.3)
        setProperty('camHUD.zoom', 1.15)
        setProperty('camHUD.angle',((curBeat % 2 == 0) and 8 or -8))
        doTweenAngle('turn', 'camHUD', 0, stepCrochet*0.008, 'backOut')
        doTweenAngle('turn2', 'camGame', 0, stepCrochet*0.008, 'backOut')
        for i = 0,7 do
            setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] + ((curBeat % 2 == 0) and -1 or 1) * ((i % 2 == 0) and -1 or 1) * 32)
        end
        noteTweenX('A',0 , defaultNotePos[0 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('B',1 , defaultNotePos[1 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('C',2 , defaultNotePos[2 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('D',3 , defaultNotePos[3 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('E',4 , defaultNotePos[4 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('F',5 , defaultNotePos[5 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('G',6 , defaultNotePos[6 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('H',7 , defaultNotePos[7 + 1][1], stepCrochet*0.005, 'backOut');
    elseif curBeat == 276 then
        setProperty('camGame.zoom', 3)
        setProperty('camHUD.zoom', 2)
        setProperty('camHUD.angle',0)
        doTweenAngle('turn', 'camHUD', 0, stepCrochet*0.008, 'backOut')
        doTweenAngle('turn2', 'camGame', 0, stepCrochet*0.008, 'backOut')
        noteTweenX('A',0 , defaultNotePos[0 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('B',1 , defaultNotePos[1 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('C',2 , defaultNotePos[2 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('D',3 , defaultNotePos[3 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('E',4 , defaultNotePos[4 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('F',5 , defaultNotePos[5 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('G',6 , defaultNotePos[6 + 1][1], stepCrochet*0.005, 'backOut');
        noteTweenX('H',7 , defaultNotePos[7 + 1][1], stepCrochet*0.005, 'backOut');
    end
end

function onStepHit()
    if (curBeat == 211) then
        setProperty('camHUD.zoom', 1.5)
        setProperty('camGame.zoom', 2)
    end
end
function onUpdate(elapsed)
    FlxMath.lerp(1, getProperty('camGame.angle'), getPropertyFromClass('CoolUtil','boundTo(1 - ('..elapsed..' * 9), 0, 1)'))
    FlxMath.lerp(1, getProperty('camHUD.angle'), getPropertyFromClass('CoolUtil','boundTo(1 - ('..elapsed..' * 9), 0, 1)'))
end