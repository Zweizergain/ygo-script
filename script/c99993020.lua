--创造女皇-伊芙
function c99993020.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		return Duel.IsExistingMatchingCard(function(c,tp)
			return c99993020.rmfilter1(c)
			and Duel.IsExistingMatchingCard(c99993020.rmfilter2,tp,LOCATION_MZONE,0,1,c)
		end,tp,LOCATION_MZONE,0,1,nil,tp)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c)
		local rg=Duel.GetMatchingGroup(function(c)
			return c99993020.rmfilter1(c) or c99993020.rmfilter2(c)
		end,tp,LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local fc=rg:Select(tp,1,1,nil):GetFirst()
		local fil=aux.TRUE
		if not c99993020.rmfilter1(fc) then
			fil=c99993020.rmfilter1
		elseif not c99993020.rmfilter2(fc) then
			fil=c99993020.rmfilter2
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=rg:FilterSelect(tp,fil,1,1,fc)
		g:AddCard(fc)
		Duel.SendtoGrave(g,REASON_COST)
	end)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local loc=bit.band(c:GetPreviousLocation(),LOCATION_HAND+LOCATION_DECK)
		if loc==0 then return end
		local t={[LOCATION_HAND]=0,[LOCATION_DECK]=1}
		c:RegisterFlagEffect(99993020,RESET_EVENT+0x1fc0000,EFFECT_FLAG_CLIENT_HINT,1,loc,aux.Stringid(99993020,t[loc]))
	end)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():GetFlagEffectLabel(99993020)==LOCATION_HAND end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99993020,2))
		e:SetLabel(Duel.SelectOption(tp,70,71,72)+1)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local lab=e:GetLabel()
		local t={TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,1)
		e1:SetLabel(t[lab])
		e1:SetValue(function(e,re,tp)
			return re:IsActiveType(e:GetLabel()) and not re:GetHandler():IsImmuneToEffect(e)
		end)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		Duel.RegisterEffect(e1,tp)
	end)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,0x1c0)
	e5:SetTarget(c99993020.thtg)
	e5:SetOperation(c99993020.thop)
	c:RegisterEffect(e5)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99993020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c99993020.spcost)
	e1:SetTarget(c99993020.sptg)
	e1:SetOperation(c99993020.spop)
	c:RegisterEffect(e1)

end
c99993020.Remi_named_with_eve=true
function c99993020.Remi_IsEve(c,f)
	local func=f or Card.GetCode
	local t={func(c)}
	for i,code in pairs(t) do
		local m=_G["c"..code]
		if m and m.Remi_named_with_eve then return true end
	end
	return false
end
function c99993020.rmfilter1(c)
	return c99993020.Remi_IsEve(c) and c:IsAbleToGraveAsCost()
end
function c99993020.rmfilter2(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToGraveAsCost()
end
function c99993020.filter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c99993020.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c99993020.filter(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return e:GetHandler():GetFlagEffectLabel(99993020)==LOCATION_DECK
		and Duel.IsExistingTarget(c99993020.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c99993020.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99993020.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c99993020.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,POS_FACEUP,REASON_COST)
end
function c99993020.filter(c,e,tp)
	return c:IsFaceup() and c99993020.Remi_IsEve(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99993020.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c99993020.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c99993020.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c99993020.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99993020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end