function onEvent(name, value1, value2) 
	if name == 'noteskinchange' then
		if value1 == '' then
		-- do nothing lol
		else
			for i = 0, getProperty('opponentStrums.length')-1 do
				setPropertyFromGroup('opponentStrums', i, 'texture', 'thefunny');
			end
			for i = 0, getProperty('unspawnNotes.length')-1 do
				if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then
				setPropertyFromGroup('unspawnNotes', i, 'texture', 'thefunny');
				end
			end
			for i = 0, getProperty('playerStrums.length')-1 do
			setPropertyFromGroup('playerStrums', i, 'texture', 'thefunny');
			end
			for i = 0, getProperty('unspawnNotes.length')-1 do
				if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				setPropertyFromGroup('unspawnNotes', i, 'texture', 'thefunny');
				end
			end
		end 
	
		if value2 == '' then
		-- do nothing lol
		else
			for i = 0, getProperty('unspawnNotes.length')-1 do
				if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then
				setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'thefunnySploosh');
				end
			end
			for i = 0, getProperty('unspawnNotes.length')-1 do
				if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', 'thefunnySploosh');
				end
			end
		end
	end
end