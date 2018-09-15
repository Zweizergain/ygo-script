--「Scarlet Destiny（绯色命运）」
function c60610.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60610+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c60610.target)
	e1:SetOperation(c60610.activate)
	c:RegisterEffect(e1)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c60610.tgcon)
	e4:SetValue(c60610.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c60610.tgcon)
	e5:SetValue(c60610.effectfilter)
	c:RegisterEffect(e5)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60610,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c60610.matcon)
	e3:SetTarget(c60610.mattg)
	e3:SetOperation(c60610.matop)
	c:RegisterEffect(e3)	
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c60610.handcon)
	c:RegisterEffect(e2)
end
function c60610.handcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>0 and g:FilterCount(Card.IsSetCard,nil,0x813)==g:GetCount()
end
function c60610.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x813) 
end
function c60610.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false) and c:IsSetCard(0x813) 
end
function c60610.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c60610.filter2,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c60610.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c60610.filter2,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60610.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end 
	local tc=Duel.SelectMatchingCard(tp,c60610.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	if tc and Duel.Destroy(tc,REASON_EFFECT)>0 then 
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c60610.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if not tc then return end
		if Duel.SpecialSummon(tc,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)~=0 then
			if tc:IsCode(1231300) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)				
				local tc=Duel.SelectMatchingCard(tp,c60610.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)		
				Duel.Destroy(tc,REASON_EFFECT)
			end 
		end
	end 
end
function c60610.tgcon(e)
	local tp=e:GetHandlerPlayer()
	local p = Duel.GetCurrentPhase()
	return bit.band(p,0xf8)==p
end
function c60610.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return p==tp and bit.band(loc,LOCATION_ONFIELD)~=0 and (tc:IsSetCard(0x813) or tc:IsSetCard(0x814)) and tc~=e:GetHandler()
end
function c60610.filter(c,tp)
	return bit.band(c:GetReason(),0x41)==0x41 and c:IsSetCard(0x813) and c:IsType(TYPE_MONSTER) and bit.band(c:GetPreviousLocation(),LOCATION_ONFIELD)~=0
		and c:GetPreviousControler()==tp
end
function c60610.matcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60610.filter,1,nil,tp)
end
function c60610.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60610.matop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
	end
end
