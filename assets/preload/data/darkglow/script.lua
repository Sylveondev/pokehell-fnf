local defScroll = false
local defCenter = false
local isDownscroll = false

local defaultNotePos = {};

local isCenterscroll = false
local upscrollPos

local debuffs = 0
local lastdebuff = 0

function onBeatHit()
        if debuffs == 0 then
            rand = math.random(1,4)
            repeat rand = math.random(1,4) until rand ~= lastdebuff
            lastdebuff = rand
            debuffs = 8
            debugPrint('Debug debuff: '..rand)
            if rand == 1 then
                if isDownscroll == true then isDownscroll = false else isDownscroll = true end
                debugPrint(isDownscroll)
                setPropertyFromClass('ClientPrefs','downScroll',isDownscroll)
                for i = 0,7 do
                    noteTweenY('notetween'..i, i , defaultNotePos[0 + 1][2] * (isDownscroll and 12 or 1), 0.5, 'circInOut');
                end
            doTweenAlpha('alphaA', 'iconP1', (isDownscroll and 0 or 1), 0.5, 'circInOut')
            doTweenAlpha('alphaB', 'iconP2', (isDownscroll and 0 or 1), 0.5, 'circInOut')
            doTweenAlpha('alphaC', 'healthBar', (isDownscroll and 0 or 1), 0.5, 'circInOut')
            doTweenAlpha('alphaD', 'healthBarBg', (isDownscroll and 0 or 1), 0.5, 'circInOut')
            doTweenAlpha('alphaE', 'healthBarOverlay', (isDownscroll and 0 or 1), 0.5, 'circInOut')
            
            elseif rand == 2 then
                randzoom = math.random()*1.5
                if randzoom < 0.75 then randzoom = 0.75 end
                if randzoom > 1.5 then randzoom = 1.5 end
                debugPrint(randzoom)
                triggerEvent('Default Camera Zoom', randzoom, 0.5)
            elseif rand == 3 then
                if isCenterscroll == true then isCenterscroll = false else isCenterscroll = true end
                debugPrint(isCenterscroll)
                if isCenterscroll == true then
                    for i = 0,3 do
                        noteTweenX('notetweena'..i, i , defaultNotePos[i + 1][1] + 320, 0.5, 'circInOut');
                        noteTweenAlpha('notealpha'..i, i , 0.5, 0.5, 'circInOut');
                    end
                    for i = 4,7 do
                        noteTweenX('notetweenb'..i, i , defaultNotePos[i + 1][1] -320, 0.5, 'circInOut');
                    end
                else
                    for i = 0,3 do
                        noteTweenX('notetweena'..i, i , defaultNotePos[i + 1][1], 0.5, 'circInOut');
                        noteTweenAlpha('notealpha'..i, i , 1, 0.5, 'circInOut');
                    end
                    for i = 4,7 do
                        noteTweenX('notetweenb'..i, i , defaultNotePos[i + 1][1], 0.5, 'circInOut');
                    end
                end
            end
        end

    if debuffs > 0 then debuffs = debuffs - 1 end
    if curBeat == 24 then
        setProperty('camera.zoom', 2)
        doTweenAlpha('camHudTween', 'camHUD', 1, 4, 'quadInOut')
        doTweenAlpha('camTween', 'camera', 1, 2, 'quadInOut')
    end
end

function onDestroy()
    setPropertyFromClass('ClientPrefs','downScroll',defScroll)
    setPropertyFromClass('ClientPrefs','centerScroll', defCenter)

end

function onCreatePost()
    defScroll = getPropertyFromClass('ClientPrefs','downScroll')
    defCenter = getPropertyFromClass('ClientPrefs','centerScroll')
    setPropertyFromClass('ClientPrefs','centerScroll', false)
    isDownscroll = defScroll
    setProperty('camera.alpha',0)
end

function onSongStart()
    doTweenAlpha('camTween', 'camHUD', 0, 2, 'quadInOut')

    for i = 0,7 do
 
        x = getPropertyFromGroup('strumLineNotes', i, 'x')
 
        y = getPropertyFromGroup('strumLineNotes', i, 'y')
 
        table.insert(defaultNotePos, {x, y})
 
        --debugPrint("{" .. x .. "," .. y .. "}" .. "i:" .. i)
    end

end