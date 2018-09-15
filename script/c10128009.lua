--奇妙物语 奇妙小伙伴
function c10128009.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()   
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10128009,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c10128009.tgcon)
	e1:SetCost(c10128009.tgcost)
	e1:SetTarget(c10128009.tgtg)
	e1:SetOperation(c10128009.tgop)
	c:RegisterEffect(e1) 
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10128009.reptg)
	e2:SetOperation(c10128009.repop)
	c:RegisterEffect(e2)
end
function c10128009.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and c:GetDestination()~=LOCATION_DECK and c:GetDestination()~=LOCATION_HAND end
	return true
end
function c10128009.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	Duel.SendtoDeck(c,nil,2,REASON_REDIRECT)
	local sg=g:Filter(c10128009.thfilter,nil,tp)
	if sg:GetCount()>0 and c:IsLocation(LOCATION_EXTRA) and Duel.SelectYesNo(tp,aux.Stringid(10128009,1)) then 
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local tc=g:Select(tp,1,1,nil):GetFirst()
	   if tc and not tc:IsHasEffect(EFFECT_NECRO_VALLEY) then
		  Duel.SendtoHand(tc,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,tc)
	   end	
	end
end
function c10128009.thfilter(c,tp)
	return bit.band(c:GetType(),0x10002)==0x10002 and c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand()
end
function c10128009.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c10128009.confilter,1,nil)
end
function c10128009.confilter(c)
	return bit.band(c:GetType(),0x10002)==0x10002
end
function c10128009.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10128009.tgfilter(c)
	return bit.band(c:GetType(),0x10002)==0x10002 and c:IsAbleToGrave()
end
function c10128009.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10128009.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD)
end
function c10128009.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10128009.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if dg:GetCount()>0 then
			Duel.HintSelection(dg)
			Duel.SendtoDeck(dg,nil,1,REASON_EFFECT)
		end
	end
end