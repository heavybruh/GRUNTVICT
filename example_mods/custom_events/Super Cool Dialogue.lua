--[[ Script written by Heavy Bruh :3 ]]

local function doTweenScale(tag, vars, value, duration, easing)
	doTweenX(tag .. '-scale-x', vars .. '.scale', value, duration, easing)
	doTweenY(tag .. '-scale-y', vars .. '.scale', value, duration, easing)
end

local text_thingie = 0
local function createDialogue(text, dur)
    local buggin_he_must_not_know_im_thuggin = (text == nil or dur == nil)
    if buggin_he_must_not_know_im_thuggin then
        debugPrint("Whoopsies, something went wrong :PPP")
    else
        makeLuaText('dialogue', string.upper(text), screenWidth, 0, 0)
        setTextSize('dialogue', 100); setTextBorder('dialogue', 0)
        setTextFont('dialogue', 'Wood Block CG Regular.otf')
        setTextAlignment('dialogue', 'center'); screenCenter('dialogue')
        setObjectCamera('dialogue', 'other')
        addLuaText('dialogue')
        
        doTweenAlpha('dialogue_tween_alpha', 'dialogue', 0, (crochet / dur), 'quintIn')
        doTweenScale('dialogue_tween_scale', 'dialogue', 5, (crochet / (dur / 2)), 'quintIn')
    end
end

function onEvent(eventName, v1, v2)
    if (eventName == 'Super Cool Dialogue') then
        createDialogue(v1, v2)
    end
end

function onTweenCompleted(t)
    if (t == 'dialogue_tween_alpha' and luaTextExists('dialogue')) then
        removeLuaText('dialogue')
    end
end