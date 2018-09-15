--浮幽旋风
function c10150028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10150028.condition)
	e1:SetTarget(c10150028.target)
	e1:SetOperation(c10150028.activate)
	c:RegisterEffect(e1)	
end

function c10150028.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:GetFirst():GetPreviousLocation()==LOCATION_EXTRA 
end

function c10150028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,30459350)
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_EXTRA)
end

function c10150028.activate(e,tp,eg,ep,ev,re,r,rp)
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		local g2=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
		Duel.ConfirmCards(tp,g1)
		Duel.ConfirmCards(1-tp,g2)
		g1:Merge(g2)
		local tc=eg:GetFirst()
		local tg=g1:Filter(Card.IsCode,nil,tc:GetCode())
		if tg:GetCount()>0 then
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
end
