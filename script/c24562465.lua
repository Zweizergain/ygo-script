--猛毒性 圾群
function c24562465.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,c24562465.mfilter,nil,2,2)
	c:EnableReviveLimit()
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24562465,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCost(c24562465.e3cost)
	e3:SetTarget(c24562465.e3tg)
	e3:SetOperation(c24562465.e3op)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24562465,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,24562466)
	e4:SetCondition(aux.exccon)
	e4:SetCost(c24562465.e4cost)
	e4:SetTarget(c24562465.e4tg)
	e4:SetOperation(c24562465.e4op)
	c:RegisterEffect(e4)
end
function c24562465.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsSetCard(0x1390)
end
function c24562465.e4cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c24562465.e4cfil,tp,LOCATION_GRAVE,0,1,c,tp) and Duel.IsExistingMatchingCard(c24562465.e4cfil2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24562465.e4cfil,tp,LOCATION_GRAVE,0,1,1,c,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c24562465.e4cfil2,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c24562465.e4cfil2(c,tp)
	return c:IsSetCard(0x1390) and c:IsDiscardable()
end
function c24562465.e4cfil(c,tp)
	return c:IsSetCard(0x1390) and c:IsAbleToRemoveAsCost()
end
function c24562465.e4op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMatchingGroupCount(c24562465.e4mtfil,tp,LOCATION_REMOVED,0,nil)>0 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return true end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if c:IsType(TYPE_XYZ) and c:IsFaceup() and Duel.GetMatchingGroupCount(c24562465.e4mtfil,tp,LOCATION_REMOVED,0,nil)>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g=Duel.SelectMatchingCard(tp,c24562465.e4mtfil,tp,LOCATION_REMOVED,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.Overlay(c,g)
			end
		end
	end
end
function c24562465.e4mtfil(c)
	return c:IsSetCard(0x1390) and c:IsFaceup()
end
function c24562465.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c24562465.e4mtfil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24562465.e3op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,24562464,0x1390,0x4011,700,700,1,RACE_ROCK,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,24562464)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c24562465.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,24562464,0x1390,0x4011,700,700,1,RACE_ROCK,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c24562465.e3cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end