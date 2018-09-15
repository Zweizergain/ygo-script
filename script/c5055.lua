--愛
function c5055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5055,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c5055.target)
	e3:SetValue(c5055.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c5055.target)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--return	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5055,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetCost(c5055.decost)
	e2:SetOperation(c5055.activate)
	c:RegisterEffect(e2)
	--cannot be destroyed
	--local e5=Effect.CreateEffect(c)
	--e5:SetType(EFFECT_TYPE_SINGLE)
	--e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e5:SetCondition(c5055.condition)
	--e5:SetRange(LOCATION_SZONE)
	--e5:SetValue(1)
	--c:RegisterEffect(e5)
end
function c5055.target(e,c)
	return (c:IsType(TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION)) and c:IsSetCard(0x900)
end
function c5055.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c5055.spfilter(c)
	return c:IsFaceup() and c:IsCode(5050)
end
function c5055.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c5055.spfilter,tp,LOCATION_FZONE,0,1,nil)
end
function c5055.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDraw(tp,1) then
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
end
function c5055.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_MONSTER+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():IsSetCard(0x900)
end