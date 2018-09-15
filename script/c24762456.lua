--猛毒性 杏
function c24762456.initial_effect(c)
	aux.EnableDualAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(c24762456.e1tg)
	e1:SetOperation(c24762456.e1op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24762456,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(c24762456.e2con)
	e2:SetTarget(c24762456.rettg)
	e2:SetOperation(c24762456.retop)
	c:RegisterEffect(e2)
end
function c24762456.e2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(24762456)~=0
end
function c24762456.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c24762456.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	  if c:IsRelateToEffect(e) and c:IsFaceup() then
		  Duel.SendtoHand(c,nil,REASON_EFFECT)
	  end
end
function c24762456.e1op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c24762456.e2fil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c24762456.e1fil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	end
end
function c24762456.e1fil(c)
	return c:IsSetCard(0x1390) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c24762456.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24762456.e2fil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	e:GetHandler():RegisterFlagEffect(24762456,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end