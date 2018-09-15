--白魔术恶魔
function c34340004.initial_effect(c)
	--base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c34340004.atkval)
	c:RegisterEffect(e1)	
end
c34340004.setname="WhiteMagician"
function c34340004.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c.setname=="WhiteMagician"
end
function c34340004.atkval(e,c)
	return Duel.GetMatchingGroupCount(c34340004.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*200
end
