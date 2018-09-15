--守护之翼
function c99999111.initial_effect(c)
    --NegateAttack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99999111,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c99999111.condition)
	e1:SetOperation(c99999111.activate)
	c:RegisterEffect(e1)
	--0
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99999111,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(c99999111.condition)
	e2:SetCost(c99999111.cost2)
	e2:SetOperation(c99999111.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e3)
	--discard & draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99999111,2))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1)
	e4:SetTarget(c99999111.target)
	e4:SetOperation(c99999111.operation2)
	c:RegisterEffect(e4)
end
function c99999111.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999111.spfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,1)
end
function c99999111.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c99999111.spfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)  then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c99999111.spfilter(c)
	return c:IsType(TYPE_NORMAL)  and c:IsAbleToGraveAsCost() 
end
function c99999111.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c99999111.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c99999111.cfilter(c)
	return  c:IsCode(99999110)
end
function c99999111.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c99999111.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c99999111.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end