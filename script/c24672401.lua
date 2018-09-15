--错预感迷魔雾
function c24672401.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24672401,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c24672401.e1con)
	e1:SetTarget(c24672401.e1tg)
	e1:SetOperation(c24672401.e1op)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24672401,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,24672401)
	e3:SetCost(c24672401.e3cost)
	e3:SetTarget(c24672401.e3tg)
	e3:SetOperation(c24672401.e3op)
	c:RegisterEffect(e3)
end
function c24672401.e1op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		if Duel.SpecialSummonComplete() then
		Duel.BreakEffect()
		local ac=Duel.GetMatchingGroupCount(c24672401.d4cfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		tc:AddCounter(0x1019,ac)
		end
	end
end
function c24672401.counterfil(c)
	return c:IsFaceup() and c:IsSetCard(0x18) and c:IsType(TYPE_MONSTER)
end
function c24672401.egtgfil(c,e)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and c:IsCanBeEffectTarget(e) and c:IsSetCard(0x18) and c:IsType(TYPE_MONSTER)
end
function c24672401.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c24672401.egtgfil(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c24672401.egtgfil,tp,LOCATION_GRAVE,0,1,nil,e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c24672401.egtgfil,tp,LOCATION_GRAVE,0,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c24672401.e1con(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:GetPreviousControler()==tp and tc:IsReason(REASON_DESTROY) and tc:IsSetCard(0x18)
		and tc:GetReasonEffect() and tc:GetReasonEffect():GetOwner()==tc
end
function c24672401.e2con(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if not at or tc:IsFacedown() or at:IsFacedown() then return false end
	if tc:IsControler(1-tp) then 
	e:SetLabelObject(tc)
	return at:IsControler(tp) and at:IsLocation(LOCATION_MZONE) and at:IsSetCard(0x18)
	elseif tc:IsControler(tp) then 
	e:SetLabelObject(at)
	return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) and tc:IsSetCard(0x18)
	end
end
function c24672401.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and not tc:IsImmuneToEffect(e) then
		local av=Duel.GetCounter(0,1,1,0x1019)*100
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-av)
		tc:RegisterEffect(e1)
	end
end
function c24672401.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c24672401.e3op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
end
function c24672401.d3cfil(c,tb)
	return c:IsSetCard(0x18) and c:IsControler(tb) and c:IsFaceup()
end
function c24672401.d4cfil(c)
	return c:IsSetCard(0x18) and c:IsFaceup()
end
function c24672401.e3cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tb=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(c24672401.d3cfil,tp,LOCATION_MZONE,0,1,nil,tb) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c24672401.d3cfil,tp,LOCATION_MZONE,0,1,1,nil,tb)
	if g:GetCount()>0 then
	local ac=Duel.GetMatchingGroupCount(c24672401.d4cfil,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
		tc:AddCounter(0x1019,ac)
	end
end