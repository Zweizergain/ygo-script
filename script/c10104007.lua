--Q兽 多拉考
function c10104007.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10104007)
	e1:SetCondition(c10104007.spcon)
	e1:SetOperation(c10104007.spop)
	c:RegisterEffect(e1)  
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10104007,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,10104107)
	e2:SetHintTiming(0,0x1e0+TIMING_MAIN_END)
	e2:SetCost(c10104007.spcost)
	e2:SetCondition(c10104007.spcon2)
	e2:SetTarget(c10104007.sptg2)
	e2:SetOperation(c10104007.spop2)
	c:RegisterEffect(e2)   
end
function c10104007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c10104007.tdfilter(c,e,tp)
	return c:IsSetCard(0xa330) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c10104007.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetCode())
end
function c10104007.spfilter2(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c10104007.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10104007.tdfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10104007.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10104007.tdfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local sg=Duel.SelectMatchingCard(tp,c10104007.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp,g:GetFirst():GetCode())
	   if sg:GetCount()>0 then
		  Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	   end
	end 
end
function c10104007.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c10104007.sprfilter(c)
	return c:IsSetCard(0xa330) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c10104007.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10104007.sprfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c10104007.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10104007.sprfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end