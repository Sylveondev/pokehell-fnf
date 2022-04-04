local flipped = false;

function onEvent(name, value1, value2)
	if name == 'FlipUI' then
		if flipped then
		doTweenAngle('unbruh', 'camHUD', 36000000000, 0.1, 'linear')
		flipped = false;
		else 
		doTweenAngle('bruh','camHUD', 0, 0.1, 'linear')
		flipped = true;
		end
	end
end