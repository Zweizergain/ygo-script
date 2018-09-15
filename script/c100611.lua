--「风神之神德」
function c100611.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(100611,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,100611+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100611.condition1)
	e1:SetTarget(c100611.target1)
	e1:SetOperation(c100611.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--Activate(effect)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(100611,0))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,100611+EFFECT_COUNT_CODE_OATH)
	e4:SetCondition(c100611.condition2)
	e4:SetTarget(c100611.target2)
	e4:SetOperation(c100611.activate2)
	c:RegisterEffect(e4)	
	--Activate(negate attack)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetDescription(aux.Stringid(100611,2))
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCountLimit(1,100611+EFFECT_COUNT_CODE_OATH)
	e6:SetCondition(c100611.condition3)
	e6:SetTarget(c100611.negtg)
	e6:SetOperation(c100611.negop)
	c:RegisterEffect(e6)
end
function c100611.filter(c)
	return c:IsType(TYPE_MONSTER) and c:GetSummonType()==SUMMON_TYPE_ADVANCE and c:IsSetCard(0x208)
end
function c100611.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.IsExistingMatchingCard(c100611.filter,tp,LOCATION_MZONE,0,1,nil)
end

function c100611.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c100611.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c100611.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c100611.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c100611.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100611.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function c100611.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100611.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c100611.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ac=Duel.GetAttacker()
	if ac:IsRelateToBattle() then 
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,ac,1,0,0)		
	end 
end
function c100611.negop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local rp=ac:IsRelateToBattle() 
	if Duel.NegateAttack() and rp then
		Duel.Destroy(ac,REASON_EFFECT)
	end
end