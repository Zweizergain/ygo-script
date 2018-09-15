--九龙仙女 冰葵
function c44444499.initial_effect(c)
    c:EnableReviveLimit()
	--special summon 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44449499,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCost(c44444499.hspcost1)
	e1:SetTarget(c44444499.hsptg1)
	e1:SetOperation(c44444499.hspop1)
	c:RegisterEffect(e1)
	--special summon 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44449499,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCost(c44444499.hspcost2)
	e2:SetTarget(c44444499.hsptg2)
	e2:SetOperation(c44444499.hspop2)
	c:RegisterEffect(e2)
	--return
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(44444499,3))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_REPEAT)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c44444499.retcon)
	e4:SetTarget(c44444499.rettg)
	e4:SetOperation(c44444499.retop)
	c:RegisterEffect(e4)
	--back
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCost(c44444499.scost1)
	e5:SetTarget(c44444499.stg)
	e5:SetOperation(c44444499.sop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
end
function c44444499.cfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) and c:GetLevel()==4 
end
function c44444499.hspcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44444499.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,e:GetHandler()) end
	select=Duel.SelectOption(tp,aux.Stringid(44444499,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c44444499.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.ShuffleDeck(tp)
end
function c44444499.hsptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c44444499.hspop1(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c44444499.sfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost() and c:GetLevel()>=9 and c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c44444499.spcon2(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c44444499.sfilter,c:GetControler(),LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler())
end
function c44444499.hspcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44444499.sfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end
    select=Duel.SelectOption(tp,aux.Stringid(44444499,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c44444499.sfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.ShuffleDeck(tp)
end
function c44444499.hsptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c44444499.hspop2(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c44444499.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c44444499.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c44444499.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
function c44444499.dcfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c44444499.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44444499.dcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c44444499.dcfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c44444499.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c44444499.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(0)
		tc:RegisterEffect(e2)
	end
end
function c44444499.filter0(c)
	return c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToDeck())
end
function c44444499.filter1(c)
	return c:IsAbleToDeck()
end       
function c44444499.scost1(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    if chk==0 then return Duel.IsExistingMatchingCard(c44444499.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c44444499.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local atk=g:GetFirst():GetTextAttack()
	    if atk<0 then atk=0 end
	    e:SetLabel(atk)
	    Duel.SendtoDeck(g,nil,2,REASON_COST)

end
function c44444499.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=e:GetLabel()~=0
		e:SetLabel(0)
		return res
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
	e:SetLabel(0)
end
function c44444499.sop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(tp,1,REASON_EFFECT)
	Duel.Recover(p,d,REASON_EFFECT)
end
   
