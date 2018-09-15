--雾动机龙 力量输出阵
function c98727007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd8))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c98727007.aclimit)
	e4:SetCondition(c98727007.actcon)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_RELEASE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1)
	e5:SetCondition(c98727007.spcon)
	e5:SetOperation(c98727007.spop)
	c:RegisterEffect(e5)
	--addsetcard
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_ADD_SETCODE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetValue(0xd8)
	c:RegisterEffect(e6)
end
function c98727007.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c98727007.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd8) and c:IsControler(tp)
end
function c98727007.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c98727007.cfilter(a,tp)) or (d and c98727007.cfilter(d,tp))
end
function c98727007.rfilter(c,tp)
	return c:IsPreviousSetCard(0xd8) and c:IsReason(REASON_RELEASE) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetPreviousControler()==tp
end
function c98727007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98727007.rfilter,1,nil,tp)
end
function c98727007.spop(e,tp,eg,ep,ev,re,r,rp)
	local s1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,98727008,0xd8,0x4011,300,300,1,RACE_MACHINE,ATTRIBUTE_WATER,POS_FACEUP_ATTACK,tp)
	local s2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,98727008,0xd8,0x4011,300,300,1,RACE_MACHINE,ATTRIBUTE_WATER,POS_FACEUP_ATTACK,1-tp)
	local op=0
	if s1 or s2 then 
		Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	end
	if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(98727007,0),aux.Stringid(98727007,1))
		elseif s1 then op=0
		elseif s2 then op=1
	else return end
	local token=Duel.CreateToken(tp,98727008)
	if op==0 then 
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	else 
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
	end
end
