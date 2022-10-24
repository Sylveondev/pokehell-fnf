local invertmii = 1
function onBeatHit()
 if curBeat >= 32 and curBeat < 127 then
    setProperty("camGame.zoom",1.5)
    setProperty("camHUD.zoom",1.25)
 end
 if curBeat >= 96 and curBeat < 127 then
    doTweenAngle("camtween", "camGame", 6*invertmii, 1, "circOut")
    doTweenAngle("hudtween", "camHUD", 6*invertmii, 1, "circOut")
    invertmii = invertmii * -1;
 end
 if curBeat == 131 then
    doTweenAngle("camtween", "camGame", 0, 1, "circOut")
    doTweenAngle("hudtween", "camHUD", 0, 1, "circOut")
 end
 
 if curBeat >= 144 and curBeat < 223 then
    setProperty("camGame.zoom",1.5)
    setProperty("camHUD.zoom",1.25)
 end
 if curBeat >= 192 and curBeat < 256 then
    doTweenAngle("camtween", "camGame", 6*invertmii, 1, "circOut")
    doTweenAngle("hudtween", "camHUD", 6*invertmii, 1, "circOut")
    invertmii = invertmii * -1;
 end
 if curBeat == 224 then
     doTweenZoom(zoomcam, "camGame", 3, 20,"quadInOut")
 end
 if curBeat == 258 then
     doTweenZoom(zoomcam, "camGame", 1, 1,"quadInOut")
 
    doTweenAngle("camtween", "camGame", 0, 1, "circOut")
    doTweenAngle("hudtween", "camHUD", 0, 1, "circOut")
 end
end