--白魔术破坏师
function c34340046.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c34340046.spcon)
	e1:SetOperation(c34340046.spop)
	c:RegisterEffect(e1)  
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34340046,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c34340046.target)
	e2:SetOperation(c34340046.operation)
	c:RegisterEffect(e2) 
end
c34340046.setname="WhiteMagician"
function c34340046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsLevel(7) end
end
function c34340046.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(7)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c34340046.cfilter(c,e,tp)
	return c:IsDestructable(e) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c34340046.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c34340046.cfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp)
end
function c34340046.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c34340046.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST+REASON_DESTROY)
end
