--糖果派 姆姆酥
function c10108005.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),1)
	c:EnableReviveLimit()
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c10108005.efftg)
	e1:SetCode(10108005)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10108005,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(c10108005.tdtg)
	e2:SetOperation(c10108005.tdop)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetCondition(c10108005.recon)
	e3:SetValue(LOCATION_DECK)
	c:RegisterEffect(e3)
	c10108005[c]=e2
end
function c10108005.recon(e)
	return e:GetHandler():IsFaceup()
end
function c10108005.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10108005.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c10108005.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10108005.tdfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10108005.sumfilter(c)
	return c:IsSetCard(0x9338) and c:IsSummonable(true,nil)
end
function c10108005.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	if Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)~=0 then
	   local g=Duel.GetOperatedGroup()
	   if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	   if g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)~=0 and Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		  local sg=Duel.GetMatchingGroup(c10108005.sumfilter,tp,LOCATION_HAND,0,nil)
		  if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10108005,1)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			 local sg2=sg:Select(tp,1,1,nil)
			 Duel.Summon(tp,sg2:GetFirst(),true,nil)
		  end
	   end
	end
end
function c10108005.tdfilter(c)
	return c:IsSetCard(0x9338) and c:IsFaceup() and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c10108005.efftg(e,c)
	return c:IsSetCard(0x9338)
end