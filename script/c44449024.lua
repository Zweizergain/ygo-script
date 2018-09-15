--百夜·未闻之花
function c44449024.initial_effect(c)
    c:SetUniqueOnField(1,0,44449024)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x644))
	e2:SetValue(c44449024.val)
	c:RegisterEffect(e2)
	--activate in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x644))
	c:RegisterEffect(e3)
	--change pose
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCountLimit(1)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_GRAVE+LOCATION_ONFIELD)
	e11:SetCost(aux.bfgcost)
	e11:SetTarget(c44449024.target)
	e11:SetOperation(c44449024.operation)
	c:RegisterEffect(e11)
end
function c44449024.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and not c:IsCode(44449024)
	and not (c:IsLocation(LOCATION_SZONE) and c:GetSequence()>=6 and c:GetSequence()<=7)
end
function c44449024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_ONFIELD and c44449024.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c44449024.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(44449024,2))
	local g=Duel.SelectTarget(tp,c44449024.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function c44449024.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_ONFIELD) then
			Duel.ChangePosition(tc,POS_FACEDOWN)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tc:GetControler(),0) 
			if tc and tc:IsCode(200103) then tc:RegisterFlagEffect(200103,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) end

	end
end
function c44449024.afilter(c)
	return c:IsSetCard(0x644) and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_QUICKPLAY))
end
function c44449024.atkfilter(c)
	return c:IsSetCard(0x644) and c:IsType(TYPE_MONSTER) 
end
function c44449024.val(e,c)
	return Duel.GetMatchingGroupCount(c44449024.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*200
end

