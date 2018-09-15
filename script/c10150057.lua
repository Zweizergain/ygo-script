--大怪兽大对峙
function c10150057.initial_effect(c)
	c:EnableCounterPermit(0x37)
	c:SetCounterLimit(0x37,3)   
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c10150057.counter)
	c:RegisterEffect(e2)
	--Atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd3))
	e3:SetValue(300)
	e3:SetCondition(c10150057.con1)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd3))
	e4:SetValue(1)
	e4:SetCondition(c10150057.con2)
	c:RegisterEffect(e4)
	--act limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(c10150057.con3)
	e5:SetValue(c10150057.aclimit)
	c:RegisterEffect(e5)
end

function c10150057.cfilter(c,tp)
	return c:IsSetCard(0xd3) and c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsControler(1-tp)
end

function c10150057.counter(e,tp,eg,ep,ev,re,r,rp)
	if eg:FilterCount(c10150057.cfilter,nil,tp)>0 then
		e:GetHandler():AddCounter(0x37,1,true)
	end
end

function c10150057.cfilter2(c)
	return c:IsSetCard(0xd3) and c:IsFaceup() 
end

function c10150057.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x37)>=1 and Duel.IsExistingMatchingCard(c10150057.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end

function c10150057.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x37)>=2 and Duel.IsExistingMatchingCard(c10150057.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end

function c10150057.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x37)==3 and Duel.IsExistingMatchingCard(c10150057.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end

function c10150057.aclimit(e,re,tp)
	return not (re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xd3))
end