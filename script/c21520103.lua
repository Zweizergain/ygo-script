--苍星曜兽-氐土貉
function c21520103.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520103,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(3,21520103+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c21520103.condition)
	e1:SetCost(c21520103.cost)
	e1:SetTarget(c21520103.target)
	e1:SetOperation(c21520103.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c21520103.filter(c)
	return c:IsSetCard(0x3491) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c21520103.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsPlayerCanDraw(tp,2)-- and c:GetFlagEffect(21520103)==0 
		and Duel.IsExistingMatchingCard(c21520103.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
end
function c21520103.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
--	c:RegisterFlagEffect(21520103,RESET_PHASE+PHASE_END,0,1)
end
function c21520103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c21520103.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,2,REASON_EFFECT)
	if ct==0 then return end
end
