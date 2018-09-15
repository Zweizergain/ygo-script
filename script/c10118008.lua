--季雨 孤单黑蓝
function c10118008.initial_effect(c)
	c:EnableReviveLimit() 
	--spsummon
	aux.AddXyzProcedure(c,nil,4,2)  
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10118008,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c10118008.mtcon)
	e1:SetTarget(c10118008.mttg)
	e1:SetOperation(c10118008.mtop)
	c:RegisterEffect(e1) 
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10118008,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10118008.accost)
	e2:SetTarget(c10118008.actg)
	e2:SetOperation(c10118008.acop)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10118008,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10118008)
	e3:SetCost(c10118008.tdcost)
	e3:SetTarget(c10118008.tdtg)
	e3:SetOperation(c10118008.tdop)
	c:RegisterEffect(e3)
end
function c10118008.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c10118008.tdfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c10118008.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10118008.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c10118008.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10118008.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c10118008.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10118008.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c10118008.acop(e,tp,eg,ep,ev,re,r,rp)
	local ac,c=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM),e:GetHandler()
	e:SetLabel(ac)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,ac))
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.AdjustInstantly(c)
end
function c10118008.mtcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c10118008.mtfilter(c,e)
	return c:IsSetCard(0x5331) and not c:IsImmuneToEffect(e)
end
function c10118008.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10118008.mtfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e) end
end
function c10118008.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c10118008.mtfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e)
	if g:GetCount()>0 then
	   Duel.Overlay(c,g)
	end
end
