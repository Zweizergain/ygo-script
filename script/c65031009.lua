--幻彩的惊奇律歌
function c65031009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,65031009)
	e1:SetCondition(c65031009.condition)
	e1:SetTarget(c65031009.target)
	e1:SetOperation(c65031009.activate)
	c:RegisterEffect(e1)
end
function c65031009.cfilter(c)
	return not c:IsCode(65031002) 
end
function c65031009.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_NEGATE+CATEGORY_DISABLE) and Duel.IsChainNegatable(ev) and ep~=tp and Duel.GetMatchingGroupCount(c65031009.cfilter,tp,LOCATION_MZONE,0,nil)==0 
end
function c65031009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,65031002,0,0x4011,1500,1500,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP,tp) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c65031009.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		if Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)~=0 and ec:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,65031002,0,0x4011,1500,1500,6,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP,tp) then
			local token=Duel.CreateToken(tp,65031010)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			--cannot summon
			local e1=Effect.CreateEffect(token)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c65031009.splimit)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SUMMON)
			token:RegisterEffect(e2,true)
			--effect type
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_TYPE)
			e4:SetValue(TYPE_EFFECT)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e4,true)
			--negate
			local e5=Effect.CreateEffect(token)
			e5:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
			e5:SetType(EFFECT_TYPE_QUICK_O)
			e5:SetRange(LOCATION_MZONE)
			e5:SetCode(EVENT_CHAINING)
			e5:SetHintTiming(0x3c0)
			e5:SetCondition(c65031009.cpcon)
			e5:SetCountLimit(1)
			e5:SetCost(c65031009.cpcost)
			e5:SetTarget(c65031009.cptg)
			e5:SetOperation(c65031009.cpop)
			token:RegisterEffect(e5,true)
			token:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65031009,0))
			Duel.SpecialSummonComplete()
		end
	end
end
function c65031009.splimit(e,c)
	return not c:IsCode(65031002)
end

function c65031009.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp 
end

function c65031009.costfil(c)
	return c:IsSetCard(0xada1) and (c:IsFacedown() or c:IsLocation(LOCATION_HAND))  and c:IsAbleToRemoveAsCost()
end
function c65031009.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65031009.costfil,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65031009.costfil,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65031009.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
	end
end
function c65031009.cpop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoHand(ec,nil,REASON_EFFECT)
	end
end