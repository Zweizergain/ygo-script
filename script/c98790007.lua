--进化虫·奶酪湾蜥
function c98790007.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98790007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c98790007.cost)
	e1:SetTarget(c98790007.target)
	e1:SetOperation(c98790007.operation)
	c:RegisterEffect(e1)
	--xyzmaterial
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98790007,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,98790007)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c98790007.xcost)
	e3:SetOperation(c98790007.xop)
	c:RegisterEffect(e3)
end
function c98790007.costfilter(c)
	return c:IsSetCard(0x304e) and c:IsReleasable()
end
function c98790007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.IsExistingMatchingCard(c98790007.costfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c98790007.costfilter,tp,LOCATION_MZONE,0,1,1,c)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end
function c98790007.filter(c,e,tp)
	return c:IsSetCard(0x604e) and c:IsCanBeSpecialSummoned(e,154,tp,false,false)
end
function c98790007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c98790007.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c98790007.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98790007.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummon(tc,154,tp,tp,false,false,POS_FACEUP)
		local rf=tc.evolreg
		if rf then rf(tc) end
		tc=g:GetNext()
	end
end
function c98790007.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c98790007.xfilter(c)
	return c:IsSetCard(0x504e) and c:IsType(TYPE_XYZ) and c:IsPosition(POS_FACEUP)
end
function c98790007.xop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e1:SetCondition(c98790007.rcon)
	e1:SetOperation(c98790007.rop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98790007.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0x504e)
end
function c98790007.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(98790007,1))
end
