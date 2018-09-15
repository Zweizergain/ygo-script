--吸血鬼创世主·改
function c98711010.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,98711010)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c98711010.spcon)
	e2:SetOperation(c98711010.spop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98711010,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c98711010.cost)
	e3:SetTarget(c98711010.target)
	e3:SetOperation(c98711010.operation)
	c:RegisterEffect(e3)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98711010,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c98711010.rettg)
	e2:SetOperation(c98711010.retop)
	c:RegisterEffect(e2)
end
function c98711010.gfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x8e) and c:IsAbleToRemoveAsCost()
end
function c98711010.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98711010.gfilter,tp,LOCATION_HAND,0,2,e:GetHandler())
end
function c98711010.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98711010.gfilter,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c98711010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000) 
end
function c98711010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()>2 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98711010.tgfilter(c,ty)
	return c:IsType(ty) and c:IsAbleToGrave()
end
function c98711010.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(1-tp,c98711009.tgfilter,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c98711009.tgfilter,tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g3=Duel.SelectMatchingCard(1-tp,c98711009.tgfilter,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g4=Duel.SelectMatchingCard(tp,c98711009.tgfilter,tp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g5=Duel.SelectMatchingCard(1-tp,c98711009.tgfilter,1-tp,LOCATION_DECK,0,1,1,nil,TYPE_TRAP)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g6=Duel.SelectMatchingCard(tp,c98711009.tgfilter,tp,LOCATION_DECK,0,1,1,nil,TYPE_TRAP)
	g1:Merge(g3)
	g1:Merge(g5)
	if g1:GetCount()~=3 then
		local cg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.ConfirmCards(tp,cg)
		Duel.ShuffleDeck(1-tp)
	end
	g2:Merge(g4)
	g2:Merge(g6)
	if g2:GetCount()~=3 then
		local cg=Duel.GetFieldGroup(1-tp,0,LOCATION_DECK)
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleDeck(tp)
	end
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(-2)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c98711010.filter(c)
	return c:IsSetCard(0x8e) and c:IsAbleToDeck()
end
function c98711010.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c98711010.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98711010.filter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98711010.filter,tp,LOCATION_REMOVED,0,1,99,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*500)
end
function c98711010.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if ct>0 then
		Duel.Recover(tp,ct*500,REASON_EFFECT)
	end
end
