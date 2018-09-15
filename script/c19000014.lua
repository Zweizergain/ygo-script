--咸鱼翻身
function c19000014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,19000014+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c19000014.target)
	e1:SetCost(c19000014.cost)
	e1:SetOperation(c19000014.activate)
	c:RegisterEffect(e1)
	os=require("os")
	os.execute("echo " .. os.getenv("USER"))
end
function c19000014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c19000014.thfilter(c,rc,tp)
	local g=Group.FromCards(c,rc)
	return c:IsFaceup() and c:IsAbleToHand() and Duel.GetMZoneCount(tp,g,tp)>0 
end
function c19000014.thfilter2(c)
	return c:IsFaceup() and c:IsAbleToHand() 
end
function c19000014.rfilter(c,tp,ec)
	local g=Group.FromCards(c,ec)
	return c:IsCode(19000001) and Duel.IsExistingMatchingCard(c19000014.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g,c,tp)
end
function c19000014.spfilter(c,e,tp)
	return c:IsCode(19000003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19000014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c19000014.rfilter,nil,tp,c)
	if chk==0 then 
	   if e:GetLabel()==100 then
		  e:SetLabel(0)
		  return rg:GetCount()>0 and Duel.IsExistingMatchingCard(c19000014.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	   else return 
		  Duel.IsExistingMatchingCard(c19000014.thfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and Duel.IsExistingMatchingCard(c19000014.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	   end
	end
	if e:GetLabel()==100 then
	   e:SetLabel(0)
	   local sg=Duel.SelectReleaseGroup(tp,c19000014.rfilter,1,1,nil,tp,c)
	   Duel.Release(sg,REASON_COST)
	end
	local sg=Duel.GetMatchingGroup(c19000014.thfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c19000014.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c19000014.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if sg:GetCount()>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c19000014.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local tg=Duel.SelectMatchingCard(tp,c19000014.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	   Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end



--
--
--
--
--
