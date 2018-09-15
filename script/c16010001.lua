--妖怪-云外镜-
function c16010001.initial_effect(c)
		c:EnableReviveLimit()
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c16010001.spcon)
	c:RegisterEffect(e2)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c16010001.dircon)
end
function c16010001.cfilter(c)
	return c:IsFaceup() and c:IsCode(16010000)
end
function c16010001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16010001.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c16010001.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x102)
end
function c16010001.dircon(e)
	return Duel.IsExistingMatchingCard(c16010001.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
