--从者Saber 宫本武藏
function c22000440.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3,c22000440.ovfilter,aux.Stringid(22000440,0),3,c22000440.xyzop)
	c:EnableReviveLimit()
	--multiatk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22000440,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22000440.atkcon)
	e1:SetCost(c22000440.atkcost)
	e1:SetTarget(c22000440.atktg)
	e1:SetOperation(c22000440.atkop)
	c:RegisterEffect(e1)
	--double
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c22000440.damcon)
	e2:SetOperation(c22000440.damop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22000440,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c22000440.atkcon1)
	e3:SetCost(c22000440.atkcost1)
	e3:SetOperation(c22000440.atkop1)
	c:RegisterEffect(e3)
end
function c22000440.cfilter(c)
	return c:IsSetCard(0xfff) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c22000440.ovfilter(c)
	return c:IsFaceup() and c:IsCode(22000430) and c:GetOverlayCount()==3
end
function c22000440.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22000440.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c22000440.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c22000440.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c22000440.costfilter(c)
	return c:IsSetCard(0xffd) and c:IsDiscardable()
end
function c22000440.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22000440.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c22000440.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c22000440.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c22000440.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c22000440.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c22000440.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c22000440.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,22000430)
end
function c22000440.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) and c:GetFlagEffect(22000440)==0 end
	c:RemoveOverlayCard(tp,2,2,REASON_COST)
	c:RegisterFlagEffect(22000440,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c22000440.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(6000)
		c:RegisterEffect(e1)
	end
end
