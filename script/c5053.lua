--娘化即正義！
function c5053.initial_effect(c)
	--activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e6)
	--name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1)
	e1:SetTarget(c5053.target)
	e1:SetOperation(c5053.cdop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c5053.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--cannot be destroyed
	--local e5=Effect.CreateEffect(c)
	--e5:SetType(EFFECT_TYPE_SINGLE)
	--e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e5:SetCondition(c5053.condition)
	--e5:SetRange(LOCATION_SZONE)
	--e5:SetValue(1)
	--c:RegisterEffect(e5)
end
function c5053.zfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c5053.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c5053.zfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c5053.zfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
end
function c5053.cdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(5099)
	tc:RegisterEffect(e1)
end
function c5053.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and c:IsSetCard(0x900)
end
function c5053.spfilter(c)
	return c:IsFaceup() and c:IsCode(5050)
end
function c5053.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c5053.spfilter,tp,LOCATION_FZONE,0,1,nil)
end