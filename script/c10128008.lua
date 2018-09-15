--奇妙障壁
function c10128008.initial_effect(c)
	--fuck monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,10128008)
	e1:SetCondition(c10128008.condition)
	e1:SetOperation(c10128008.operation)
	c:RegisterEffect(e1)	
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(10128008,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10128108)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c10128008.accost)
	e2:SetTarget(c10128008.actg)
	e2:SetOperation(c10128008.acop)
	c:RegisterEffect(e2)  
end
function c10128008.costfilter(c)
	return bit.band(c:GetType(),0x10002)==0x10002 and c:IsAbleToDeckAsCost()
end
function c10128008.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10128008.costfilter,tp,LOCATION_GRAVE,0,1,c) and bit.band(c:GetType(),0x10002)==0x10002 and c:IsAbleToDeckAsCost() and bit.band(c:GetType(),0x10002)==0x10002 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10128008.costfilter,tp,LOCATION_GRAVE,0,1,1,c) 
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c10128008.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	if res==70 then
	   e:SetLabel(0x1)
	elseif res==71 then
	   e:SetLabel(0x2)
	else
	   e:SetLabel(0x4)
	end
end
function c10128008.acop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetLabel(e:GetLabel())
	e1:SetValue(c10128008.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10128008.aclimit(e,re,tp)
	return re:GetHandler():IsType(e:GetLabel())
end
function c10128008.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c10128008.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetLabelObject(re)
	e1:SetValue(c10128008.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10128008.efilter(e,re)
	local te=e:GetLabelObject()
	local ie=0x0
	if e:GetHandlerPlayer()==re:GetHandlerPlayer() then return false end
	if te:IsHasType(TYPE_MONSTER) then ie=ie+0x1 end
	if te:IsHasType(TYPE_SPELL) then ie=ie+0x2 end
	if te:IsHasType(TYPE_TRAP) then ie=ie+0x4 end
	return re:IsHasType(ie)
end