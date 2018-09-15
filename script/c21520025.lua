--极乱数 妖精
function c21520025.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c21520025.tunerfilter,nil,2)
	c:EnableReviveLimit()
	--change level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520025,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520025.rlevel)
	c:RegisterEffect(e1)
	--summons
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520025,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xbf,0xbf)
	e2:SetOperation(c21520025.rlevel)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e4)
	--atk & def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c21520025.valoperation)
	c:RegisterEffect(e6)
	--to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(21520025,1))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetOperation(c21520025.ddop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e8)
end
function c21520025.rlevel(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+17320+2)
	local val=math.random(1,900)
	val=math.fmod(val,9)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(val)
	c:RegisterEffect(e1)
end
function c21520025.valoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local val=0
	while tc do
		if not tc:IsType(TYPE_XYZ) then
			val=val+tc:GetLevel()*360
		end
		tc=g:GetNext()
	end
	if c:GetSummonType()~=SUMMON_TYPE_SYNCHRO then
		val=math.ceil(val/2)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
end
function c21520025.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
--		e4:SetCondition(c21520025.damcon)
		e4:SetOperation(c21520025.damop)
		c:RegisterEffect(e4)
		c:RegisterFlagEffect(21520025,RESET_PHASE+PHASE_BATTLE,0,1)
		--down
		local e9=Effect.CreateEffect(c)
		e9:SetDescription(aux.Stringid(21520025,2))
		e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e9:SetCode(EVENT_BATTLED)
		e9:SetCondition(c21520025.dacon)
		e9:SetOperation(c21520025.daop)
		c:RegisterEffect(e9)
	end
end
function c21520025.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c21520025.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+17320+10)
	local ct=math.random(1,8)
	local dhint=ct+2
--	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(21520025,dhint))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(21520025,dhint))
	Duel.ChangeBattleDamage(ep,ev*ct/4)
end
function c21520025.dacon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(21520025)~=0
end
function c21520025.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1024)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function c21520025.tunerfilter(c)
	return c:GetTextAttack()<0 --and c:GetTextDefense()<0
end
