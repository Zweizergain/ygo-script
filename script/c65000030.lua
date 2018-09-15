--星霜指引-虚空领主
function c65000030.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x41),2,2)
	c:EnableReviveLimit()
	--change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65000030)
	e1:SetCost(c65000030.spcos)
	e1:SetTarget(c65000030.sptar)
	e1:SetOperation(c65000030.spop)
	c:RegisterEffect(e1)
	--cant Chain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c65000030.chaincon)
	e3:SetOperation(c65000030.chainop)
	c:RegisterEffect(e3)
end

function c65000030.chaincon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_STANDBY or ph==PHASE_END)
end

function c65000030.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x41) and re:IsActiveType(TYPE_MONSTER) then
		Duel.SetChainLimit(c65000030.chainlm)
	end
end
function c65000030.chainlm(e,rp,tp)
	return tp==rp
end

function c65000030.costfilter(c,e,tp)
	local lg=e:GetHandler():GetLinkedGroup()
	if not c:IsSetCard(0x41) or not c:IsAbleToDeckAsCost() or not c:IsFaceup() or not lg:IsContains(c) or not c:IsLevelBelow(6) then return false end
	local lv=c:GetLevel()
	return Duel.IsExistingMatchingCard(c65000030.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv)
end
function c65000030.spfilter(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,1,tp,false,false) and c:GetLevel()==lv
end
function c65000030.spcos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65000030.costfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c65000030.costfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c65000030.sptar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c65000030.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local lv=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,c65000030.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,1,tp,tp,false,false,POS_FACEUP)
		Duel.ShuffleDeck(tp)
	end
end