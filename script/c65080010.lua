--雪尘塔
function c65080010.initial_effect(c)
	--ac
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65080010,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c65080010.thtg)
	e1:SetOperation(c65080010.thop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65080010,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,65080010)
	e2:SetTarget(c65080010.sumtg)
	e2:SetOperation(c65080010.sumop)
	c:RegisterEffect(e2)
	--race
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetTarget(c65080010.rctg)
	e3:SetValue(RACE_SPELLCASTER)
	c:RegisterEffect(e3)
end
function c65080010.rctg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end

function c65080010.fil(c)
	return c:IsCode(65080009) and not c:IsForbidden()
end

function c65080010.filter(c)
	return c:IsSummonable(true,nil) and c:IsLevel(8) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c65080010.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65080010.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end

function c65080010.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c65080010.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
	   Duel.Summon(tp,tc,true,nil)
	end
	if Duel.IsExistingMatchingCard(c65080010.fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(65080010,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c65080010.fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end

function c65080010.thfil(c,ct)
	return c:IsLevelBelow(ct) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end

function c65080010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1015)
	if chk==0 then return Duel.IsExistingMatchingCard(c65080010.thfil,tp,LOCATION_DECK,0,1,nil,ct) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c65080010.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1015)
	local g=Duel.SelectMatchingCard(tp,c65080010.thfil,tp,LOCATION_DECK,0,1,1,nil,ct)
	local tc=g:GetFirst()
	if tc then local lv=tc:GetLevel() end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1015,lv,REASON_EFFECT) 
	Duel.SendtoHand(tc,tp,REASON_EFFECT) 
end