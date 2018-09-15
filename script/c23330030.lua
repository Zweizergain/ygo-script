--残霞的奇迹
function c23330030.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,23330030)
	e1:SetCost(c23330030.cost)
	e1:SetTarget(c23330030.tg)
	e1:SetOperation(c23330030.op)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28039390,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c23330030.tgtg)
	e2:SetOperation(c23330030.tgop)
	c:RegisterEffect(e2)
end
function c23330030.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x555)
end
function c23330030.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c23330030.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c23330030.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectTarget(tp,c23330030.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,1,0,0)
end
function c23330030.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
function c23330030.tg(e,tp,eg,ep,ev,re,r,rp,chk)
   local g=Duel.GetMatchingGroup(c23330030.mfilter,tp,LOCATION_GRAVE,0,1,nil)
   if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c23330030.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) and Duel.GetLocationCountFromEx(tp)>0
   end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
   local rg=Duel.SelectMatchingCard(tp,c23330030.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g)
   Duel.ConfirmCards(1-tp,rg)
   Duel.SetTargetCard(rg)
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c23330030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c23330030.mfilter(c)
   return c:IsType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial()
end
function c23330030.spfilter(c,e,tp,g)
   return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and g:IsExists(c23330030.gfilter,1,nil,c,g) and not c:IsCode(23330033)
end
function c23330030.gfilter(c,sc,g)
   return sc:IsSynchroSummonable(c,g)
end
function c23330030.op(e,tp,eg,ep,ev,re,r,rp)
   local c=Duel.GetFirstTarget()
   local g=Duel.GetMatchingGroup(c23330030.mfilter,tp,LOCATION_GRAVE,0,1,nil)
   if Duel.GetLocationCountFromEx(tp)>0 and c:IsLocation(LOCATION_EXTRA) and c:IsRelateToEffect(e) and c:IsSynchroSummonable(nil,g) then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	  local tc=g:FilterSelect(tp,c23330030.gfilter,1,1,nil,c,g):GetFirst()
	  if not tc then return end
	  local f=Duel.SendtoGrave
	  Duel.SendtoGrave=Duel.SendtoGraveX
	  Duel.SynchroSummon(tp,c,tc,g)
	  Duel.SendtoGrave=f
   end
end
function Duel.SendtoGraveX(g,reason)
	Duel.Remove(g,POS_FACEUP,reason)
end



