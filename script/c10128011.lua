--奇妙物语 奇妙超大卷
function c10128011.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()  
	--immue
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10128011,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c10128011.imcon)
	e1:SetCost(c10128011.imcost)
	e1:SetTarget(c10128011.imtg)
	e1:SetOperation(c10128011.imop)
	c:RegisterEffect(e1) 
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10128011.reptg)
	e2:SetOperation(c10128011.repop)
	c:RegisterEffect(e2)
end
function c10128011.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and c:GetDestination()~=LOCATION_DECK and c:GetDestination()~=LOCATION_HAND end
	return true
end
function c10128011.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoDeck(c,nil,2,REASON_REDIRECT)
	local tg=Duel.GetMatchingGroup(c10128011.imfilter,tp,LOCATION_DECK,0,nil)
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if tg:GetCount()>0 and dg:GetCount()>0 and c:IsLocation(LOCATION_EXTRA) and Duel.SelectYesNo(tp,aux.Stringid(10128011,1)) then 
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	   local tg2=tg:Select(tp,1,1,nil)
			 if Duel.SendtoGrave(tg2,REASON_EFFECT)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local dg2=dg:Select(tp,1,1,nil)
				Duel.Destroy(dg2,REASON_EFFECT)
			 end
	end
end
function c10128011.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c10128011.confilter,1,nil)
end
function c10128011.confilter(c)
	return bit.band(c:GetType(),0x10002)==0x10002
end
function c10128011.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10128011.imfilter(c)
	return bit.band(c:GetType(),0x10002)==0x10002 and c:IsAbleToGrave()
end
function c10128011.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10128011.imfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10128011.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10128011.imfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c10128011.efilter)
		e1:SetOwnerPlayer(tp)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		c:RegisterEffect(e1)
	end
end
function c10128011.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end