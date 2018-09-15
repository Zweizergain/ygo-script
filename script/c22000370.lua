--从者Caster 诸葛孔明
function c22000370.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c22000370.tfilter,aux.NonTuner(Card.IsSetCard,0xfff),1)
	c:EnableReviveLimit()
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22000370,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c22000370.cost)
	e1:SetTarget(c22000370.tftg)
	e1:SetOperation(c22000370.tfop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xfff))
	e2:SetValue(c22000370.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCountLimit(1)
	e4:SetTarget(c22000370.indtg)
	e4:SetValue(c22000370.indval)
	c:RegisterEffect(e4)
end
function c22000370.costfilter(c)
	return c:IsSetCard(0xffd) and c:IsDiscardable()
end
function c22000370.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22000370.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c22000370.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c22000370.tffilter(c,cc,tp)
	return c:IsCode(23000080) and not c:IsForbidden() and c:CheckUniqueOnField(1-tp,LOCATION_ONFIELD,cc)
end
function c22000370.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>-1 end
end
function c22000370.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c22000370.tffilter,tp,LOCATION_DECK,0,1,1,nil,nil,1-tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c22000370.tfilter(c)
	return c:IsCode(24000020)
end
function c22000370.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfff)
end
function c22000370.atkval(e,c)
	return Duel.GetMatchingGroupCount(c22000370.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*300
end
function c22000370.indtg(e,c)
	return c:IsSetCard(0xfff)
end
function c22000370.indval(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end