--闪光拳
function c10150024.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10150024.target)
	e1:SetOperation(c10150024.activate)
	c:RegisterEffect(e1)	 
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150024,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCost(c10150024.atkcost)
	e2:SetTarget(c10150024.atktg)
	e2:SetOperation(c10150024.atkop)
	c:RegisterEffect(e2)
end

function c10150024.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c10150024.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10150024.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10150024.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10150024.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end

function c10150024.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(2000)
		tc:RegisterEffect(e1)
	end
end

function c10150024.filter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR)
end

function c10150024.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR) and c:GetFlagEffect(10150024)==0
end

function c10150024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10150024.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10150024.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10150024.filter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c10150024.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(10150024)==0 then
			tc:RegisterFlagEffect(10150024,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				--destroy
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(20366274,1))
				e1:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
				e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
				e1:SetCode(EVENT_BATTLE_START)
				e1:SetCountLimit(2)
				e1:SetCondition(c10150024.descon)
				e1:SetTarget(c10150024.destg)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetOperation(c10150024.desop)
				tc:RegisterEffect(e1)
		end
	end
end

function c10150024.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end

function c10150024.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,bc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end

function c10150024.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and Duel.ChangePosition(c,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)>0 and bc:IsRelateToBattle() then
	Duel.SendtoHand(bc,nil,REASON_EFFECT)
	end
end

