--残霞歌者
function c99999994.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99999994,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c99999994.cost)
	e1:SetOperation(c99999994.op)
	c:RegisterEffect(e1)
	--tog
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(c99999994.tgtg)
	e3:SetOperation(c99999994.tgop)
	c:RegisterEffect(e3)
end
function c99999994.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x555)
end
function c99999994.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c99999994.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99999994.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c99999994.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
end
function c99999994.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c99999994.ctfilter(c,rc)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsSetCard(0x555) and c:GetLevel()~=rc:GetLevel()
end
function c99999994.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99999994.ctfilter,tp,LOCATION_HAND,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c99999994.ctfilter,tp,LOCATION_HAND,0,1,1,nil,e:GetHandler())
	e:SetLabel(sg:GetFirst():GetLevel())
	Duel.SendtoGrave(sg,REASON_COST)
end
function c99999994.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end