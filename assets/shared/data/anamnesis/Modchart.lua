--[[ Script made by Heavy Bruh :D ]]

function onBeatHit()
    if (curBeat == 4) then
		doTweenAlpha('color_alpha_0', 'color', 0, (crochet / 50), 'sineOut')
        doTweenAlpha('game_alpha', 'camGame', 1, (crochet / 1000), 'expoOut')

    elseif (curBeat == 36) then
        doTweenAlpha('card_alpha', 'card', 1, (crochet / 200), 'smootherStepInOut')

    elseif (curBeat == 52) then
        doTweenAlpha('card_alpha', 'card', 0, (crochet / 200), 'smootherStepInOut')
        
    elseif (curBeat == 66) then
        doTweenAlpha('hud_alpha', 'camHUD', 1, (crochet / 200), 'expoOut')
        doTweenY('hud_ypos', 'camHUD', 0, (crochet / 200), 'expoOut')
    end
end

function onCreate()
    setProperty('skipCountdown', true)
    --setProperty('camHUD.y', 100)
    --setProperty('camHUD.alpha', 0)
    setProperty('camGame.alpha', 0)

    addCharacterToList('pico-new', 'bf')

    makeLuaText('card', "-" .. string.upper(songName) .. "-\nBY NOICHI", screenWidth, 0, 0)
    setTextSize('card', 90); setTextBorder('card', 0)
    setTextFont('card', 'Wood Block CG Regular.otf')
    setTextAlignment('card', 'center'); screenCenter('card')
    setObjectCamera('card', 'other')
    addLuaText('card')
    setProperty('card.alpha', 0)

    makeLuaSprite('color', nil, nil, nil); makeGraphic('color',  screenWidth, screenHeight, 'ffffff')
    setProperty('color.alpha', 0)
    setBlendMode('color', 'add')
    setObjectCamera('color', 'other')
    addLuaSprite('color', true);
    doTweenAlpha('color_alpha_0', 'color', 1, (crochet / 250), 'quintIn')
end

function onCreatePost()
    setProperty('boyfriend.color', getColorFromHex('CCCAD9'))
end

function onMoveCamera(c)
	if dadName == "gruntvict" then
		if (c == 'dad') then
			setProperty('defaultCamZoom', 0.6)
		else
			setProperty('defaultCamZoom', 0.8)
		end
	end
end