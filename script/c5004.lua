--娘化 坂田銀時
function c5004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c5004.spcon)
	c:RegisterEffect(e1)
	--tohand
	--local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_TOHAND)
	--e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e2:SetCode(EVENT_TO_GRAVE)
	--e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	--e2:SetCountLimit(1,5004)
	--e2:SetTarget(c5004.thtg)
	--e2:SetOperation(c5004.thop)
	--c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5004,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c5004.drcon)
	e3:SetTarget(c5004.drtg)
	e3:SetOperation(c5004.drop)
	c:RegisterEffect(e3) 
	--tuner
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c5004.tg)
	e4:SetOperation(c5004.op)
	c:RegisterEffect(e4)
end
function c5004.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x900)
end
function c5004.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c5004.spfilter,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function c5004.filter(c)
	return c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetCode()~=5004 
end
function c5004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5004.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c5004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5004.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e:GetHandler():IsLocation(LOCATION_GRAVE)
function c5004.drcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c5004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c5004.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
		--Duel.Draw(tp,1,REASON_EFFECT)
end
function c5004.filterr(c)
	return c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER)
end
function c5004.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x900) and not c:IsType(TYPE_TUNER)
end
function c5004.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c5004.filterr(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c5004.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c5004.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c5004.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end