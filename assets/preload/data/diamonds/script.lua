local invertmii = -1
function onBeatHit()
    if curBeat >= 64 and curBeat < 96 then
        doTweenAngle("camtween", "camGame", 2*invertmii, 1, "circOut")
        doTweenAngle("hudtween", "camHUD", 2*invertmii, 1, "circOut")
        setProperty('camGame.zoom',getProperty('camGame.zoom')+0.01)
        setProperty('camHUD.zoom',getProperty('camHUD.zoom')+0.01)
    elseif curBeat >= 96 and curBeat < 224 then
        doTweenAngle("camtween", "camGame", 6*invertmii, 1, "circOut")
        doTweenAngle("hudtween", "camHUD", 6*invertmii, 1, "circOut")
        if curBeat % 4 == 0 then
            setProperty('camGame.zoom',getProperty('camGame.zoom')+0.4)
            setProperty('camHUD.zoom',getProperty('camHUD.zoom')+0.2)
        end
    elseif curBeat >= 352 and curBeat < 480 then
        doTweenAngle("camtween", "camGame", 6*invertmii, 1, "circOut")
        doTweenAngle("hudtween", "camHUD", 6*invertmii, 1, "circOut")
        if curBeat % 4 == 0 then
            setProperty('camGame.zoom',getProperty('camGame.zoom')+0.4)
            setProperty('camHUD.zoom',getProperty('camHUD.zoom')+0.2)
        end
    elseif curBeat >= 608 and curBeat < 672 then
        doTweenAngle("camtween", "camGame", 6*invertmii, 1, "circOut")
        doTweenAngle("hudtween", "camHUD", 6*invertmii, 1, "circOut")
        if curBeat % 4 == 0 then
            setProperty('camGame.zoom',getProperty('camGame.zoom')+0.4)
            setProperty('camHUD.zoom',getProperty('camHUD.zoom')+0.2)
        end
    else
        doTweenAngle("camtween", "camGame", 2*invertmii, 1, "circOut")
        doTweenAngle("hudtween", "camHUD", 2*invertmii, 1, "circOut")
    end

    invertmii = invertmii * -1;

end