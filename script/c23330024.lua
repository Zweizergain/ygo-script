--残霞之辉
function c23330024.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x555),1,1)  
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c23330024.indtg)
	e2:SetValue(200)
	c:RegisterEffect(e2)
end
function c23330024.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end