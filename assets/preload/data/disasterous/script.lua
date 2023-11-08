local showNote = false

function onBeatHit()
    if curBeat == 464 then
        showNote = true
        doTweenAlpha("bgTween","trippyBG",0,1,"QuadInOut")
        doTweenAlpha("camTween","camHUD",0,1,"QuadInOut")
    end

    if curBeat == 592 then
        showNote = false
        doTweenAlpha("bgTween","trippyBG",1,1,"QuadInOut")
        doTweenAlpha("camTween","camHUD",1,1,"QuadInOut")
    end

    if curBeat == 720 then
        showNote = true
        doTweenAlpha("bgTween","trippyBG",0,1,"QuadInOut")
        doTweenAlpha("camTween","camHUD",0,1,"QuadInOut")
    end

    if curBeat == 848 then
        showNote = false
        doTweenAlpha("bgTween","trippyBG",1,1,"QuadInOut")
        doTweenAlpha("camTween","camHUD",1,1,"QuadInOut")
    end
    
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if showNote == true and isSustainNote == false then
        setProperty("note"..noteData..".alpha", "1")
        doTweenAlpha("fadeOut"..noteData,"note"..noteData,0,1,"quartOut")
    end
end

function onCreate()
        makeLuaSprite('note0', 'arrows1', 0, 0);
        addLuaSprite('note0', true);
        doTweenColor('hello', 'note0', 'FFFFFFFF', 0.1, 'quartIn');
        setObjectCamera('note0', 'other');

        makeLuaSprite('note1', 'arrows2', 0, 0);
        addLuaSprite('note1', true);
        doTweenColor('hello1', 'note1', 'FFFFFFFF', 0.1, 'quartIn');
        setObjectCamera('note1', 'other');

        makeLuaSprite('note2', 'arrows3', 0, 0);
        addLuaSprite('note2', true);
        doTweenColor('hello2', 'note2', 'FFFFFFFF', 0.1, 'quartIn');
        setObjectCamera('note2', 'other');

        makeLuaSprite('note3', 'arrows4', 0, 0);
        addLuaSprite('note3', true);
        doTweenColor('hello3', 'note3', 'FFFFFFFF', 0.1, 'quartIn');
        setObjectCamera('note3', 'other');
end

function onCreatePost()
    doTweenAlpha("fadeOuta","note0",0,0.1,"quartOut")
    doTweenAlpha("fadeOutb","note1",0,0.1,"quartOut")
    doTweenAlpha("fadeOutc","note2",0,0.1,"quartOut")
    doTweenAlpha("fadeOutd","note3",0,0.1,"quartOut")
end