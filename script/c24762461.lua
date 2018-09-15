--猛毒性 积垢
function c24762461.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24762461,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,24762461)
	e1:SetCost(c24762461.e1cost)
	e1:SetTarget(c24762461.e1tg)
	e1:SetOperation(c24762461.e1op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,24762461)
	e2:SetCost(c24762461.spcost)
	e2:SetTarget(c24762461.sptg)
	e2:SetOperation(c24762461.spop)
	c:RegisterEffect(e2)
end
function c24762461.mmzfil(c)
	return c:IsSetCard(0x1390) and c:IsFaceup() and c:IsReleasable() and c:GetSequence()<5
end
function c24762461.e1cosfil(c)
	return c:IsSetCard(0x1390) and c:IsFaceup() and c:IsReleasable()
end
function c24762461.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and (ft>0 and Duel.IsExistingMatchingCard(c24762461.e1cosfil,tp,LOCATION_ONFIELD,0,1,nil) or Duel.IsExistingMatchingCard(c24762461.mmzfil,tp,LOCATION_MZONE,0,1,nil))
	end
	if ft>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c24762461.e1cosfil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g1,REASON_COST)
	  else 
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		 local g2=Duel.SelectMatchingCard(tp,c24762461.mmzfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g2,REASON_COST)
	end
end
function c24762461.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24762461.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c24762461.e3cfil(c)
	return c:IsSetCard(0x1390) and c:IsAbleToRemoveAsCost()
end
function c24762461.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24762461.e3cfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24762461.e3cfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c24762461.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24762461.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end