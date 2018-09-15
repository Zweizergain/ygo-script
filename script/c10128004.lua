--奇妙物语 黏黏糖虫
function c10128004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,10128004)
	e1:SetTarget(c10128004.target)
	e1:SetOperation(c10128004.activate)
	c:RegisterEffect(e1)  
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c10128004.efcon)
	e2:SetOperation(c10128004.efop)
	c:RegisterEffect(e2)	
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(10128004,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(aux.exccon)
	e3:SetCountLimit(1,10128104)
	e3:SetCost(c10128004.thcost)
	e3:SetTarget(c10128004.thtg)
	e3:SetOperation(c10128004.thop)
	c:RegisterEffect(e3)  
end
function c10128004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10128004.thfilter(c,e,rc)
	return bit.band(c:GetType(),0x10002)==0x10002 and c:IsAbleToHand() and c~=rc and c:IsCanBeEffectTarget(e)
end
function c10128004.filter1(c,e,tp,rc)
	return bit.band(c:GetType(),0x10002)==0x10002 and c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c10128004.thfilter,tp,LOCATION_GRAVE,0,1,c,e,rc)
end
function c10128004.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c10128003.thfilter(chkc,e,c) end 
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10128004.filter1,tp,LOCATION_GRAVE,0,1,c,e,tp,c) and bit.band(c:GetType(),0x10002)==0x10002 and c:IsAbleToDeckAsCost()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,c10128004.filter1,tp,LOCATION_GRAVE,0,1,1,c,e,tp,c)
	local tc=tg:GetFirst()
	tg:AddCard(c)
	Duel.SendtoDeck(tg,nil,2,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectTarget(tp,c10128004.thfilter,tp,LOCATION_GRAVE,0,1,1,tc,e,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,hg,1,0,0)
end
function c10128004.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c10128004.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c10128004.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--act limit
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c10128004.aclimit)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c10128004.aclimit(e,re,tp)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end
function c10128004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10128004,0x6336,0x21,1500,1500,4,RACE_INSECT,ATTRIBUTE_LIGHT) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10128004.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,10128004,0x6336,0x21,1500,1500,4,RACE_INSECT,ATTRIBUTE_LIGHT) 
	then return end
		--c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		--c:RegisterEffect(e1,true)
		--Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	c:AddMonsterAttribute(TYPE_EFFECT)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	c:AddMonsterAttributeComplete()
	Duel.SpecialSummonComplete()
end