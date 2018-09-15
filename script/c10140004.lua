--原力的宝物
function c10140004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c10140004.target2)
	c:RegisterEffect(e1)	
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10140004,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,10140004)
	e2:SetCost(c10140004.cost)
	e2:SetTarget(c10140004.target)
	e2:SetOperation(c10140004.operation)
	c:RegisterEffect(e2)
	--re set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10140004,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCost(c10140004.rscost)
	e3:SetTarget(c10140004.rstg)
	e3:SetOperation(c10140004.rsop)
	c:RegisterEffect(e3)
end

function c10140004.rfilter(c)
	return c:IsSetCard(0x3333) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end

function c10140004.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10140004.rfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10140004.rfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c10140004.rstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsSSetable() end
end

function c10140004.rsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	  Duel.SSet(tp,c)
	  Duel.ConfirmCards(1-tp,c)
end

function c10140004.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c10140004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	if c10140004.cost(e,tp,eg,ep,ev,re,r,rp,0) and c10140004.target(e,tp,eg,ep,ev,re,r,rp,0,chkc)
		and Duel.SelectYesNo(tp,aux.Stringid(10140004,1)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c10140004.operation)
		c10140004.cost(e,tp,eg,ep,ev,re,r,rp,1)
		c10140004.target(e,tp,eg,ep,ev,re,r,rp,1,chkc)
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end

function c10140004.cfilter(c)
	return c:IsSetCard(0x6333) and c:IsDiscardable()
end

function c10140004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10140004.cfilter,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():GetFlagEffect(10140004)==0 end
	Duel.DiscardHand(tp,c10140004.cfilter,1,1,REASON_COST+REASON_DISCARD)
	e:GetHandler():RegisterFlagEffect(10140004,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end

function c10140004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,LOCATION_ONFIELD)
end

function c10140004.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end

