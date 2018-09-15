--恶魔降临
function c35310016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,35310016+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c35310016.cost)
	e1:SetTarget(c35310016.target)
	e1:SetOperation(c35310016.activate)
	c:RegisterEffect(e1)	
end
c35310016.setname="acfiend"
function c35310016.costfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3656) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c35310016.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end
function c35310016.filter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsSetCard(0x3656) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c35310016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c35310016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c35310016.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		else
			return Duel.IsExistingMatchingCard(c35310016.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c35310016.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SendtoGrave(g,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c35310016.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c35310016.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
