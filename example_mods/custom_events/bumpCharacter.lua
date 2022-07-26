local velocity = 0;
local funk = true;
local pullOffBumpin = false;
local defaultY
local defaultIconY
local invert = 1

function onSongStart()
    defaultY = getProperty('dad.y')
    defaultIconY = getProperty('iconP2.y')
    --pullOffBumpin = true;
    velocity = -26
end

function onEvent(name, value1, value2)
    if name == 'bumpCharacter' then
        pullOffBumpin = value1
    end
 end
 

function onUpdate(elapsed)
    if pullOffBumpin == true then
        if velocity >= 26 then 
            if funk == true then funk = false else funk = true end
            if invert == 1 then invert = -1 else invert = 1 end
            setProperty('dad.y', defaultY)
            if not getPropertyFromClass('ClientPrefs','downScroll') then 
                setProperty('iconP2.y', defaultIconY)
            end
            setProperty('dad.flipX', funk)
            setProperty('iconP2.flipX', not getProperty('dad.flipX'))
            velocity = -26 
        end
        velocity = velocity + 1.25
        setProperty('dad.y', getProperty('dad.y') + velocity)
        setProperty('dad.angle', getProperty('dad.angle') + (invert * (velocity * 0.1)))
        if not getPropertyFromClass('ClientPrefs','downScroll') then 
            setProperty('iconP2.y', getProperty('iconP2.y') + (velocity * 0.5))
        end
    end
end