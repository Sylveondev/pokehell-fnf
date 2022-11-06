local somerandom

function onBeatHit()
    somerandom = math.random(1, 25)
    if somerandom == 1 then
        triggerEvent('Jumpscare', 'lightningJumpscare', 'shock,0.5');

    end
end