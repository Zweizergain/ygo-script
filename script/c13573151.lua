local m=13573151
local tg={13573101,13573123}
local cm=_G["c"..m]
cm.name="幸福的宝藏?"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--To Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--Effect Add
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(cm.effcon)
	e3:SetOperation(cm.effop)
	c:RegisterEffect(e3)
end
cm.card_code_list={tg[1]}
--To Deck
function cm.filter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and aux.IsCodeListed(c,tg[1]) and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and cm.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not e:GetHandler():IsRelateToEffect(e) or not g or g:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	local sg=Duel.GetOperatedGroup()
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	if sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)==3 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--Effect Add
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then return end
	Duel.RegisterFlagEffect(tp,m,0,0,0)
	--Append Effect
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetDescription(aux.Stringid(m,2))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTarget(cm.atktg)
	e0:SetValue(300)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.eftg)
	e1:SetLabelObject(e0)
	Duel.RegisterEffect(e1,tp)
end
function cm.eftg(e,c)
	return c:IsFaceup() and c:IsCode(tg[2])
end
--Append Effect
function cm.atktg(e,c)
	return c:IsFaceup() and c:IsLinkState()
end