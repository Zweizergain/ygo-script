--畅叙幽情 千岩
function c10920408.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10920408.spcon)
	e1:SetOperation(c10920408.spop)
	c:RegisterEffect(e1)
	--spsummon cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_COST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCost(c10920408.spcost)
	e2:SetOperation(c10920408.spcop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(10920408,ACTIVITY_NORMALSUMMON,c10920408.counterfilter)
	Duel.AddCustomActivityCounter(10920408,ACTIVITY_SPSUMMON,c10920408.counterfilter)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c10920408.target)
	e3:SetOperation(c10920408.operation)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10920408,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,10920408)
	e4:SetCondition(aux.exccon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c10920408.thtg)
	e4:SetOperation(c10920408.thop)
	c:RegisterEffect(e4)
end
function c10920408.spfilter1(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_ROCK) and c:IsAbleToGraveAsCost()
end
function c10920408.spfilter2(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_ROCK) and c:IsAbleToRemoveAsCost()
end
function c10920408.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10920408.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) 
		and Duel.IsExistingMatchingCard(c10920408.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) 
end
function c10920408.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10920408.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c10920408.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c10920408.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_ROCK)
end
function c10920408.spcost(e,c,tp)
	return Duel.GetCustomActivityCount(10920408,tp,ACTIVITY_NORMALSUMMON)==0
		   and Duel.GetCustomActivityCount(10920408,tp,ACTIVITY_SPSUMMON)==0 
end
function c10920408.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10920408.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e3,tp)
end
function c10920408.splimit(e,c)
	return not (c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_ROCK))
end
function c10920408.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	   and Duel.IsPlayerCanSpecialSummonMonster(tp,10920409,0,0x4011,0,2000,4,RACE_ROCK,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c10920408.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
	   and Duel.IsPlayerCanSpecialSummonMonster(tp,10920409,0,0x4011,0,2000,4,RACE_ROCK,ATTRIBUTE_EARTH) then
	   for i=1,2 do
		   local token=Duel.CreateToken(tp,10920409)
		   Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	   end
	   Duel.SpecialSummonComplete()
	end
end
function c10920408.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_ROCK) and not c:IsCode(10920408) and c:IsAbleToHand()
end
function c10920408.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c10920408.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10920408.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10920408.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10920408.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end