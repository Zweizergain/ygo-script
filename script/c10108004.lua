--糖果派 果果冻
function c10108004.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10108004,1))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCost(c10108004.tgcost)
	e1:SetTarget(c10108004.tgtg)
	e1:SetOperation(c10108004.tgop)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10108004,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c10108004.eftg)
	e2:SetOperation(c10108004.efop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c10108004[c]=e2  
end
function c10108004.effilter(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c[c]
	if not te or not c:IsSetCard(0x9338) or c:IsCode(10108004) then return false end
	local tg=te:GetTarget()
	if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0,nil,c) then return false end
	return true
end
function c10108004.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c10108004.effilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(c10108004.effilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c10108004.effilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te=tc[tc]
	Duel.ClearTargetCard()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
	   tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function c10108004.efop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c10108004.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10108004.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9338) and not c:IsCode(10108004) and c:IsAbleToGrave()
end
function c10108004.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10108004.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10108004.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c10108004.sumfilter(c,code)
	return c:IsCode(code) and c:IsSummonable(true,nil)
end
function c10108004.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c10108004.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
	   local g1=Duel.GetMatchingGroup(c10108004.thfilter,tp,LOCATION_DECK,0,nil,tc:GetCode())
	   local g2=Duel.GetMatchingGroup(c10108004.sumfilter,tp,LOCATION_HAND,0,nil,tc:GetCode())
	   if (g1:GetCount()<=0 and g2:GetCount()<=0) or not Duel.SelectYesNo(tp,aux.Stringid(10108004,4)) then return end
		  Duel.BreakEffect()
		  local op=0
		  if g1:GetCount()>0 and g2:GetCount()>0 then
			 op=Duel.SelectOption(tp,aux.Stringid(10108004,2),aux.Stringid(10108004,3))
		  elseif g2:GetCount()>0 then op=1
		  end
		  if op==0 then 
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local tg=g1:Select(tp,1,1,nil)
			 Duel.SendtoHand(tg,nil,REASON_EFFECT)
		  else
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			 local sg=g2:Select(tp,1,1,nil)
			 Duel.Summon(tp,sg:GetFirst(),true,nil)
		  end
	end
end