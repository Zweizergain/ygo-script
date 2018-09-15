--机师 基拉·大和
function c26000170.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c26000170.syncon)
	e1:SetTarget(c26000170.syntg)
	e1:SetValue(1)
	e1:SetOperation(c26000170.synop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26000170,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,26000170)
	e2:SetCost(c26000170.cost)
	e2:SetTarget(c26000170.target)
	e2:SetOperation(c26000170.operation)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26000170,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,26000171)
	e3:SetTarget(c26000170.thtg2)
	e3:SetOperation(c26000170.thop2)
	c:RegisterEffect(e3)
end
function c26000170.synfilter1(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c26000170.synfilter2(c,syncard,tuner,f,g,lv,minc,maxc)
	if c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c)) then
		lv=lv-c:GetLevel()
		if lv<0 then return false end
		if lv==0 then return minc==1 end
		return g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc-1,maxc-1,syncard)
	else return false end
end
function c26000170.syncon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c26000170.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g1=Duel.GetMatchingGroup(c26000170.synfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	return g1:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
		or Duel.IsExistingMatchingCard(c26000170.synfilter2,tp,LOCATION_HAND,0,1,nil,syncard,c,f,g1,lv,minc,maxc)
end
function c26000170.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g1=Duel.GetMatchingGroup(c26000170.synfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local g2=Duel.GetMatchingGroup(c26000170.synfilter2,tp,LOCATION_HAND,0,nil,syncard,c,f,g1,lv,minc,maxc)
	if not g1:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
		or (g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(26000170,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=g2:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if lv>tc:GetLevel() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local tg=g1:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv-tc:GetLevel(),minc-1,maxc-1,syncard)
			sg:Merge(tg)
		end
		Duel.SetSynchroMaterial(sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=g1:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
		Duel.SetSynchroMaterial(sg)
	end
end
function c26000170.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c26000170.filter(c)
	return c:IsSetCard(0xff8) and c:IsAbleToHand()
end
function c26000170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26000170.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26000170.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26000170.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26000170.thfilter2(c)
	return c:IsCode(26000070) and c:IsAbleToHand()
end
function c26000170.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26000170.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26000170.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26000170.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end