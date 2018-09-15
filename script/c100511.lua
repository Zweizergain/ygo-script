--妖怪退治「妖力掠夺者」
function c100511.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c100511.target)
	e1:SetOperation(c100511.activate)
	c:RegisterEffect(e1)	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetDescription(aux.Stringid(100511,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetTarget(c100511.stg)
	e2:SetOperation(c100511.sop)
	c:RegisterEffect(e2)
end
function c100511.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)>0
end
function c100511.sumfilter(c)
	return c:IsCode(1231600) and c:IsSummonable(true,nil,1)
end
function c100511.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c100511.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100511.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c100511.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100511.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c100511.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c100511.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1) 
		Duel.BreakEffect()
		local tc2=Duel.GetFirstTarget()
		if tc2:IsFaceup() and tc2:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc2:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc2:RegisterEffect(e2)
			if not tc2:IsType(TYPE_TRAPMONSTER) then
				local code=tc2:GetOriginalCodeRule()
				local cid=tc:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
				local e3=Effect.CreateEffect(tc)
				e3:SetDescription(aux.Stringid(43387895,1))
				e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e3:SetCode(EVENT_PHASE+PHASE_END)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e3:SetCountLimit(1)
				e3:SetRange(LOCATION_MZONE)
				e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e3:SetLabelObject(e1)
				e3:SetLabel(cid)
				e3:SetOperation(c100511.rstop)
				tc:RegisterEffect(e3)
			end		
		end
	end 
end
function c100511.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c100511.cfilter(c,tp)
	return c:IsControler(tp) and not c:IsReason(REASON_DRAW)
end
function c100511.filter4(c)
	return c:IsCode(1231600) and c:IsAbleToHand()
end
function c100511.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c100511.cfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c100511.filter4,tp,LOCATION_DECK,0,1,nil) end
	local pg=eg:Filter(c100511.cfilter,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c100511.cfilter2(c,tp)
	return c:GetControler()==tp and not c:IsLocation(LOCATION_HAND)
end
function c100511.sop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c100511.filter4,tp,LOCATION_DECK,0,1,nil) then
		if not eg:IsExists(c100511.cfilter2,1,nil,tp) and Duel.SendtoGrave(eg,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c100511.filter4,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end