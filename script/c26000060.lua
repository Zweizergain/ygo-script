--脉冲高达 紧急拆合
function c26000060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26000060,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26000060+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c26000060.target)
	e1:SetOperation(c26000060.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26000060,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,26000060+EFFECT_COUNT_CODE_OATH)
	e2:SetHintTiming(0,0x1e0)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c26000060.spcost)
	e2:SetTarget(c26000060.target2)
	e2:SetOperation(c26000060.activate2)
	c:RegisterEffect(e2)
end
function c26000060.ffilter0(c)
	return c:IsFusionCode(26000010,26000020,26000030) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c26000060.ffilter(c,e)
	return c:IsFusionCode(26000010,26000020,26000030) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
		and not c:IsImmuneToEffect(e)
end
function c26000060.spfilter(c,e,tp)
	return c:IsCode(26000040) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c26000060.fcheck(c,sg,g,code,...)
	if not c:IsFusionCode(code) then return false end
	if ... then
		g:AddCard(c)
		local res=sg:IsExists(c26000060.fcheck,1,g,sg,g,...)
		g:RemoveCard(c)
		return res
	else return true end
end
function c26000060.fselect(c,tp,mg,sg,...)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(c26000060.fselect,1,sg,tp,mg,sg,...)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		local g=Group.CreateGroup()
		res=sg:IsExists(c26000060.fcheck,1,nil,sg,g,...)
	end
	sg:RemoveCard(c)
	return res
end
function c26000060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsExistingMatchingCard(c26000060.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return false end
		local mg=Duel.GetMatchingGroup(c26000060.ffilter0,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
		local sg=Group.CreateGroup()
		return mg:IsExists(c26000060.fselect,1,nil,tp,mg,sg,26000010,26000020,26000030)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26000060.cfilter(c)
	return c:IsLocation(LOCATION_HAND) or (c:IsOnField() and c:IsFacedown())
end
function c26000060.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26000060.ffilter),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e)
	local sg=Group.CreateGroup()
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,c26000060.fselect,1,1,sg,tp,mg,sg,26000010,26000020,26000030)
		sg:Merge(g)
	end
	local cg=sg:Filter(c26000060.cfilter,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleHand(tp)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26000060.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	g:GetFirst():CompleteProcedure()
end
function c26000060.spcfilter2(c)
	return c:IsFaceup() and c:IsCode(26000040) and c:IsAbleToRemoveAsCost()
end
function c26000060.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26000060.spcfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c26000060.spcfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c26000060.spfilter2(c,e,tp)
	return c:GetLevel()==4 and c:IsSetCard(0xff8) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26000060.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c26000060.spfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if e:GetHandler():GetSequence()<5 then ft=ft+1 end
		return ft>2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and g:GetClassCount(Card.GetCode)>2
	end
	local sg=Group.CreateGroup()
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
		sg:Merge(g1)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,3,0,0)
end
function c26000060.activate2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if g:GetCount()<=ft then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_RULE)
	end
end
