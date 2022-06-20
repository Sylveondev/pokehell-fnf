local somerandom

function opponentNoteHit()
    triggerEvent('Screen Shake', '0.1, 0.01', '0.1, 0.01');
    triggerEvent('Add Camera Zoom', '0.025', '0.025');
    if curBeat >= 128 and curBeat <= 191 then
        somerandom = math.random(1, 3)
        if somerandom == 1 then
            for i = 0,7 do 
                setPropertyFromGroup('strumLineNotes', i, 'x', math.random(280, 1000))
                setPropertyFromGroup('strumLineNotes', i, 'y', math.random(180, 540))
                setPropertyFromGroup('strumLineNotes', i, 'angle', math.random(-360, 360))
                setProperty('scoretable.x',  math.random(280, 1000))
                setProperty('scoretable.y',  math.random(180, 540))
                setProperty('scoretable.angle',  math.random(-360, 360))
                setProperty('timeBar.x',  math.random(280, 1000))
                setProperty('timeBar.y',  math.random(180, 540))
                setProperty('timeBar.angle',  math.random(-360, 360))
                setProperty('healthBar.x',  math.random(280, 1000))
                setProperty('healthBar.y',  math.random(180, 540))
                setProperty('healthBar.angle',  math.random(-360, 360))
                setProperty('scoreTxt.x',  math.random(280, 1000))
                setProperty('scoreTxt.y',  math.random(180, 540))
                setProperty('scoreTxt.angle',  math.random(-360, 360))
                setProperty('iconP1.x',  math.random(280, 1000))
                setProperty('iconP1.y',  math.random(180, 540))
                setProperty('iconP2.x',  math.random(280, 1000))
                setProperty('iconP2.y',  math.random(180, 540))
                
            end
        end
    end
end