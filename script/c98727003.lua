--雾动机龙·蛇颈龙
function c98727003.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c98727003.negcon)
	e2:SetOperation(c98727003.negop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetCondition(c98727003.spcon)
	e3:SetTarget(c98727003.sptg)
	e3:SetOperation(c98727003.spop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98727003,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCondition(c98727003.condition)
	e4:SetTarget(c98727003.target)
	e4:SetOperation(c98727003.operation)
	c:RegisterEffect(e4)
	--decrease atk/def
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98727003,2))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_RELEASE)
	e5:SetCountLimit(1,98727003)
	e5:SetTarget(c98727003.adtg)
	e5:SetOperation(c98727003.adop)
	c:RegisterEffect(e5)
end
function c98727003.tfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xd8) and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end
function c98727003.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)	
	return e:GetHandler():GetFlagEffect(98727003)==0 and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) 
		and g and g:IsExists(c98727003.tfilter,1,e:GetHandler(),tp) and Duel.IsChainDisablable(ev)
end
function c98727003.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(98727003,0)) then
		e:GetHandler():RegisterFlagEffect(98727003,RESET_EVENT+0x1fe0000,0,1)
		if Duel.NegateEffect(ev) then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function c98727003.rfilter(c,tp)
	return c:IsPreviousSetCard(0xd8) and c:IsReason(REASON_RELEASE) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetPreviousControler()==tp
end
function c98727003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98727003.rfilter,1,nil,tp)
end
function c98727003.spfilter(c,e,tp)
	return c:IsSetCard(0xd8) and ((c:IsType(TYPE_PENDULUM) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98727003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98727003.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp) end
end
function c98727003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98727003.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98727003.filter(c,tp)
	return c:IsSetCard(0xd8) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c98727003.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98727003.filter,1,nil,tp)
end
function c98727003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98727003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c98727003.adfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c98727003.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98727003.adfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c98727003.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd8)
end
function c98727003.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c98727003.adfilter,tp,0,LOCATION_MZONE,nil)
	local val=Duel.GetMatchingGroupCount(c98727003.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*-100
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
