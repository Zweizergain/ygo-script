--植占师的原典
function c16001007.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,1)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c16001007.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c16001007.defval)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16001007,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c16001007.mttg)
	e3:SetOperation(c16001007.mtop)
	c:RegisterEffect(e3)
	--card mimic(1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16001007,1))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,16001007)
	e4:SetCondition(c16001007.mimiccon1)
	e4:SetTarget(c16001007.mimictarget1)
	e4:SetOperation(c16001007.mimicactivate1)
	c:RegisterEffect(e4)
	--card mimic(3)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(16001007,2))
	e5:SetCategory(EFFECT_TYPE_SINGLE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,16001007)
	e5:SetCondition(c16001007.mimiccon3)
	e5:SetTarget(c16001007.mimictarget3)
	e5:SetOperation(c16001007.mimicoperation3)
	c:RegisterEffect(e5)
	--card mimic(5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(16001007,3))
	e6:SetCategory(EFFECT_TYPE_SINGLE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCode(EEVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c16001007.mimiccon5)
	e6:SetTarget(c16001007.mimictarget5)
	e6:SetOperation(c16001007.mimicoperation5)
	c:RegisterEffect(e6)
	--card mimic(7)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(16001007,4))
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCode(EEVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c16001007.mimiccon7)
	e7:SetTarget(c16001007.mimictarget7)
	e7:SetOperation(c16001007.mimicoperation7)
	c:RegisterEffect(e7)
end
function c16001007.atkfilter(c)
	return c:IsSetCard(0x101) and c:GetAttack()>=0
end
function c16001007.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c16001007.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c16001007.deffilter(c)
	return c:IsSetCard(0x101) and c:GetDefense()>=0
end
function c16001007.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c16001007.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c16001007.mtfilter(c)
	return c:IsSetCard(0x101)
end
function c16001007.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16001007.mtfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c16001007.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c16001007.mtfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c16001007.mimiccon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,16000001)
end
function c16001007.ovlayfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x101)
end
function c16001007.mimictarget1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c16001007.ovlayfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16001007.ovlayfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c16001007.ovlayfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c16001007.mimicactivate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
		if g:GetCount()>=1 then
			local og=g:Select(tp,1,1,nil)
			Duel.Overlay(tc,og)
		end
	end
end
function c16001007.mimiccon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,16000003)
end
function c16001007.mfilter3(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c16001007.mimictarget3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetMatchingGroupCount(c16001007.mfilter3,tp,LOCATION_GRAVE,0,nil)*300
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c16001007.mimicoperation3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetMatchingGroupCount(c16001007.mfilter3,tp,LOCATION_GRAVE,0,nil)*300
	Duel.Damage(p,dam,REASON_EFFECT)
end
function c16001007.mimiccon5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,16000005)
end
function c16001007.mfilter5(c,e,tp)
	return c:IsSetCard(0x101) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16001007.mimictarget5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16001007.mfilter5,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c16001007.mimicoperation5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16001007.mfilter5,tp,LOCATION_HAND,0,1,2,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c16001007.mimiccon7(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,16000007)
end
function c16001007.mfilter7(c)
	return c:IsLevelBelow(4) and c:IsAbleToGrave()
end
function c16001007.mimictarget7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16001007.mfilter7,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c16001007.mimicoperation7(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16001007.mfilter7,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
