--「Scarlet Gensoukyo(超同调)」
--require "nef/thcz"
function c60615.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60615+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)	
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60615,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c60615.matcon)
	e3:SetTarget(c60615.mattg)
	e3:SetOperation(c60615.matop)
	c:RegisterEffect(e3)	
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c60615.handcon)
	c:RegisterEffect(e2)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c60615.tgcon)
	e4:SetValue(c60615.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c60615.tgcon)
	e5:SetValue(c60615.effectfilter)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCode(EFFECT_ADD_SETCODE)
	e6:SetTarget(aux.TRUE)
	e6:SetValue(0x813)
	c:RegisterEffect(e6)
	-- --synchro summon
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	-- e2:SetDescription(aux.Stringid(60615,0))
	-- e2:SetCountLimit(1,60615+EFFECT_COUNT_CODE_OATH)
	-- e2:SetType(EFFECT_TYPE_ACTIVATE)
	-- e2:SetCode(EVENT_FREE_CHAIN)
	-- e2:SetCost(c60615.cost)
	-- e2:SetTarget(c60615.sctg)
	-- e2:SetOperation(c60615.scop)
	-- c:RegisterEffect(e2)	
	-- --synchro summon
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetDescription(aux.Stringid(60615,1))
	-- e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	-- e1:SetCountLimit(1,60615+EFFECT_COUNT_CODE_OATH)
	-- e1:SetType(EFFECT_TYPE_ACTIVATE)
	-- e1:SetCode(EVENT_FREE_CHAIN)
	-- e1:SetCost(c60615.cost2)
	-- e1:SetTarget(c60615.target)
	-- e1:SetOperation(c60615.activate)
	-- --c:RegisterEffect(e1)	
end

function c60615.handcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>0 and g:FilterCount(Card.IsSetCard,nil,0x813)==g:GetCount()
end
function c60615.tgcon(e)
	local tp=e:GetHandlerPlayer()
	local p = Duel.GetCurrentPhase()
	return p==PHASE_MAIN1
end
function c60615.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return p==tp and bit.band(loc,LOCATION_ONFIELD)~=0 and (tc:IsSetCard(0x813) or tc:IsSetCard(0x814)) 
end
function c60615.filter(c,tp)
	return bit.band(c:GetReason(),0x41)==0x41 and c:IsSetCard(0x813) and bit.band(c:GetPreviousLocation(),LOCATION_ONFIELD)~=0
		and c:GetPreviousControler()==tp and c:IsType(TYPE_MONSTER)
end
function c60615.matcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60615.filter,1,nil,tp)
end
function c60615.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c60615.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

-- function c60615.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	-- if chk==0 then return Duel.IsExistingMatchingCard(c60615.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	-- Duel.DiscardHand(tp,c60615.filter,1,1,REASON_COST+REASON_DISCARD)
-- end
-- function c60615.filter(c)
	-- return c:IsDiscardable() and c:IsSetCard(0x813)
-- end
-- function c60615.filter2(c,e,tp)
	-- local lv=c:GetLevel()
	-- local ap=c:GetControler()
	-- return c:IsReleasable() and (c:IsType(TYPE_TUNER) or c:IsCode(60300)) and Duel.IsExistingMatchingCard(c60615.filter3,ap,0,LOCATION_MZONE,1,nil,lv,e,tp)
-- end
-- function c60615.filter3(c,lv,e,tp)
	-- local lv1=c:GetLevel()-lv
	-- return Duel.IsExistingMatchingCard(c60615.exfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,lv1,e,tp)
-- end
-- function c60615.exfilter(c,lv,e,tp)
	-- return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,false) and c:IsType(TYPE_SYNCHRO)
-- end
-- function c60615.spfilter(c,e,tp)
	-- local a=Duel.IsExistingMatchingCard(c60615.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp)
	-- local b=Duel.IsExistingMatchingCard(c60615.filter2,1-tp,LOCATION_MZONE,0,1,nil,e,tp)
	-- return a or b
-- end
-- function c60615.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- if chk==0 then return Duel.IsExistingMatchingCard(c60615.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		-- and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	-- Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
-- end
-- function c60615.scop(e,tp,eg,ep,ev,re,r,rp)
	-- local a=Duel.IsExistingMatchingCard(c60615.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp)	
	-- local b=Duel.IsExistingMatchingCard(c60615.filter2,1-tp,LOCATION_MZONE,0,1,nil,e,tp)
	-- if not (a or b) then return false end 
	-- local ap=1-tp
	-- if a then ap=tp end 
	-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	-- local ac=Duel.SelectMatchingCard(tp,c60615.filter2,ap,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	-- local lv=ac:GetLevel()
	-- local ar=Duel.SelectMatchingCard(tp,c60615.filter3,1-ap,LOCATION_MZONE,0,1,1,nil,lv,e,tp)
	-- local lv2=ar:GetFirst():GetLevel()-lv
	-- ar:AddCard(ac)
	-- Duel.Release(ar,REASON_EFFECT)
	-- Duel.BreakEffect()
	-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	-- local tc=Duel.SelectMatchingCard(tp,c60615.exfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,lv2,e,tp)
	-- if tc and tc:GetCount()>0 and Duel.SpecialSummon(tc,SUMMON_TYPE_SPECIAL,tp,tp,true,fasle,POS_FACEUP) then
		-- tc=tc:GetFirst()
		-- tc:RegisterFlagEffect(60615,RESET_EVENT+0x1fe0000,0,1)
		-- local e2=Effect.CreateEffect(e:GetHandler())
		-- e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		-- e2:SetCode(EVENT_PHASE+PHASE_END)
		-- e2:SetCountLimit(1)
		-- e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		-- e2:SetLabelObject(tc)
		-- e2:SetCondition(c60615.descon)
		-- e2:SetOperation(c60615.desop)
		-- Duel.RegisterEffect(e2,tp)
		-- tc:CompleteProcedure()
	-- end 
-- end
-- function c60615.descon(e,tp,eg,ep,ev,re,r,rp)
	-- local tc=e:GetLabelObject()
	-- if tc:GetFlagEffect(60615)~=0 then
		-- return true
	-- else
		-- e:Reset()
		-- return false
	-- end
-- end
-- function c60615.desop(e,tp,eg,ep,ev,re,r,rp)
	-- local tc=e:GetLabelObject()
	-- Duel.Destroy(tc,REASON_EFFECT)
-- end
-- function c60615.cfilter(c)
	-- return c:IsReleasable() and c:IsSetCard(0x813)
-- end
-- function c60615.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	-- if chk==0 then return Duel.CheckReleaseGroup(tp,c60615.cfilter,1,nil) end
	-- local g=Duel.SelectReleaseGroup(tp,c60615.cfilter,1,1,nil)
	-- Duel.Release(g,REASON_COST)
-- end
-- function c60615.target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- if chk==0 then return Duel.GetFieldGroupCount(tp,0x1f,0x1f)>1 end
-- end
-- function c60615.activate(e,tp,eg,ep,ev,re,r,rp)

-- end