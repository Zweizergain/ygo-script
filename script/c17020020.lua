--邪火装机 江户彼岸
function c17020020.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
	--to g
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17020020,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,17020020)
	e1:SetCondition(c17020020.tgcon)
	e1:SetTarget(c17020020.tgtg)
	e1:SetOperation(c17020020.tgop)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17020020,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17020120)
	e2:SetTarget(c17020020.thtg)
	e2:SetOperation(c17020020.thop)
	c:RegisterEffect(e2)
	--SP
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17020020,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCountLimit(1,17020220)
	e3:SetCost(c17020020.spcost)
	e3:SetTarget(c17020020.sptg)
	e3:SetOperation(c17020020.spop)
	c:RegisterEffect(e3) 
end
function c17020020.cfilter1(c,att)
	return c:IsType(TYPE_PENDULUM) and ((c:IsType(TYPE_MONSTER) and c:IsAttribute(att)) or (bit.band(c:GetOriginalAttribute(),att)~=0 and not c:IsType(TYPE_MONSTER))) and c:IsAbleToRemoveAsCost() and ((c:IsFaceup() and c:IsLocation(LOCATION_MZONE+LOCATION_EXTRA)) or c:IsLocation(LOCATION_HAND+LOCATION_GRAVE))
end
function c17020020.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c17020020.cfilter1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,ATTRIBUTE_EARTH)
	local g2=Duel.GetMatchingGroup(c17020020.cfilter1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,ATTRIBUTE_FIRE)
	local g3=Duel.GetMatchingGroup(c17020020.cfilter1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,ATTRIBUTE_WATER)
	local g4=Duel.GetMatchingGroup(c17020020.cfilter1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,ATTRIBUTE_WIND)
	local mg1,mg2,mg3,mg4=g1:Clone(),g2:Clone(),g3:Clone(),g4:Clone()
	mg1:AddCard(e:GetHandler())
	mg2:AddCard(e:GetHandler())
	mg3:AddCard(e:GetHandler())
	mg4:AddCard(e:GetHandler())
	if chk==0 then 
	   return e:GetHandler():IsAbleToRemoveAsCost() and g1:GetClassCount(Card.GetCode)>1 and g2:GetClassCount(Card.GetCode)>1 and g3:GetClassCount(Card.GetCode)>1 and g4:GetClassCount(Card.GetCode)>1 and (Duel.GetLocationCountFromEx(tp,mg1)>0 or Duel.GetLocationCountFromEx(tp,mg2)>0 or Duel.GetLocationCountFromEx(tp,mg3)>0 or Duel.GetLocationCountFromEx(tp,mg4)>0 or Duel.GetLocationCountFromEx(tp)>0) 
	end
	local tf1,tf2,tf3,tf4,mtf=false,false,false,false,false
	if Duel.GetLocationCountFromEx(tp,mg1)>0 then tf1=true end
	if Duel.GetLocationCountFromEx(tp,mg2)>0 then tf2=true end
	if Duel.GetLocationCountFromEx(tp,mg3)>0 then tf3=true end
	if Duel.GetLocationCountFromEx(tp,mg4)>0 then tf4=true end
	if Duel.GetLocationCountFromEx(tp)>0 then mtf=true end
	local sg,tc=Group.CreateGroup(),nil
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if not mtf and not tf2 and not tf3 and not tf4 then
		   tc=g1:FilterSelect(tp,c17020020.xfilter,1,1,nil,tp):GetFirst()
		else
		   tc=g1:Select(tp,1,1,nil):GetFirst()
		end
		if Duel.GetLocationCountFromEx(tp,tc)>0 then mtf=true end
		sg:AddCard(tc)
		g1:Remove(Card.IsCode,nil,tc:GetCode())  
	end
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if not mtf and not tf3 and not tf4 then
		   tc=g2:FilterSelect(tp,c17020020.xfilter,1,1,nil,tp):GetFirst()
		else
		   tc=g2:Select(tp,1,1,nil):GetFirst()
		end
		if Duel.GetLocationCountFromEx(tp,tc)>0 then mtf=true end
		sg:AddCard(tc)
		g2:Remove(Card.IsCode,nil,tc:GetCode())  
	end  
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if not mtf and not tf4 then
		   tc=g3:FilterSelect(tp,c17020020.xfilter,1,1,nil,tp):GetFirst()
		else
		   tc=g3:Select(tp,1,1,nil):GetFirst()
		end
		if Duel.GetLocationCountFromEx(tp,tc)>0 then mtf=true end
		sg:AddCard(tc)
		g3:Remove(Card.IsCode,nil,tc:GetCode())  
	end 
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		if not mtf then
		   tc=g4:FilterSelect(tp,c17020020.xfilter,1,1,nil,tp):GetFirst()
		else
		   tc=g4:Select(tp,1,1,nil):GetFirst()
		end
		if Duel.GetLocationCountFromEx(tp,tc)>0 then mtf=true end
		sg:AddCard(tc)
		g4:Remove(Card.IsCode,nil,tc:GetCode())  
	end 
	sg:AddCard(e:GetHandler())
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c17020020.filter(c,e,tp)
	return c:IsCode(17020019) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true)
end
function c17020020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17020020.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c17020020.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c17020020.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c17020020.xfilter(c,tp)
	return Duel.GetLocationCountFromEx(tp,c)>0
end
function c17020020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   local g=eg:Filter(c17020020.cfilter,nil,tp)
	   return g:GetCount()>0 and Duel.IsExistingMatchingCard(c17020020.thfilter,tp,LOCATION_DECK,0,1,nil,g)
	end
	local g=eg:Filter(c17020020.cfilter,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17020020.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_PZONE+LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsType(TYPE_PENDULUM)
end
function c17020020.thfilter(c,g)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and not g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c17020020.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17020020.thfilter,tp,LOCATION_DECK,0,1,1,nil,g)
	if g:GetCount()<=0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
function c17020020.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c17020020.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48976825,0))
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,LOCATION_REMOVED)
end
function c17020020.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
