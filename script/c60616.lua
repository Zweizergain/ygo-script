--「Scarlet Shinsou（绯色神枪）」
function c60616.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetCondition(c60616.handcon)
	e1:SetTarget(c60616.target)
	e1:SetOperation(c60616.activate)
	c:RegisterEffect(e1)		
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetDescription(aux.Stringid(60616,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c60616.thcon)
	e2:SetTarget(c60616.stg)
	e2:SetOperation(c60616.sop)
	c:RegisterEffect(e2)
end
function c60616.handcon(e,tp,eg,ep,ev,re,r,rp)

	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>0 and g:FilterCount(Card.IsSetCard,nil,0x813)==g:GetCount()
end
function c60616.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)

end
function c60616.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if g and g:GetCount()>0 then 
		local rc=g:GetFirst()
		if Duel.Destroy(rc,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_GRAVE)
			and not rc:IsHasEffect(EFFECT_NECRO_VALLEY) then
			if rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and (not rc:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp)>0)
				and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
				and Duel.SelectYesNo(tp,aux.Stringid(1231300,3)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,rc)
			elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
				and rc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(1231300,3)) then
				Duel.BreakEffect()
				Duel.SSet(tp,rc)
				Duel.ConfirmCards(1-tp,rc)
			end
		end 
	end 
end
function c60616.sumfilter(c)
	return c:IsCode(1231300) and c:IsFaceup()
end
function c60616.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60616.sumfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c60616.cfilter(c,tp)
	return c:IsControler(tp) and not c:IsReason(REASON_DRAW)
end
function c60616.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c60616.cfilter,1,nil,tp) and e:GetHandler():IsAbleToHand() end
	local pg=eg:Filter(c60616.cfilter,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,pg,pg:GetCount(),tp,LOCATION_HAND)
end
function c60616.cfilter2(c,tp)
	return c:GetControler()==tp and not c:IsLocation(LOCATION_HAND)
end
function c60616.sop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetHandler():IsAbleToHand() then
		if not eg:IsExists(c60616.cfilter2,1,nil,tp) and Duel.SendtoGrave(eg,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,e:GetHandler())
		end
	end
end