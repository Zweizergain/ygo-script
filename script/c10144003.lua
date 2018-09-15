--夺宝奇兵·露露耶
function c10144003.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c10144003.indcon)
	e1:SetValue(1)
	--c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--c:RegisterEffect(e2) 
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c10144003.desreptg)
	e3:SetOperation(c10144003.desrepop)
	c:RegisterEffect(e3) 
	--deckdest
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10144003,0))
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,10144003)
	e4:SetTarget(c10144003.detg)
	e4:SetOperation(c10144003.deop)
	c:RegisterEffect(e4) 
end

function c10144003.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsFaceup() and c:IsSetCard(0x3333)
end

function c10144003.detg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c10144003.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10144003.filter,tp,LOCATION_REMOVED,0,2,nil) and Duel.IsPlayerCanDiscardDeck(1-tp,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10144003.filter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,2)
end

function c10144003.deop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:FilterCount(Card.IsRelateToEffect,nil,e)>0 and Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)~=0 then  
	   Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
	end
end

function c10144003.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10144002.indfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end

function c10144003.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6333) and c:GetSequence()<5
end

function c10144003.repfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3333) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end

function c10144003.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c10144003.repfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(10144003,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c10144003.repfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c)
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		return true
	else return false end
end
function c10144003.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end