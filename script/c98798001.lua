--仪式
function c98798001.initial_effect(c)
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c98798001.target)
	e1:SetOperation(c98798001.operation)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(98798001,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(98798001)
	e2:SetTarget(c98798001.thtg1)
	e2:SetOperation(c98798001.thop1)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98798001,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c98798001.thtg2)
	e2:SetOperation(c98798001.thop2)
	c:RegisterEffect(e2)
end
function c98798001.ritfilter0(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c98798001.ritfilter1(c,lv,mg)
	lv=lv-c:GetLevel()
	if lv<2 then return false end
	local mg2=mg:Clone()
	mg2:Remove(Card.IsRace,nil,c:GetRace())
	return mg2:IsExists(c98798001.ritfilter2,1,nil,lv,mg2)
end
function c98798001.ritfilter2(c,lv,mg)
	local clv=c:GetLevel()
	lv=lv-clv
	if lv<1 then return false end
	local mg2=mg:Clone()
	mg2:Remove(Card.IsRace,nil,c:GetRace())
	return mg2:IsExists(c98798001.ritfilter3,1,nil,lv)
end
function c98798001.ritfilter3(c,lv)
	return c:GetLevel()>=lv
end
function c98798001.filter(c,e,tp,m,ft)
	if bit.band(c:GetType(),0x81)~=0x81 
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c:IsCode(21105106) then
		local g=mg:Filter(c98798001.ritfilter0,c,tp)
		return ft>-3 and g:IsExists(c98798001.ritfilter1,1,nil,c:GetLevel(),g)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	else
		return mg:IsExists(c98798001.filterF,1,nil,tp,mg,c)
	end
end
function c98798001.filterF(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else return false end
end
function c98798001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>-1 and Duel.IsExistingMatchingCard(c98798001.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c98798001.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c98798001.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc:GetCode()~=21105106 and tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		local mat=Group.CreateGroup()
		if tc:IsCode(21105106) then
			local lv=tc:GetLevel()
			local g=mg:Filter(c98798001.ritfilter0,nil,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=g:FilterSelect(tp,c98798001.ritfilter1,1,1,nil,lv,g)
			local tc1=mat:GetFirst()
			lv=lv-tc1:GetLevel()
			g:Remove(Card.IsRace,nil,tc1:GetRace())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=g:FilterSelect(tp,c98798001.ritfilter2,1,1,nil,lv,g)
			local tc2=mat2:GetFirst()
			lv=lv-tc2:GetLevel()
			g:Remove(Card.IsRace,nil,tc2:GetRace())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat3=g:FilterSelect(tp,c98798001.ritfilter3,1,1,nil,lv)
			mat:Merge(mat2)
			mat:Merge(mat3)
		elseif ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c98798001.filterF,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		e:SetLabelObject(tc)
		Duel.RaiseSingleEvent(e:GetHandler(),98798001,e,0,tp,tp,0)
	end
end
function c98798001.thfilter1(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c98798001.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=e:GetLabelObject():GetLabelObject()
	local mat=tc:GetMaterial()
	if chkc then return mat:IsContains(chkc) and c98798001.thfilter1(chkc,e,tp) end
	if chk==0 then return mat:IsExists(c98798001.thfilter1,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=mat:FilterSelect(tp,c98798001.thfilter1,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c98798001.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c98798001.thfilter2(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function c98798001.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98798001.thfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98798001.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98798001.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c98798001.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
