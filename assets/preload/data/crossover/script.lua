--PS, the ; is optional.

--[[
local defaultNotePos = {};

local invert = 1;
local invertbool = false;

local spin = false;
local bumpgui = false;
local bumpcam = false;
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

function onCreate()
    setProperty('gf.visible', false)
end

--Basically the magic
function onBeatHit()
    invert = invert / -1;
    invertbool = (invertbool and true or false);
    if curBeat == 32 then
        bumpnotex = true
    elseif curBeat == 48 then
        bumpnotex = false
        resetNotePos()
        bumpnotey = true
    elseif curBeat == 80 then
        bumpnotey = false
        resetNotePos()
        spin = true
    elseif curBeat == 112 then
        triggerEvent('Default Camera Zoom', 1, 1)
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

    if curBeat >= 32 and curBeat <= 48 then
        setProperty('camHUD.angle',invert * 2)
        setProperty('camera.angle',invert * 2)
        doTweenAngle('turn', 'camHUD', 0, stepCrochet*0.008, 'circOut')
        doTweenAngle('turnagain', 'camera', 0, stepCrochet*0.008, 'circOut')

        triggerEvent('Add Camera Zoom', 0.3, 0.2)
        bumpnotex = true
    elseif curBeat >= 48 and curBeat <= 80 then
        setProperty('camHUD.angle',invert * 16)
        setProperty('camera.angle',invert * 16)
        doTweenAngle('turn', 'camHUD', 0, stepCrochet*0.008, 'elasticOut')
        doTweenAngle('turnagain', 'camera', 0, stepCrochet*0.008, 'elasticOut')
        if curBeat == 81 then 
            triggerEvent('Default Camera Zoom', 1, 0.05) 
            triggerEvent('Default CamHUD Zoom', 1, 0.05)
        end
        triggerEvent('Add Camera Zoom', 1.5, 0.6)
    elseif curBeat >= 80 and curBeat <= 112 then
        triggerEvent('Add Camera Zoom', 0.3, 0.2)
        if curBeat == 81 then
            doTweenAlpha('fadecam', 'camHUD', 0, 1, 'quadInOut')
        elseif curBeat > 81 and curBeat % 2 == 0 then
                if getPropertyFromClass('ClientPrefs', 'flashing') == true then
                    triggerEvent('Add Camera Zoom', 1.5, 0.6)
                    triggerEvent('Flash camera', 0.5)
                    
                    setProperty('boxBG.color', getColorFromHex('000000'))
                    setProperty('boyfriend.color', getColorFromHex(rgbToHex(math.floor(math.random()*255),math.floor(math.random()*255),math.floor(math.random()*255))))
                    setProperty('dad.color', getColorFromHex(rgbToHex(math.floor(math.random()*255),math.floor(math.random()*255),math.floor(math.random()*255))))
            end
        end
        if curBeat == 91 then
            doTweenAlpha('fadecam', 'camHUD', 1, 10, 'quadInOut')
        end
    elseif curBeat > 112 then
        if curBeat == 113 then
            setProperty('boxBG.color', getColorFromHex('FFFFFF'))
            setProperty('boyfriend.color', getColorFromHex('FFFFFF'))
            setProperty('dad.color', getColorFromHex('FFFFFF'))
        end
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

function getColor(r1, g1, b1, r2, g2, b2)
    local out = {}
  
    -- set the base range of numbers (0 to high-low)
    local rRange = math.abs(r1 - r2)
    local gRange = math.abs(g1 - g2)
    local bRange = math.abs(b1 - b2)
      
    -- set the modifier for each color with a common random
    local rand = math.random()
    local rMod = rand * rRange
    local gMod = rand * gRange
    local bMod = rand * bRange
  
    if r1 < r2 then
      out.r = rMod + r1
    else
      out.r = r1 - rMod
    end
      
    if g1 < g2 then
      out.g = gMod + g1
    else
      out.g = g1 - gMod
    end
      
    if b1 < b2 then
      out.b = bMod + b1
    else
      out.b = b1 - bMod
    end
  
    return out
  end

  function rgbToHex(rgb)
	local hexadecimal = ''

	for key, value in pairs(rgb) do
		local hex = ''

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end

		if(string.len(hex) == 0)then
			hex = '00'

		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end

		hexadecimal = hexadecimal .. hex
	end

	return hexadecimal
end
]]--