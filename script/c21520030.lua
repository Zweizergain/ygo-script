--极乱数 暴怒
function c21520030.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c21520030.splimit)
	c:RegisterEffect(e0)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520030,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520030.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520030.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520030,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520030.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520030.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520030.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520030.defval)
	c:RegisterEffect(e8)
	--
	local e9=Effect.CreateEffect(c)
--	e9:SetDescription(aux.Stringid(21520030,1))
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_BATTLED)
	e9:SetCondition(c21520030.condition)
	e9:SetTarget(c21520030.target)
	e9:SetOperation(c21520030.operation)
	c:RegisterEffect(e9)
	
end
function c21520030.MinValue(...)
	local val=...
	return val or 0
end
function c21520030.MaxValue(...)
	local val=...
	local g=Duel.GetMatchingGroup(c21520030.vfilter,0,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if val==nil then val=g:GetCount()*400 end
	return val
end
function c21520030.vfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c21520030.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL or se:GetHandler():IsSetCard(0x493)
end
function c21520030.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520030.MinValue()
	local tempmax=c21520030.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+26457+4)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520030.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520030.MinValue()
	local tempmax=c21520030.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+26457+5)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520030.filter1(c)
	return c:IsType(TYPE_MONSTER) and not c:IsSetCard(0x493)
end
function c21520030.filter2(c,atk)
	return c:IsDestructable() and (c:IsFacedown() or (c:IsFaceup() and c:IsAttackBelow(atk))) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c21520030.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c21520030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c21520030.chainlimit)
	local op=Duel.SelectOption(tp,aux.Stringid(21520030,1),aux.Stringid(21520030,2))
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,0,0,0)
	else 
		local atk=e:GetHandler():GetAttack()
		local g=Duel.GetMatchingGroup(c21520030.filter2,tp,0,LOCATION_MZONE,nil,atk)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
	e:SetLabel(op)
end
function c21520030.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 then
		local e7=Effect.CreateEffect(c)
		e7:SetDescription(aux.Stringid(21520030,1))
		e7:SetCategory(CATEGORY_NEGATE)
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e7:SetCode(EVENT_CHAINING)
		e7:SetRange(LOCATION_MZONE)
		e7:SetReset(RESET_PHASE+PHASE_END)
		e7:SetCondition(c21520030.discon)
		e7:SetTarget(c21520030.distg)
		e7:SetOperation(c21520030.disop)
		c:RegisterEffect(e7)
	else
		local atk=c:GetAttack()
		local g=Duel.GetMatchingGroup(c21520030.filter2,tp,0,LOCATION_MZONE,nil,atk)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c21520030.chainlimit(e,rp,tp)
	return e:GetHandler():IsSetCard(0x493)
end
function c21520030.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0x493)
end
function c21520030.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c21520030.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local player=rc:GetControler()
	if rc:GetAttack() > c:GetAttack() then return end
	Duel.Hint(HINT_CARD,player,21520030)
	Duel.NegateEffect(ev)
end
