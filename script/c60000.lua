--红魔馆
function c60000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60000+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetOperation(c60000.regop)
	c:RegisterEffect(e2)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetCountLimit(1)
	e6:SetCondition(c60000.spcon)
	e6:SetTarget(c60000.sptg)
	e6:SetOperation(c60000.spop)
	c:RegisterEffect(e6)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c60000.tgcon)
	e4:SetValue(c60000.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c60000.tgcon)
	e5:SetValue(c60000.effectfilter)
	c:RegisterEffect(e5)
	--lv
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22090,0))
	e3:SetCategory(CATEGORY_LVCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(c60000.target)
	e3:SetOperation(c60000.lvop)
	c:RegisterEffect(e3)
end
function c60000.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(60000,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,2)
end
function c60000.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetTurnID()~=Duel.GetTurnCount() and c:GetFlagEffect(60000)>0 and Duel.GetTurnPlayer()==tp
end
function c60000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c60000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,tp,REASON_EFFECT)
	end
end

function c60000.tgcon(e)
	local tp=e:GetHandlerPlayer()
	local p = Duel.GetCurrentPhase()
	return p==PHASE_STANDBY or p==PHASE_END
end
function c60000.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return p==tp and bit.band(loc,LOCATION_ONFIELD)~=0 and (tc:IsSetCard(0x813) or tc:IsSetCard(0x814)) and tc~=e:GetHandler()
end
function c60000.sumfilter(c)
	return c:IsSetCard(0x813) and c:IsFaceup()
end
function c60000.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c60000.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60000.sumfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c60000.sumfilter,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c60000.sumfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60000.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c60000.sumfilter,tp,LOCATION_MZONE,0,tc)
		local ac=g:GetFirst()
		while ac do 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(tc:GetLevel())
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			ac:RegisterEffect(e1)
			ac=g:GetNext()
		end 
	end
end