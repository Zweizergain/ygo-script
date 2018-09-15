--星刻荒神仪
local m=14000252
local cm=_G["c"..m]
cm.named_with_war=1
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.war(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_war
end
function cm.thfilter(c)
	return cm.war(c) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function cm.tgfilter(c,e,tp)
	return cm.war(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.spfilter(c,e,tp)
	return cm.war(c) and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if mg:GetCount()==0 then b1=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) else b1=true end
	if mg:GetCount()>=1 then b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 else b2=true end
	if mg:GetCount()>=2 then b3=Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) else b3=true end
	if chk==0 then return b1 and b2 and b3 end
	if mg:GetCount()==0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if mg:GetCount()>=1 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
	if mg:GetCount()>=2 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if mg:GetCount()>=2 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
				tc:RegisterFlagEffect(14000241,RESET_EVENT+0x1fe0000,0,0,0)
			end
		end
	end
	if mg:GetCount()>=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
				tc:RegisterFlagEffect(14000241,RESET_EVENT+0x1fe0000,0,0,0)
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,  LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
				local tc=g:GetFirst()
				if tc then
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,   true,POS_FACEUP)
					tc:CompleteProcedure()
				end
			end
		end
	end
	if mg:GetCount()==0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end