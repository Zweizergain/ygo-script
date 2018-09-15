--猛毒性 霾岩丸
function c24562460.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c24562460.matfilter,1)
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c24562460.e3cost)
	e3:SetTarget(c24562460.e3tg)
	e3:SetOperation(c24562460.e3op)
	c:RegisterEffect(e3)
end
function c24562460.e3cfil(c)
	return c:IsSetCard(0x1390) and c:IsAbleToRemoveAsCost()
end
function c24562460.e3cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable()
		and Duel.IsExistingMatchingCard(c24562460.e3cfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24562460.e3cfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Release(c,REASON_COST)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c24562460.e3tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c24562460.e3op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLocation(LOCATION_ONFIELD) then
	  local e2=Effect.CreateEffect(tc)
	  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	  e2:SetDescription(aux.Stringid(24562460,0))
	  e2:SetCategory(CATEGORY_DAMAGE)
	  e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	  e2:SetRange(LOCATION_ONFIELD)
	  e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	  e2:SetCountLimit(1)
	  e2:SetCondition(c24562460.e2damcon)
	  e2:SetTarget(c24562460.e2damtg)
	  e2:SetOperation(c24562460.e2damop)
	  e2:SetReset(RESET_EVENT+0x1fe0000)
	  tc:RegisterEffect(e2)
	end
end
function c24562460.e2damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c24562460.e2damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,800)
end
function c24562460.e2damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c24562460.matfilter(c)
	return c:IsLinkSetCard(0x1390) and not c:IsLinkCode(24562460)
end