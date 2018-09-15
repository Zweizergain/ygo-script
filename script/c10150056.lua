--大怪兽入侵
function c10150056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10150056.target)
	e1:SetOperation(c10150056.activate)
	c:RegisterEffect(e1)	
end

function c10150056.filter(c,e,tp)
	return c:IsSetCard(0xd3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end

function c10150056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsExistingMatchingCard(c10150056.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.IsPlayerCanDraw(tp,1) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function c10150056.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10150056.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
		local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,g:GetFirst())
		Duel.BreakEffect()
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
