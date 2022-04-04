function onEvent(name, value1, value2)
	-- bf notesFade
	if name == 'LinearAlphaBF' then
	noteTweenAlpha('AF',4 , value2 , value1 + 0.01, 'circInOut');
	noteTweenAlpha('BF',5 , value2 , value1 + 0.01, 'circInOut');
	noteTweenAlpha('CF',6 , value2 , value1 + 0.01, 'circInOut');
	noteTweenAlpha('DF',7 , value2 , value1 + 0.01, 'circInOut');
	

	
end
end