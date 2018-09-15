--秘术
function c1231610.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetDescription(aux.Stringid(1231610,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1231610)
	e1:SetTarget(c1231610.sptg)
	e1:SetOperation(c1231610.activate)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e2:SetDescription(aux.Stringid(1231610,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCountLimit(1,1231610)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c1231610.sumtg)
	e2:SetOperation(c1231610.sumop)
	c:RegisterEffect(e2)	
end 
function c1231610.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand() and c:GetAttack()==2*c:GetDefense()
end
function c1231610.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1231610.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,1231610,RESET_PHASE+PHASE_END,0,1)
end
function c1231610.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c1231610.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 

function c1231610.sumfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:GetAttack()==2*c:GetDefense() and c:IsSummonable(true,nil,1)
end
function c1231610.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1231610.sumfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.RegisterFlagEffect(tp,1231610,RESET_PHASE+PHASE_END,0,1)
end
function c1231610.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c1231610.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
			Duel.Summon(tp,tc,true,nil,1) 
			local tc2=Duel.GetDecktopGroup(tp,1):GetFirst()
			if Duel.SendtoHand(tc2,nil,REASON_EFFECT)~=0 then 
				Duel.ConfirmCards(1-tp,tc2)
				local typ=0
				if bit.band(tc2:GetType(),TYPE_MONSTER)~=0 then typ=typ+TYPE_MONSTER end 
				if bit.band(tc2:GetType(),TYPE_SPELL)~=0 then typ=typ+TYPE_SPELL end 
				if bit.band(tc2:GetType(),TYPE_TRAP)~=0 then typ=typ+TYPE_TRAP end 
				typ=TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER-typ
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetRange(LOCATION_MZONE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(c1231610.efilter)
				e1:SetLabel(typ)
				tc:RegisterEffect(e1)			
			end 
	end
end
function c1231610.efilter(e,te)
	return te:IsActiveType(e:GetLabel()) and te:GetOwner()~=e:GetHandler() and e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end