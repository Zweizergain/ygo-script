--灰篮恐慌
function c65080033.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65080033,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65080033.spcon)
	e2:SetOperation(c65080033.spop)
	c:RegisterEffect(e2)   
	--negate effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65080033,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_SEARCH)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,65080033+EFFECT_COUNT_CODE_SINGLE)
	e3:SetCondition(c65080033.con)
	e3:SetTarget(c65080033.negtg)
	e3:SetOperation(c65080033.negop)
	c:RegisterEffect(e3)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(65080033,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCategory(CATEGORY_DISABLE+CATEGORY_SEARCH)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,65080033+EFFECT_COUNT_CODE_SINGLE)
	e5:SetCondition(c65080033.con)
	e5:SetTarget(c65080033.sertg)
	e5:SetOperation(c65080033.serop)
	c:RegisterEffect(e5)
end

function c65080033.cosfil(c)
	return c:IsSetCard(0xd1)
end

function c65080033.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c65080033.cosfil,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=4
end

function c65080033.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end

function c65080033.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65080033.spfilter),tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:RegisterFlagEffect(65080033,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCondition(c65080033.descon)
			e1:SetOperation(c65080033.desop)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			e1:SetCountLimit(1)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetLabelObject(tc)
			Duel.RegisterEffect(e1,tp)
		end
	end 
	c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65080033,2))
end

function c65080033.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(65080033)~=0
end
function c65080033.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end

function c65080033.cfilter(c)
	return c:IsFaceup() and not c:IsDisabled() 
end

function c65080033.filter(c,tp,re,r,rp)
	return c:IsSetCard(0xd1) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and (rp~=tp or re:GetHandler():IsSetCard(0xd1))))
end

function c65080033.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65080033.filter,1,nil,tp,re,r,rp) 
end

function c65080033.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65080033.cfilter,tp,0,LOCATION_ONFIELD,1,nil) end
end

function c65080033.sertg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65080033.cosfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetTurnPlayer()~=tp end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c65080033.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	   local g1=Duel.SelectMatchingCard(tp,c65080033.cfilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	   local tc=g1:GetFirst()
	   if g1:GetCount()>0 and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
			Duel.HintSelection(g1)
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
	  end
end

function c65080033.serop(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.SelectMatchingCard(tp,c65080033.cosfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g2,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g2)
end