local defWinPos = {}
local shakeScreen = false
function onCreatePost()
    setProperty('camGame.alpha', 0)
    setProperty('camHUD.alpha', 0)

    
end
function onSongStart()
    table.insert(defWinPos, {getPropertyFromClass('openfl.Lib','application.window.x'), getPropertyFromClass('openfl.Lib','application.window.y')})
end

function onBeatHit()
    if curBeat == 2 then
        setProperty('camGame.alpha', 1)
        setProperty('camHUD.alpha', 1)
        setProperty('camGame.zoom', 0.3)
    elseif curBeat == 3 then
        shakeScreen = true
    end
end

function opponentNoteHit()
    triggerEvent('Screen Shake', '0.1, 0.01', '0.1, 0.01');
    triggerEvent('Add Camera Zoom', '0.025', '0.025');
end

function onUpdate(elapsed)
    songPos = getPropertyFromClass('Conductor', 'songPosition');
    currentBeat = (songPos / 1000) * (bpm / 60)

    
end