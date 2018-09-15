--猛毒性 厉蝎
function c24562462.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c24562462.lcheck)
	local e1=Effect.CreateEffect(c)
	e1:SetOperation(c24562462.dmgop)
	e1:SetCondition(c24562462.e1con)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24562462,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c24562462.e2con)
	e2:SetOperation(c24562462.e2op)
	c:RegisterEffect(e2)
end
function c24562462.e1con(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker():GetControler()==tp then
	if Duel.GetAttackTarget()==nil then return false end
	end
	return true
end
function c24562462.dmgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if Duel.GetAttackTarget()==nil then return false end
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
		local e5=Effect.CreateEffect(c)
		e5:SetCategory(CATEGORY_DAMAGE)
		e5:SetType(EFFECT_TYPE_QUICK_F)
		e5:SetCode(EVENT_CHAINING)
		e5:SetRange(LOCATION_MZONE)
		e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e5:SetCost(c24562462.e5cost)
		e5:SetTarget(c24562462.e5tg)
		e5:SetOperation(c24562462.e5op)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e5)
		tc:RegisterFlagEffect(24562462,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(24562462,0))
end
function c24562462.e5op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c24562462.e5tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,500)
end
function c24562462.e5cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c24562462.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c24562462.e2con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetLinkedGroupCount()>0
end
function c24562462.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x1390)
end
function c24562462.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gc=c:GetLinkedGroupCount()
	if gc<=0 then return end
	if c:IsRelateToEffect(e) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EXTRA_ATTACK)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(gc)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
end