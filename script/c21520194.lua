--急流精怪-支援型
function c21520194.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c21520194.spcon)
	e1:SetOperation(c21520194.spop)
	c:RegisterEffect(e1)
	--synchro lv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(c21520194.lvval)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520194,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c21520194.thcon)
	e3:SetTarget(c21520194.thtg)
	e3:SetOperation(c21520194.thop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(21520194,ACTIVITY_SUMMON,c21520194.counterfilter)
	Duel.AddCustomActivityCounter(21520194,ACTIVITY_FLIPSUMMON,c21520194.counterfilter)
	Duel.AddCustomActivityCounter(21520194,ACTIVITY_SPSUMMON,c21520194.counterfilter)
end
function c21520194.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c21520194.spfilter(c)
	return (not c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()) or c:IsFacedown()
end
function c21520194.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	if Duel.GetCustomActivityCount(21520194,tp,ACTIVITY_SUMMON)~=0 
		and Duel.GetCustomActivityCount(21520194,tp,ACTIVITY_FLIPSUMMON)~=0 
		and Duel.GetCustomActivityCount(21520194,tp,ACTIVITY_SPSUMMON)~=0 
		then return false end
	return not Duel.IsExistingMatchingCard(c21520194.spfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and not Duel.IsExistingMatchingCard(Card.IsType,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP)
end
function c21520194.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local code=e:GetHandler():GetCode()
	local ct=Duel.GetFlagEffect(tp,code)
	Duel.RegisterFlagEffect(tp,code,RESET_PHASE+PHASE_END,0,1)
	Duel.Damage(tp,100*2^ct,REASON_RULE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c21520194.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c21520194.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c21520194.lvval(e,c)
	local lv=e:GetHandler():GetLevel()
	if not c:IsAttribute(ATTRIBUTE_WATER) then return lv
	else
		return 3*65536+lv
	end
end
function c21520194.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local fg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()==fg:GetCount() and g:GetCount()==fg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)
end
--[[
function c21520194.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand() and not c:IsCode(21520194)
end--]]
function c21520194.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
--	if chk==0 then return Duel.IsExistingMatchingCard(c21520194.thfilter,tp,LOCATION_DECK,0,1,nil) end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
--	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21520194.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsRace(RACE_AQUA) then 
		if tc:IsAbleToHand() then
			Duel.DisableShuffleCheck()
			if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then Duel.ShuffleHand(tp) end
		end
	else
		Duel.MoveSequence(tc,1)
	end
end
