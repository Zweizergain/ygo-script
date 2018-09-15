--天选圣女 圣枪洁希德
function c10120001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10120001)
	e1:SetCondition(c10120001.spcon)
	e1:SetOperation(c10120001.spop)
	c:RegisterEffect(e1)   
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(10120001,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c10120001.thtg)
	e2:SetOperation(c10120001.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)   
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10120001,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c10120001.rhtg)
	e4:SetOperation(c10120001.rhop)
	c:RegisterEffect(e4)
		--dissummon
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON)
		ge1:SetOperation(c10120001.snop)
		ge1:SetLabelObject(e4)
		Duel.RegisterEffect(ge1,0) 
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON_SUCCESS) 
		ge2:SetOperation(c10120001.ssop)
		ge2:SetLabelObject(e4)
		Duel.RegisterEffect(ge2,0) 
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON)
		ge3:SetLabelObject(e4)
		Duel.RegisterEffect(ge3,0) 
		local ge4=ge2:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge4:SetLabelObject(e4)
		Duel.RegisterEffect(ge4,0) 

end

function c10120001.snop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsContains(e:GetOwner()) then
	e:GetOwner():RegisterFlagEffect(10120001,RESET_EVENT+RESET_OVERLAY+0x00102000,0,0)
   end
end

function c10120001.ssop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsContains(e:GetOwner()) then
	e:GetOwner():ResetFlagEffect(10120001)
   end
end

function c10120001.rhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetHandler():GetFlagEffect(10120001)==0 then return false end  
		e:GetHandler():ResetFlagEffect(10120001)
		return e:GetHandler():IsAbleToHand() 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function c10120001.rhop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)~=0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10120001,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	   local dg=g:Select(tp,1,1,nil)
	   Duel.Destroy(dg,REASON_EFFECT)
	end
end

function c10120001.thfilter(c)
	return c:IsSetCard(0x9331) and c:IsAbleToHand()
end

function c10120001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10120001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c10120001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10120001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		--Duel.BreakEffect()
		--Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end

function c10120001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10120001.cfilter,tp,LOCATION_HAND,0,1,c)
end

function c10120001.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsDiscardable()
end
function c10120001.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.DiscardHand(tp,c10120001.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end

