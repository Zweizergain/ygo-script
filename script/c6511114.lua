--ＣＸ タイタンの蟲惑魔
function c6511114.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c6511114.efilter)
	e1:SetCondition(c6511114.accon)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetTarget(c6511114.rmtg)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6511114,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c6511114.cost)
	e3:SetCondition(c6511114.con5)
	e3:SetTarget(c6511114.target)
	e3:SetOperation(c6511114.operation)
	c:RegisterEffect(e3)
end
function c6511114.accon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,6511113)
end
function c6511114.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c6511114.rmtg(e,c)
return c:IsReason(REASON_EFFECT) and c:GetReasonEffect():GetHandler():GetType()==TYPE_TRAP and (c:GetReasonEffect():GetHandler():IsSetCard(0x4c) or c:GetReasonEffect():GetHandler():IsSetCard(0x89))
end
function c6511114.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c6511114.filter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToRemove()
end
function c6511114.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6511114.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(c6511114.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c6511114.con5(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c6511114.filter3,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,1,c)
end
function c6511114.filter3(c)
	return c:IsType(TYPE_TRAP)
end
function c6511114.hfilter(c)
	return c:GetType()==TYPE_TRAP and (c:IsSetCard(0x4c) or c:IsSetCard(0x89)) and c:IsLocation(LOCATION_REMOVED) 
end
function c6511114.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c6511114.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if g:GetCount()==0 then return end
	Duel.Remove(g,nil,REASON_EFFECT)
	local ct2=g:FilterCount(c6511114.hfilter,nil)
	Duel.Damage(1-tp,ct2*400,REASON_EFFECT,true)
	Duel.RDComplete()
end
