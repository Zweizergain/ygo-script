--自古弓兵多挂B！
function c2026.initial_effect(c)
	--装备
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c2026.eqtg)
	e2:SetOperation(c2026.eqop)   
	c:RegisterEffect(e2)
end
function c2026.filter(c)
	return c:IsSetCard(0x202)
end
function c2026.filter1(c)
	return c:IsSetCard(0x206) 
end
function c2026.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c2026.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c2026.filter,tp,LOCATION_EXTRA,0,1,nil) 
		and Duel.IsExistingTarget(c2026.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c2026.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c2026.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=1 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g1=Duel.SelectMatchingCard(tp,c2026.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	local gc=g1:GetFirst()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,gc,tc) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		gc:RegisterEffect(e1)   
	end
end
function c2026.eqlimit(e,c)
	return e:GetOwner()==c
end