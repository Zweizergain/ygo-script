--MONSTER Melba
function c13301905.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(c13301905.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c13301905.desfilter(c,tp)
	return c:IsCode(13301902) and c:IsPosition(POS_FACEUP) 
end
function c13301905.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c13301905.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),nil)
	Duel.Destroy(sg,REASON_EFFECT)
end