--白魔术实习士
function c34340001.initial_effect(c)
	--Attribute Dark
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1) 
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34340001,1))
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c34340001.atcon2)
	e2:SetTarget(c34340001.attg2)
	e2:SetOperation(c34340001.atop2)
	c:RegisterEffect(e2) 
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(34340001,0))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c34340001.atcon)
	e3:SetCost(c34340001.atcost)
	e3:SetOperation(c34340001.atop)
	c:RegisterEffect(e3)  
end
c34340001.setname="WhiteMagician"
function c34340001.atcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp)
end
function c34340001.costfilter2(c)
	return c:IsType(TYPE_MONSTER) and c.setname=="WhiteMagician" and c:IsDiscardable()
end
function c34340001.attg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c34340001.atop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c34340001.costfilter2,tp,LOCATION_HAND,0,1,c) and Duel.DiscardHand(tp,c34340001.costfilter2,1,1,REASON_EFFECT+REASON_DISCARD)~=0 and c:IsChainAttackable() then
	   Duel.ChainAttack()
	end
end
function c34340001.atcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	return phase~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c34340001.costfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c34340001.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34340001.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local ct=Duel.DiscardHand(tp,c34340001.costfilter,1,99,REASON_COST+REASON_DISCARD)
	e:SetLabel(ct)
end
function c34340001.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*300)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

