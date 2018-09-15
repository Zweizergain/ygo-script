--灵噬总管 泷
function c79131330.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x1201),2)
	c:EnableReviveLimit()
	 --cannot destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c79131330.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79131330,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,79131330)
	e4:SetCost(c79131330.spcost1)
	e4:SetTarget(c79131330.sptg1)
	e4:SetOperation(c79131330.spop1)
	c:RegisterEffect(e4)
end
function c79131330.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1206)*-100
end
function c79131330.cfilter(c,g,tp,zone)
	return c:IsSetCard(0x1201) and g:IsContains(c)
		and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c79131330.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c79131330.cfilter,1,nil,lg,tp,zone) end
	local g=Duel.SelectReleaseGroup(tp,c79131330.cfilter,1,1,nil,lg,tp,zone)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c79131330.spfilter1(c,e,tp)
	return c:IsSetCard(0x1201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79131330.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cc=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and chkc~=cc and c79131330.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c79131330.spfilter1,tp,LOCATION_GRAVE,0,1,cc,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c79131330.spfilter1,tp,LOCATION_GRAVE,0,1,1,cc,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c79131330.spop1(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
