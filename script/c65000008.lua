--圣洁歌姬 LV6
function c65000008.initial_effect(c)
	--back
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65000008,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65000008)
	e1:SetCondition(c65000008.baccon)
	e1:SetTarget(c65000008.bactar)
	e1:SetOperation(c65000008.bacop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65000008,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c65000008.target)
	e2:SetOperation(c65000008.operation)
	c:RegisterEffect(e2)
	--lv up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65000008,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(c65000008.spcon)
	e3:SetCost(c65000008.spcost)
	e3:SetTarget(c65000008.sptg)
	e3:SetOperation(c65000008.spop)
	c:RegisterEffect(e3)
end

c65000008.lvupcount=1
c65000008.lvup={65000009}
c65000008.lvdncount=1
c65000008.lvdn={65000007}

function c65000008.confilter(c,tp,rp)
	return c:GetPreviousControler()==tp and c:IsPreviousSetCard(0x41) and c:IsType(TYPE_MONSTER)
end
function c65000008.baccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65000008.confilter,1,nil,tp,rp)
end
function c65000008.bacfilter(c,e,tp)
	return c:IsSetCard(0x41) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) 
end

function c65000008.bactar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65000008.bacfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65000008.bacfilter,tp,LOCATION_GRAVE,0,1,nil) or t2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectTarget(tp,c65000008.bacfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,tp,LOCATION_GRAVE)
end

function c65000008.bacop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
end

function c65000008.filter(c)
	return c:IsType(TYPE_MONSTER)
end

function c65000008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c65000008.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65000008.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c65000008.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c65000008.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function c65000008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c65000008.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c65000008.spfilter(c,e,tp)
	return c:IsCode(65000009) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c65000008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c65000008.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c65000008.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65000008.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end