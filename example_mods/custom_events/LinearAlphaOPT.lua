function onEvent(name, value1, value2)
	if name == 'LinearAlphaOPT' then
	-- oppt notefade
	noteTweenAlpha('EF',0 , value2 , value1 + 0.01, 'circInOut');
	noteTweenAlpha('FF',1 , value2 , value1 + 0.01, 'circInOut');
	noteTweenAlpha('GF',2 , value2 , value1 + 0.01, 'circInOut');
	noteTweenAlpha('HF',3 , value2 , value1 + 0.01, 'circInOut');
	
	
end
end