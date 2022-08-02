function onStepHit()
    if curStep == 1514 then
        setProperty('trees.velocity.x', 0)
        setProperty('mountains.velocity.x', 0)
        setProperty('road.velocity.x', 0)
        triggerEvent('Screen Shake','1, 0.5','1, 0.5')
    end
end