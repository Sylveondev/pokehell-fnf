local invertmii = -1

function onBeatHit()
    if (curBeat >= 448 and curBeat < 511) or (curBeat >= 840 and curBeat < 904) then
        setProperty('camGame.zoom',getProperty('camGame.zoom')+0.5)
        setProperty('camHUD.zoom',getProperty('camHUD.zoom')+0.2)
    else
        setProperty('camGame.zoom',getProperty('camGame.zoom')+0.025)
        
    end
    setProperty('camHUD.y',-150)
    setProperty('camHUD.angle',invertmii * 8)
    setProperty('camGame.y',-16)
    setProperty('camGame.angle',invertmii * 2)
    doTweenY('twnthehud', 'camHUD', 0, 0.2, 'circOut')
    doTweenAngle('movethehud', 'camHUD', 0, 0.2, 'quadOut')
    doTweenY('twnthecam', 'camGame', 0, 1, 'circOut')
    doTweenAngle('movethecam', 'camGame', 0, 1, 'quadOut')
    invertmii = invertmii / -1
end