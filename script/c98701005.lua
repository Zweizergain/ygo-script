--灵魂陷阱
function c98701005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c98701005.target)
	e1:SetOperation(c98701005.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c98701005.reptg)
	e2:SetValue(c98701005.repval)
	e2:SetOperation(c98701005.repop)
	c:RegisterEffect(e2)
end
function c98701005.repfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c98701005.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c98701005.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(98701005,0))
end
function c98701005.repval(e,c)
	return c98701005.repfilter(c,e:GetHandlerPlayer())
end
function c98701005.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c98701005.filter1(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToChangeControler() and c:IsFaceup()
end
function c98701005.filter2(c)
	return c:IsAbleToChangeControler() and c:IsFaceup()
end
function c98701005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98701005.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c98701005.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,0,0,0)
end
function c98701005.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c98701005.filter1,tp,LOCATION_MZONE,0,1,nil)
		or not Duel.IsExistingMatchingCard(c98701005.filter2,tp,0,LOCATION_MZONE,1,nil)
	then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectMatchingCard(tp,c98701005.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectMatchingCard(tp,c98701005.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(g2)
	Duel.SwapControl(g1:GetFirst(),g2:GetFirst())
end
