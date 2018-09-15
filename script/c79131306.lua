--灵噬 琉纳斯
function c79131306.initial_effect(c)
	--return to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79131306,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79131306)
	e1:SetCost(c79131306.rtgcost)
	e1:SetTarget(c79131306.rtgtg)
	e1:SetOperation(c79131306.rtgop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79131306,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,79131307)
	e2:SetCost(c79131306.cttg)
	e2:SetOperation(c79131306.ctop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79131306,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,79131307)
	e3:SetCost(c79131306.spcost)
	e3:SetTarget(c79131306.sptg)
	e3:SetOperation(c79131306.spop)
	c:RegisterEffect(e3)
end
function c79131306.rtgfilter(c)
	return c:IsSetCard(0x1201) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c79131306.rtgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206,1,REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206,1,REASON_COST)
end
function c79131306.rtgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c79131306.rtgfilter(chkc) and chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c79131306.rtgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48976825,0))
	local g=Duel.SelectTarget(tp,c79131306.rtgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_REMOVED)
end
function c79131306.rtgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(79131306,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c79131306.thfilter(c,code)
	return c:IsSetCard(0x1201) and c:IsAbleToHand() and not c:IsCode(code)
end
function c79131306.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c79131306.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c79131306.ctfilter(chkc) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c79131306.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c79131306.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0,0x1206)
end
function c79131306.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x1206,1)
		if Duel.IsExistingMatchingCard(c79131306.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) and Duel.SelectYesNo(tp,aux.Stringid(79131306,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c79131306.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler():GetCode())
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c79131306.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1201) and c:IsAbleToRemoveAsCost()
end
function c79131306.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79131306.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c79131306.costfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c79131306.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79131306.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end