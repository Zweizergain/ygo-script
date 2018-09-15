--光之月灵术 闪
function c19002042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetCost(c19002042.cost)
	e1:SetTarget(c19002042.target)
	e1:SetOperation(c19002042.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c19002042.handcon)
	c:RegisterEffect(e2)	  
end
function c19002042.cfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(c19002042.ccfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp,c)
end
function c19002042.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c19002042.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c19002042.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c19002042.ccfilter(c,tp,rc)
	local g=Group.FromCards(c)
	if rc then g:AddCard(rc) end
	return c:IsFaceup() and c:IsAttackAbove(1) and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,g)
end
function c19002042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c19002042.ccfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19002042,0))
	local g1=Duel.SelectTarget(tp,c19002042.ccfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19002042,1))
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1:GetFirst())
end
function c19002042.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if hc:IsFaceup() and hc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=hc:GetAttack()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		hc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		hc:RegisterEffect(e2)
		local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetCode(EFFECT_SET_ATTACK_FINAL)
		e11:SetReset(RESET_EVENT+RESETS_STANDARD)
		e11:SetValue(0)
		if hc:RegisterEffect(e11) then
			local e21=Effect.CreateEffect(e:GetHandler())
			e21:SetType(EFFECT_TYPE_SINGLE)
			e21:SetCode(EFFECT_UPDATE_ATTACK)
			e21:SetReset(RESET_EVENT+RESETS_STANDARD)
			e21:SetValue(atk)
			tc:RegisterEffect(e21)
		end
	end
end
function c19002042.hfilter(c)
	return c:IsFaceup() and c:IsCode(19002010,19002020)
end
function c19002042.handcon(e)
	return Duel.IsExistingMatchingCard(c19002042.hfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end