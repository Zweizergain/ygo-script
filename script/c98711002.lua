--吸血鬼女郎·改
function c98711002.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98711002,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,98711002)
	e1:SetCondition(c98711002.tgcon)
	e1:SetTarget(c98711002.tgtg)
	e1:SetOperation(c98711002.tgop)
	c:RegisterEffect(e1)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c98711002.aclimcon)
	e1:SetOperation(c98711002.aclimop)
	c:RegisterEffect(e1)
end
function c98711002.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) or e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c98711002.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(tp,70,71,72)
	e:SetLabel(bit.lshift(1,op))
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98711002.tgfilter(c,ty)
	return c:IsType(ty) and c:IsAbleToGrave()
end
function c98711002.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(1-tp,c98711002.tgfilter,1-tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c98711002.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g1:GetCount()~=1 then
		local dg1=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
		Duel.ConfirmCards(tp,dg1)
	end
	if g2:GetCount()~=1 then
		local dg2=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		Duel.ConfirmCards(1-tp,dg2)
	end
	g1:Merge(g2)
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
end
function c98711002.aclimcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c98711002.aclimop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c98711002.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98711002.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
