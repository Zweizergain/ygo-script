--「Scarlet Overlay（绯色叠光）」
function c60614.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,60614+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60614.spcom)
	e1:SetCost(c60614.cost2)
	e1:SetTarget(c60614.target)
	e1:SetOperation(c60614.activate)
	c:RegisterEffect(e1)
	--xyzsummmon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60614,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMING_DRAW_PHASE+TIMING_SUMMON+TIMING_END_PHASE)
	e2:SetTarget(c60614.sptg)
	e2:SetOperation(c60614.spop)
	c:RegisterEffect(e2)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c60614.tgcon)
	e4:SetValue(c60614.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c60614.tgcon)
	e5:SetValue(c60614.effectfilter)
	c:RegisterEffect(e5)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c60614.handcon)
	c:RegisterEffect(e3)
end
function c60614.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x813)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60614.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x813)
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,sg:GetFirst(),mg,1,mg:GetCount())
	end
end

function c60614.handcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>0 and g:FilterCount(Card.IsSetCard,nil,0x813)==g:GetCount()
end
function c60614.filter2(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x813) and c:GetSummonPlayer()==tp
end
function c60614.spcom(e,tp,eg,ep,ev,re,r,rp) 
	return eg:GetCount()==1 and eg:IsExists(c60614.filter2,1,nil,tp) 
end
function c60614.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Group.CreateGroup()
	g:AddCard(eg:GetFirst())
	e:SetLabelObject(g)
	g:KeepAlive()
end
function c60614.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,60614,0,0x814,2700,2700,8,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60614.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.BreakEffect()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,60614,0,0x814,2700,2700,8,RACE_FIEND,ATTRIBUTE_DARK) then return end
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		c:AddMonsterAttributeComplete()
		Duel.SpecialSummonComplete()
	local ac=e:GetLabelObject():GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(ac:GetLevel())
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetValue(ac:GetOriginalCode())
	c:RegisterEffect(e3)
	e:GetLabelObject():DeleteGroup()
end
function c60614.tgcon(e)
	local tp=e:GetHandlerPlayer()
	local p = Duel.GetCurrentPhase()
	return p==PHASE_MAIN2
end
function c60614.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return p==tp and bit.band(loc,LOCATION_ONFIELD)~=0 and (tc:IsSetCard(0x813) or tc:IsSetCard(0x814)) and tc~=e:GetHandler()
end