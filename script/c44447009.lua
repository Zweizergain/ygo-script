--百夜·零尔
function c44447009.initial_effect(c)
	c:EnableReviveLimit()
	--Normal monster
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetCode(EFFECT_CHANGE_LEVEL)
	e12:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e12:SetValue(4)
	c:RegisterEffect(e12)
	--Activate
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_IGNITION)
	e14:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e14:SetCode(EVENT_FREE_CHAIN)
	e14:SetRange(LOCATION_HAND+LOCATION_ONFIELD)
	e14:SetCountLimit(1,44447009)
	e14:SetCost(c44447009.cost)
	e14:SetTarget(c44447009.target)
	e14:SetOperation(c44447009.activate)
	c:RegisterEffect(e14)
end
function c44447009.costfilter(c)
	return c:IsSetCard(0x644) and c:IsAbleToGraveAsCost()
end
function c44447009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and 
		Duel.IsExistingMatchingCard(c44447009.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c44447009.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c44447009.filter(c,tp)
	return bit.band(c:GetType(),0x82)==0x82 and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c44447009.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function c44447009.filter2(c,mc)
	return bit.band(c:GetType(),0x81)==0x81 and not c:IsForbidden() and c44447009.isfit(c,mc)
end
function c44447009.isfit(c,mc)
	return mc.fit_monster and c:IsCode(table.unpack(mc.fit_monster))
end
function c44447009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44447009.filter,tp,LOCATION_DECK,0,1,nil,tp) 
	and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c44447009.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c44447009.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c44447009.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,g:GetFirst())
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			g:Merge(sg)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local tc=sg:GetFirst()
	        if tc then
		    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
			Duel.ConfirmCards(1-tp,tc)
		    local e1=Effect.CreateEffect(e:GetHandler())
	        e1:SetType(EFFECT_TYPE_SINGLE)
	        e1:SetCode(EFFECT_CHANGE_TYPE)
		    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	        e1:SetValue(TYPE_SPELL)
		    e1:SetReset(RESET_EVENT+0x1fe0000)
	        tc:RegisterEffect(e1)
	        end
		end
	end
end

