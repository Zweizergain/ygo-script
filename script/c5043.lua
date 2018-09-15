--娘化 金閃閃
function c5043.initial_effect(c)
	c:SetUniqueOnField(1,0,5043)
	--synchro summon
	aux.AddSynchroProcedure(c,c5043.tfilter,aux.NonTuner(Card.IsSetCard,0x900),1)
	c:EnableReviveLimit()   
	--Change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetValue(5099)
	c:RegisterEffect(e1)
	--Atk update
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c5043.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetValue(c5043.atkval1)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_SZONE)
	e4:SetCondition(c5043.discon)
	e4:SetTarget(c5043.distg1)
	e4:SetOperation(c5043.damop)
	c:RegisterEffect(e4) 
end
function c5043.tfilter(c)
	return c:IsSetCard(0x900)
end
function c5043.atkval(e,c)
	local lps=Duel.GetLP(c:GetControler())/2
	local lpo=Duel.GetLP(1-c:GetControler())/2
	if lps<lpo then return 0
	else return lps-lpo end
end
function c5043.atkval1(e,c)
	local lps=Duel.GetLP(c:GetControler())/2
	local lpo=Duel.GetLP(1-c:GetControler())/2
	if lps>lpo then return 0
	else return lpo-lps end
end
function c5043.discon(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,5042)
end

function c5043.distg1(e,c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x900)
end
function c5043.damop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsCode(5042),tp,LOCATION_MZONE,0,1,nil) then return end
end