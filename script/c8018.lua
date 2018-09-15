--孢子花开
function c8018.initial_effect(c)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c8018.handcon)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8018+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c8018.target)
	e1:SetOperation(c8018.operation)
	c:RegisterEffect(e1)
	--grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c8018.target1)
	e3:SetOperation(c8018.activate)
	c:RegisterEffect(e3)
end
function c8018.handfilter(c)
	return c:IsType(TYPE_TRAP)
end
function c8018.handcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_GRAVE,0)
	return not g:IsExists(c8018.handfilter,1,nil)
end
function c8018.filter(c,tp)
	return c:IsSetCard(0x901) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c8018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c8018.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c8018.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c8018.setfilter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsSSetable(true) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsSetCard(0x901) and not c:IsCode(8018)
end
function c8018.operation(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c8018.setfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		g:GetFirst():RegisterEffect(e1)
end
function c8018.tfilter(c)
	return c:IsType(TYPE_TRAP) and not c:IsCode(8018)
end
function c8018.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c8018.tfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(8018,0))
	local g=Duel.SelectTarget(tp,c8018.tfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c8018.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),nil,2,POS_FACEUP,REASON_COST)
	end
end