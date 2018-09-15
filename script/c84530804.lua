--幻灭神话 妖精·神宛
function c84530804.initial_effect(c)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84530804,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,84530804)
	e1:SetCondition(c84530804.atkcon)
	e1:SetCost(c84530804.atkcost)
	e1:SetTarget(c84530804.atktg)
	e1:SetOperation(c84530804.atkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
		--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(84530804,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c84530804.tg)
	e3:SetOperation(c84530804.op)
	c:RegisterEffect(e3)
end
function c84530804.atkfilter(c,e,tp)
	return c:IsControler(tp) and (c:GetLevel()==1 or c:GetRank()==1 or c:GetLink()==1) and c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x8351) and (not e or c:IsRelateToEffect(e))
end
function c84530804.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c84530804.atkfilter,1,nil,nil,tp)
end
function c84530804.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c84530804.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c84530804.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c84530804.atkfilter,nil,e,tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:IsAttack(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
end
function c84530804.matfilter(c)
	return (c:GetLevel()==1 or c:GetRank()==1 or c:GetLink()==1) and c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x8351)
end
function c84530804.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c84530804.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c84530804.matfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c84530804.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c84530804.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c84530804.acon)
	e2:SetOperation(c84530804.aop)
	tc:RegisterEffect(e2)
	end
end
function c84530804.acon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end
function c84530804.aop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
	end
end