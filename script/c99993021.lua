--核心飞舞-伊芙
function c99993021.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99993021,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99993021)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local fil=function(c) return c:GetLevel()==4 and c:IsAbleToRemoveAsCost() end
		if chk==0 then return Duel.IsExistingMatchingCard(fil,tp,LOCATION_GRAVE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,fil,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c99993021.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c99993021.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99993021,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c99993021.target)
	e2:SetOperation(c99993021.operation)
	c:RegisterEffect(e2)
end
c99993021.Remi_named_with_eve=true
function c99993021.Remi_IsEve(c,f)
	local func=f or Card.GetCode
	local t={func(c)}
	for i,code in pairs(t) do
		local m=_G["c"..code]
		if m and m.Remi_named_with_eve then return true end
	end
	return false
end
function c99993021.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c99993021.Remi_IsEve(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99993021.tgfilter(c,level)
	return c:IsFaceup() and c99993021.Remi_IsEve(c) and c:GetLevel()~=level and c:GetLevel()>=1
end
function c99993021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local level=c:GetLevel()
	if chkc then return chkc~=c and chkc:IsLocation(LOCATION_MZONE) and c99993021.tgfilter(chkc,level) end
	if chk==0 then return level>0 and Duel.IsExistingTarget(c99993021.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,level) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c99993021.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,level)
end
function c99993021.operation(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetLevel())
		c:RegisterEffect(e1)
	end
end