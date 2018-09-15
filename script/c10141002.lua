--夺宝奇兵·海格尔
function c10141002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10141002)
	e1:SetCondition(c10141002.spcon)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10141002,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetTarget(c10141002.destg)
	e2:SetOperation(c10141002.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)  
	c:RegisterEffect(e3)	
end

function c10141002.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsDestructable() and chkc:IsSetCard(0x6333) and chkc:GetSequence()<6 end
	if chk==0 then return Duel.IsExistingMatchingCard(c10141002.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10141002.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,LOCATION_SZONE)
end

function c10141002.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c10141002.thfilter,tp,LOCATION_DECK,0,1,nil,code) then
	  Duel.BreakEffect()
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	  local tg=Duel.SelectMatchingCard(tp,c10141002.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
	   if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	   end
	end
end

function c10141002.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end

function c10141002.desfilter(c,tp)
	return ((c:IsFaceup() and c:IsControler(1-tp)) or c:IsControler(tp)) and c:IsSetCard(0x6333) and c:GetSequence()<5 and Duel.IsExistingMatchingCard(c10141002.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end

function c10141002.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6333) and c:GetSequence()<5
end

function c10141002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10141002.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
