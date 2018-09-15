--星际仙踪纷争
function c98799004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98799004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98799004+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98799004.target)
	e1:SetOperation(c98799004.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98799004,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c98799004.descon)
	e2:SetTarget(c98799004.destg)
	e2:SetOperation(c98799004.desop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98799004,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCondition(c98799004.thcon)
	e3:SetTarget(c98799004.thtg)
	e3:SetOperation(c98799004.thop)
	c:RegisterEffect(e3)
end
function c98799004.desfilter(c)
	return c:IsSetCard(0xd2)
end
function c98799004.spfilter(c,e,tp)
	return c:IsSetCard(0xd2) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98799004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98799004.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,e:GetHandler())
		and Duel.IsExistingMatchingCard(c98799004.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c98799004.tgfilter(c)
	return c:IsSetCard(0xd2) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c98799004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c98799004.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	if g:GetCount()<2 then return end
	local g1=nil local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if ft<1 then
		g1=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
	else
		g1=g:Select(tp,1,1,nil)
	end
	g:RemoveCard(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	g2=g:Select(tp,1,1,nil)
	g1:Merge(g2)
	if Duel.Destroy(g1,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c98799004.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local sg1=sg:GetFirst()
		if sg:GetCount()>0 and Duel.SpecialSummonStep(sg1,0,tp,tp,false,false,POS_FACEUP) then
			Duel.Equip(tp,c,sg1)
			--Add Equip limit
			local e1=Effect.CreateEffect(sg1)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c98799004.eqlimit)
			c:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
			local tg=Duel.GetMatchingGroup(c98799004.tgfilter,tp,LOCATION_DECK,0,nil)
			if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98799004,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
				local stg=tg:Select(tp,1,1,nil)
				Duel.SendtoGrave(stg,REASON_EFFECT)
			end
		end
	end
end
function c98799004.eqlimit(e,c)
	return e:GetOwner()==c
end
function c98799004.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if ec~=Duel.GetAttacker() and ec~=Duel.GetAttackTarget() then return false end
	local tc=ec:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup() and bit.band(tc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c98799004.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c98799004.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c98799004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c98799004.thfilter(c)
	return c:IsSetCard(0xd2) and not c:IsCode(98799004) and c:IsAbleToHand()
end
function c98799004.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98799004.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98799004.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c98799004.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98799004.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
