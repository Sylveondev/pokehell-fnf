-- FOR ADVANCED USERS ONLY 
-- change the value on the right to true or false to customize the notes sounds and Animations


local blamSound = true;
local healSound = true;
local posiSound = true;
local statSound = true;

local blamAnim = true; -- this looks for an animation thats called dodge
local directionalBlamAnim = false; -- this looks for an animation called dodge[Direction] (eg dodgeLEFT, dodgeRIGHT, dodgeDOWN, dodgeUP)



function goodNoteHit(id, noteData, noteType, isSustainNote)
-- Sounds
	if blamSound == true then
		
		
			if noteType == 'Blammed Note' then
			playSound('shooters');
			end
			if noteType == 'halfBlammed Note' then
			playSound('among')
			end
		
	end
	
	

	if healSound == true then
		
			
		
			if noteType == 'smaHeal Note' then
			playSound('holy', 0.25)
			end
			if noteType == 'medHeal Note' then
			playSound('holy', 0.5)
			end
			if noteType == 'halfHeal Note' then
			playSound('holy')
			end
			if noteType == 'fullHeal Note' then
			playSound('bigHoly')
			end
		
	end
	if blamAnim == true then
		if noteType == 'Blammed Note' then
		characterPlayAnim('bf', 'dodge');
		characterPlayAnim('dad','attack');
			if directionalBlamAnim then
				if noteData == 0 then
				characterPlayAnim('bf', 'dodgeLEFT');
				end
				if noteData == 1 then
				characterPlayAnim('bf', 'dodgeDOWN');
				end
				if noteData == 2 then
				characterPlayAnim('bf', 'dodgeUP');
				end
				if noteData == 3 then
				characterPlayAnim('bf', 'dodgeRIGHT');
				end
			end
		end
		if noteType == 'halfBlammed Note' then
			characterPlayAnim('bf', 'dodge');
			characterPlayAnim('dad','attack');
			if directionalBlamAnim then
				if noteData == 0 then
				characterPlayAnim('bf', 'dodgeLEFT');
				end
				if noteData == 1 then
				characterPlayAnim('bf', 'dodgeDOWN');
				end
				if noteData == 2 then
				characterPlayAnim('bf', 'dodgeUP');
				end
				if noteData == 3 then
				characterPlayAnim('bf', 'dodgeRIGHT');
				end
			end
			
		end
		
		
	end
end

function noteMiss(id, noteData, noteType, isSustainNote)
	if statSound == true then
		if noteType == 'Static Note' then
			playSound('staticBUZZ')
		end
	end
end