--拟兽百烈拳
function c10124009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10124009+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10124009.condition)
	e1:SetTarget(c10124009.target)
	e1:SetOperation(c10124009.activate)
	c:RegisterEffect(e1)	   
end

function c10124009.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6334) and (((c:GetSequence()==6 or c:GetSequence()==7) and c:IsLocation(LOCATION_SZONE)) or c:IsLocation(LOCATION_MZONE))
end
function c10124009.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10124009.cfilter,tp,LOCATION_ONFIELD,0,3,nil)
end
function c10124009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c10124009.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		 local tc=g:GetFirst()
		  while tc do
			if Duel.Destroy(tc,REASON_EFFECT)==0 then
			   Duel.Remove(tc,POS_FACEUP,REASON_RULE)
			end
		   tc=g:GetNext()
		  end
	end
end
