local somerandom

function onBeatHit()
    somerandom = math.random(1, 50)
    if somerandom == 1 then
        triggerEvent('Screen Shake', '0.25, 0.1', '0.25, 0.1');
        triggerEvent('Jumpscare', 'eeeeeJumpscare', 'scream,1');

    end
end