--「流放人偶」
function c100411.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c100411.condition)
	e1:SetTarget(c100411.target)
	e1:SetOperation(c100411.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c100411.negcon)
	e2:SetTarget(c100411.negtg)
	e2:SetOperation(c100411.negop)
	c:RegisterEffect(e2)		
	--Activate(summon)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCondition(c100411.condition1)
	e3:SetTarget(c100411.target1)
	e3:SetOperation(c100411.activate1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c100411.spop)
	c:RegisterEffect(e4)
end
function c100411.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ap=c:GetPreviousControler()
	Duel.SSet(1-ap,c)
end
function c100411.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and bit.band(re:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)>0
end
function c100411.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100411.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	end
end
function c100411.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c100411.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ac=Duel.GetAttacker()
	if ac:IsRelateToBattle() then 
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,ac,1,0,0)		
	end 
end
function c100411.negop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local rp=ac:IsRelateToBattle() 
	if Duel.NegateAttack() and rp then
		Duel.SendtoGrave(ac,REASON_EFFECT)
	end
end
function c100411.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c100411.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c100411.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
