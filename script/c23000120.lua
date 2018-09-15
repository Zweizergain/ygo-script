--幻·术
function c23000120.initial_effect(c)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c23000120.handcon)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,23000120+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c23000120.condition)
	e2:SetTarget(c23000120.target)
	e2:SetOperation(c23000120.activate)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_SUMMON)
	e3:SetCountLimit(1,23000120+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c23000120.condition1)
	e3:SetTarget(c23000120.target1)
	e3:SetOperation(c23000120.activate1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON)
	e4:SetCountLimit(1,23000120+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetCountLimit(1,23000120+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e5)
	--negate attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCountLimit(1,23000120+EFFECT_COUNT_CODE_OATH)
	e6:SetCondition(c23000120.condition2)
	e6:SetOperation(c23000120.activate2)
	c:RegisterEffect(e6)
end
function c23000120.atkfilter(c)
	return c:IsFaceup() and c:IsCode(22000060) or c:IsCode(23000040)
end
function c23000120.handcon(e)
	return Duel.GetMatchingGroupCount(c23000120.atkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)>=1
end
function c23000120.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfff)
end
function c23000120.condition(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not Duel.IsExistingMatchingCard(c23000120.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c23000120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c23000120.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		if Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)~=0 and ec:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		end
	end
end
function c23000120.condition1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not Duel.IsExistingMatchingCard(c23000120.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return Duel.GetCurrentChain()==0
end
function c23000120.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c23000120.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
end
function c23000120.condition2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not Duel.IsExistingMatchingCard(c23000120.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return Duel.GetTurnPlayer()~=tp
end
function c23000120.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end