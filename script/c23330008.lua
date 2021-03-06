--残霞の国
function c23330008.initial_effect(c)
	c:EnableCounterPermit(0x555)
	c:SetCounterLimit(0x555,5)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c23330008.acop)
	c:RegisterEffect(e2)	
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x555))
	e3:SetValue(c23330008.atkval)
	c:RegisterEffect(e3)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c23330008.desreptg)
	e4:SetOperation(c23330008.desrepop)
	c:RegisterEffect(e4)
end
function c23330008.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x555)>=5 end
	return true
end
function c23330008.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x555,5,REASON_EFFECT)
end
function c23330008.atkval(e,c)
	return e:GetHandler():GetCounter(0x555)*200
end
function c23330008.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x555) and c:GetReasonPlayer() and c:GetReasonPlayer()~=tp
end
function c23330008.acop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c23330008.cfilter,1,nil,tp) then
		e:GetHandler():AddCounter(0x555,1)
	end
end