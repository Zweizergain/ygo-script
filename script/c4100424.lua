--铠装的连契
function c4100424.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c4100424.target)
	e1:SetOperation(c4100424.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCountLimit(1)
	e2:SetTarget(c4100424.eftg)
	e2:SetOperation(c4100424.efop)
	c:RegisterEffect(e2)
end
function c4100424.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and c:IsSetCard(0xee0)
end
function c4100424.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c4100424.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c4100424.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c4100424.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c4100424.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end


function c4100424.filter1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_UNION)
		and Duel.IsExistingTarget(c4100424.filter2,tp,LOCATION_MZONE,0,1,c,c)
end
function c4100424.filter2(c,ec)
	return c:IsFaceup() and ec:CheckEquipTarget(c) and aux.CheckUnionEquip(ec,c)
end
function c4100424.filter3(c,e,tp)
	return c:IsFaceup() and c:IsHasEffect(EFFECT_UNION_STATUS) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4100424.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local b1=Duel.IsExistingMatchingCard(c4100424.filter1,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=Duel.IsExistingMatchingCard(c4100424.filter3,tp,LOCATION_SZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(4100424,0),aux.Stringid(4100424,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(4100424,0))
	else op=Duel.SelectOption(tp,aux.Stringid(4100424,1))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_EQUIP)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(4100424,2))
		local g1=Duel.SelectTarget(tp,c4100424.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g2=Duel.SelectTarget(tp,c4100424.filter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),g1:GetFirst())
		e:SetLabelObject(g1:GetFirst())
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c4100424.filter3,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c4100424.efop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc1=e:GetLabelObject()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tc2=g:GetFirst()
		if tc1==tc2 then tc2=g:GetNext() end
		if tc1:IsFaceup() and tc2:IsFaceup() and tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e)
			and aux.CheckUnionEquip(tc1,tc2) and Duel.Equip(tp,tc1,tc2,false) then
			aux.SetUnionState(tc1)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		end
	end
end
