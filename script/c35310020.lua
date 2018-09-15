--远古恶魔的结界
function c35310020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetCondition(c35310020.indcon)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetCondition(c35310020.indcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c35310020.actcon)
	e4:SetValue(c35310020.aclimit)
	--c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(35310020,0))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,35310020)
	e5:SetCondition(c35310020.drcon)
	e5:SetTarget(c35310020.drtg)
	e5:SetOperation(c35310020.drop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
c35310020.setname="acfiend"
function c35310020.cfilter2(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0x3656) and c:IsFaceup()
end
function c35310020.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c35310020.cfilter2,1,nil,tp)
end
function c35310020.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c35310020.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c35310020.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3656) and c:IsControler(tp)
end
function c35310020.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c35310020.cfilter(a,tp)) or (d and c35310020.cfilter(d,tp))
end
function c35310020.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c35310020.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3656) and c:GetSequence()<=4
end
function c35310020.indcon(e)
	return Duel.IsExistingMatchingCard(c35310020.indfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
