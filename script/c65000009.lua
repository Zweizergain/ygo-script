--圣洁歌姬 LV8
function c65000009.initial_effect(c)
	c:EnableReviveLimit()
	--back
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65000009,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65000009)
	e1:SetCondition(c65000009.baccon)
	e1:SetTarget(c65000009.bactar)
	e1:SetOperation(c65000009.bacop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65000009,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c65000009.target)
	e2:SetOperation(c65000009.operation)
	c:RegisterEffect(e2)
end

c65000009.lvupcount=1
c65000009.lvup={65000008}
c65000009.lvdncount=2
c65000009.lvdn={65000007,65000008}

function c65000009.bacfilter(c,tp,rp)
	return c:GetPreviousControler()==tp and c:IsPreviousSetCard(0x41) and c:IsType(TYPE_MONSTER) and (c:IsReason(REASON_BATTLE) or (rp~=tp and c:IsReason(REASON_EFFECT)))
end
function c65000009.baccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65000009.bacfilter,1,nil,tp,rp)
end

function c65000009.filter1(c,e,tp)
	return c:IsSetCard(0x41) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) 
end

function c65000009.filter2(c,e,tp)
	return c:IsSetCard(0x41) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_MONSTER) 
end

function c65000009.bactar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local t1=Duel.IsExistingMatchingCard(c65000009.filter1,tp,LOCATION_GRAVE,0,1,nil)
	local t2=Duel.IsExistingMatchingCard(c65000009.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and (c65000009.filter1(chkc) or c65000009.filter2(chkc,e,tp)) end
	if chk==0 then return t1 or t2 end
	local op=0
	if t1 or t2 then
		local m={}
		local n={}
		local ct=1
		if t1 then m[ct]=aux.Stringid(65000009,0) n[ct]=0 ct=ct+1 end
		if t2 then m[ct]=aux.Stringid(65000009,1) n[ct]=1 ct=ct+1 end
		local sp=Duel.SelectOption(tp,table.unpack(m))
		op=n[sp+1]
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectTarget(tp,c65000009.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,tp,LOCATION_GRAVE)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectTarget(tp,c65000009.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,tp,LOCATION_GRAVE)
	end
end

function c65000009.bacop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	elseif e:GetLabel()==1 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end

function c65000009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c65000009.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65000009.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c65000009.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c65000009.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end