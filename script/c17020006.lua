--樱火装机王 吉野樱
function c17020006.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c17020006.splimit)
	c:RegisterEffect(e1)
	--scale
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17020006,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,17020006)
	e2:SetTarget(c17020006.target)
	e2:SetOperation(c17020006.operation)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17020006,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
	e3:SetCost(c17020006.spcost)
	e3:SetCountLimit(1,17020106)
	e3:SetTarget(c17020006.sptg)
	e3:SetOperation(c17020006.spop)
	c:RegisterEffect(e3)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11366199,2))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,17020106)
	e4:SetTarget(c17020006.tgtg)
	e4:SetOperation(c17020006.tgop)
	c:RegisterEffect(e4) 
end
function c17020006.tgfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x702) or c:IsAttribute(ATTRIBUTE_FIRE)) and c:IsType(TYPE_MONSTER)
end
function c17020006.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c17020006.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c17020006.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17020006,3))
	local sg=Duel.SelectTarget(tp,c17020006.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function c17020006.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
function c17020006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c17020006.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c17020006.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,0,1,1,c,tp,c)
	local g=Group.FromCards(c)
	g:Merge(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c17020006.spfilter2,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,0,1,1,g)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c17020006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not c:IsLocation(LOCATION_EXTRA)) or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c17020006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c17020006.spfilter(c,tp,rc)
	local g=Group.FromCards(c,rc)
	return c17020006.spfilter2(c) and (c:IsSetCard(0x702) or c:IsAttribute(ATTRIBUTE_FIRE)) and Duel.IsExistingMatchingCard(c17020006.spfilter2,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,0,1,g) 
end
function c17020006.spfilter2(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c17020006.splimit(e,c)
	return not c:IsSetCard(0x702) and not c:IsCode(17020019)
end
function c17020006.dfilter(c)
	return not c:IsSetCard(0x1702)
end
function c17020006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c17020006.dfilter,tp,LOCATION_PZONE,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c17020006.sfilter,tp,LOCATION_DECK,0,1,nil) end
	local tc=Duel.GetFirstMatchingCard(c17020006.dfilter,tp,LOCATION_PZONE,0,e:GetHandler())
	Duel.SetTargetCard(tc)
end
function c17020006.sfilter(c)
	return c:IsSetCard(0x702) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c17020006.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c17020006.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
		   Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end