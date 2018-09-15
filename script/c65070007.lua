--大地之书
function c65070007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65070007.target)
	e1:SetOperation(c65070007.activate)
	c:RegisterEffect(e1)
end
function c65070007.filter(c,e)
	return c:IsFaceup() and c:IsCanTurnSet() and not c:IsLocation(LOCATION_PZONE) and c~=e:GetHandler()
end
function c65070007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c65070007.filter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(c65070007.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c65070007.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c65070007.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_SZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN)
	end
end