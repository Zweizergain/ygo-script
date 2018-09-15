--猛毒性 蜈蚣属
function c24562459.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,24562456,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),1,false,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c24562459.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24562459,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DAMAGE)
	e2:SetCondition(c24562459.e2con)
	e2:SetTarget(c24562459.e2tg)
	e2:SetOperation(c24562459.e2op)
	c:RegisterEffect(e2)
end
function c24562459.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsCode(24562458)
end
function c24562459.e6dmcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil and e:GetOwnerPlayer()==tp
end
function c24562459.e6dmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c24562459.e5con(e)
	return e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c24562459.e4limit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c24562459.e4con(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and c:GetBattleTarget()~=nil
		and e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c24562459.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c24562459.e2op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return false end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x1390) then
		local c=e:GetHandler()
		if c:IsFaceup() and c:GetFlagEffect(24562459)==0 then
			c:RegisterFlagEffect(24562459,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetCode(EFFECT_CANNOT_ACTIVATE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetTargetRange(0,1)
			e4:SetCondition(c24562459.e4con)
			e4:SetValue(c24562459.e4limit)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_PIERCE)
			e5:SetCondition(c24562459.e5con)
			e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e5)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e6:SetCode(EVENT_PRE_BATTLE_DAMAGE)
			e6:SetCondition(c24562459.e6dmcon)
			e6:SetOperation(c24562459.e6dmop)
			e6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e6)
		end
	else
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		Duel.Damage(1-tp,700,REASON_EFFECT)
	end
end
function c24562459.e2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end