--朱星曜兽-井木犴
function c21520122.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c21520122.spcon)
	c:RegisterEffect(e1)
end
function c21520122.spfilter(c)
	return c:IsSetCard(0x491) and c:IsFaceup()
end
function c21520122.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c21520122.spfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=g:GetCount()
	return ct>=2
end
