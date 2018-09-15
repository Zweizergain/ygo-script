--咸鱼决斗
function c19000015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c19000015.target)
	e2:SetValue(1)
	c:RegisterEffect(e2) 
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c19000015.descon)
	e3:SetOperation(c19000015.desop)
	c:RegisterEffect(e3)
end
function c19000015.target(e,c)
	return c:IsSetCard(0x1750) 
end
function c19000015.check(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x1750) 
end
function c19000015.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil and (c19000015.check(Duel.GetAttacker(),tp) or c19000015.check(Duel.GetAttackTarget(),tp))
end
function c19000015.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,19000015)
	if c19000015.check(Duel.GetAttacker(),tp) then
	   Duel.Destroy(Duel.GetAttacker(),REASON_EFFECT)
	else
	   Duel.Destroy(Duel.GetAttackTarget(),REASON_EFFECT)
	end
end--
--
--
--
--
