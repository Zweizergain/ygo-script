--百夜·雫之零
function c44446009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,44446009)
	e1:SetTarget(c44446009.target)
	e1:SetOperation(c44446009.activate)
	c:RegisterEffect(e1)
	--return
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_TOHAND)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCountLimit(1,44446019)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_GRAVE)
	e11:SetCost(aux.bfgcost)
	e11:SetTarget(c44446009.tg1)
	e11:SetOperation(c44446009.activate1)
	c:RegisterEffect(e11)
end
c44446009.fit_monster={44447009}
function c44446009.filter(c,e,tp,m,ft)
	if not c:IsSetCard(0x644) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c:IsCode(44447000) then return c:ritual_custom_condition(mg,ft) end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return ft>-1 and mg:IsExists(c44446009.mfilterf,1,nil,tp,mg,c)
	end
end
function c44446009.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end
function c44446009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c44446009.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c44446009.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c44446009.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg,ft)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc:IsCode(44447000) then
			tc:ritual_custom_operation(mg)
			local mat=tc:GetMaterial()
			Duel.ReleaseRitualMaterial(mat)
		else
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,nil)
			end
			local mat=nil
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:FilterSelect(tp,c44446009.mfilterf,1,1,nil,tp,mg,tc)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(mat2)
			end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		local g=Duel.GetOperatedGroup()
		if g:FilterCount(c44446009.sfilter,nil)>0 
	    and Duel.IsExistingMatchingCard(c44446009.efilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(44446009,1)) then
			local g=Duel.SelectMatchingCard(tp,c44446009.efilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
			   Duel.SendtoHand(g,nil,REASON_EFFECT)
		       Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c44446009.sfilter(c,e,tp)
	return c:IsCode(44447009) and c:IsType(TYPE_MONSTER)
end
function c44446009.efilter(c,e,tp)
	return c:IsAbleToHand()
end
--return
function c44446009.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c44446009.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end