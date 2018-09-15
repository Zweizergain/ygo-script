--Guardian Shield
function c140000140.initial_effect(c)
        --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c140000140.target)
	e1:SetOperation(c140000140.operation)
	c:RegisterEffect(e1)
        --Gains 300 DEF
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(300)
	c:RegisterEffect(e2)
        --Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c140000140.eqlimit)
	c:RegisterEffect(e3)
        --Destruction Replace
        local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c140000140.destg)
	e4:SetValue(1)
	e4:SetOperation(c140000140.desop)
	c:RegisterEffect(e4)
end
function c140000140.eqlimit(e,c)
	return c:IsFaceup()
end
function c140000140.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c140000140.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c140000140.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c140000140.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c140000140.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c140000140.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tc=eg:GetFirst()
		return bit.band(r,REASON_BATTLE)~=0 and tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x52)
	end
	return Duel.SelectYesNo(tp,"Destroy 'Guardian Shield' instead of the monster?")
end
function c140000140.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
