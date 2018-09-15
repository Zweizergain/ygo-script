--苍翼佣兵团 切尼
function c10101010.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6330),aux.NonTuner(Card.IsSetCard,0x6330),1)
	c:EnableReviveLimit()   
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(c10101010.condition)
	e1:SetTarget(c10101010.target)
	e1:SetOperation(c10101010.operation)
	c:RegisterEffect(e1)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetCountLimit(2)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c10101010.reptg)
	e3:SetOperation(c10101010.repop)
	c:RegisterEffect(e3)
end
function c10101010.repfilter(c)
	return c:IsSetCard(0x6630) and c:IsType(TYPE_MONSTER) and ((c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove()) or ((c:IsLocation(LOCATION_REMOVED)) and c:IsFaceup()))
end
function c10101010.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c10101010.repfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(10101010,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10101010,2))
		local g=Duel.SelectMatchingCard(tp,c10101010.repfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		Duel.SetTargetCard(g)
		return true
	else return false end
end
function c10101010.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):GetFirst()
	if tc:IsLocation(LOCATION_GRAVE) then
	   Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	else
	   Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
function c10101010.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsAttackAbove(c:GetAttack())
end
function c10101010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc:IsAbleToRemove() end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function c10101010.operation(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetFirstTarget()
	if bc:IsRelateToEffect(e) then
	   Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end