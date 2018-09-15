--超维母体
function c10113076.initial_effect(c)
	--Fusion, Synchro or Xyz
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113076,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,10113076)
	e1:SetTarget(c10113076.sptg)
	e1:SetOperation(c10113076.spop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--to extra
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10113176)
	e3:SetCost(c10113076.tdcost)
	e3:SetTarget(c10113076.tdtg)
	e3:SetOperation(c10113076.tdop)
	c:RegisterEffect(e3)	 
end
function c10113076.filter1(c,e,tp,chkf)
	return Duel.IsExistingMatchingCard(c10113076.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,chkf)
end
function c10113076.filter2(c,e,tp,fc)
	local mg=Group.FromCards(fc,e:GetHandler())
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil,chkf) and fc:IsCanBeFusionMaterial(c) and e:GetHandler():IsCanBeFusionMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,mg)>0
end
function c10113076.filter3(c,e,tp,chkf)
	return not c:IsImmuneToEffect(e) and Duel.IsExistingMatchingCard(c10113076.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c10113076.sxfilter(c,mc,tp)
	return Duel.IsExistingMatchingCard(c10113076.sxfilter2,tp,LOCATION_HAND,0,1,nil,c,mc)
end
function c10113076.sxfilter2(c,mc1,mc2)
	local mg=Group.FromCards(c,mc2)
	return c:IsType(TYPE_MONSTER) and (mc1:IsXyzSummonable(mg,2,2) or mc1:IsSynchroSummonable(nil,mg))
end
function c10113076.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c,mg=e:GetHandler(),Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
	if chk==0 then
		local sel=0
		local chkf=tp
		if mg:IsExists(c10113076.filter1,1,nil,e,tp,chkf) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(c10113076.sxfilter,tp,LOCATION_EXTRA,0,1,nil,c,tp) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		sel=Duel.SelectOption(tp,aux.Stringid(10113076,1),aux.Stringid(10113076,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(10113076,1))
	else
		Duel.SelectOption(tp,aux.Stringid(10113076,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10113076.spop(e,tp,eg,ep,ev,re,r,rp)
	local op,c,mg,g1,tc=e:GetLabel(),e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	if op==1 then
	   local chkf=tp
	   mg=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	   g1=mg:FilterSelect(tp,c10113076.filter3,1,1,nil,e,tp,chkf)
	   if g1:GetCount()<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   tc=Duel.SelectMatchingCard(tp,c10113076.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g1:GetFirst(),chkf):GetFirst()
	   g1:AddCard(c)
	   tc:SetMaterial(g1)
	   Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_FUSION+REASON_EFFECT)
	   Duel.BreakEffect()
	   Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	   tc:CompleteProcedure()
	else
	   mg=Duel.GetMatchingGroup(c10113076.sxfilter,tp,LOCATION_EXTRA,0,nil,c,tp)
	   if mg:GetCount()<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   tc=mg:Select(tp,1,1,nil):GetFirst()
	   mg=Duel.GetMatchingGroup(c10113076.sxilter2,tp,LOCATION_HAND,0,nil,tc,c)
	   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10113076,4))
	   local tc2=mg:Select(tp,1,1,nil):GetFirst()
	   mg=Group.FromCards(c,tc2)
	   if tc:IsXyzSummonable(mg,2,2) and tc:IsSynchroSummonable(nil,mg) then
		  op=Duel.SelectOption(tp,aux.Stringid(10113076,5),aux.Stringid(10113076,6))
	   elseif tc:IsSynchroSummonable(nil,mg) then op=0
	   else op=1
	   end
	   if op==0 then
		  Duel.SynchroSummon(tp,tc,nil,mg)
	   else
		  Duel.XyzSummon(tp,tc,mg,2,2)
	   end
	end
	Duel.ShuffleHand(tp)
end
function c10113076.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToExtraAsCost,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToExtraAsCost,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c10113076.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c10113076.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
