--白魔术调弦师
function c34340038.initial_effect(c)
	c:EnableReviveLimit()
	c:EnableCounterPermit(0x18)
	aux.AddLinkProcedure(c,c34340038.lfilter,1) 
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(c34340038.lfilter2)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetOperation(c34340038.ctop)
	c:RegisterEffect(e2)
	--attackup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c34340038.attackup)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c34340038.thcost)
	e4:SetTarget(c34340038.thtg)
	e4:SetOperation(c34340038.thop)
	c:RegisterEffect(e4)
end
c34340038.setname="WhiteMagician"
function c34340038.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x18,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x18,3,REASON_COST)
end
function c34340038.thfilter1(c)
	return c.setname=="WhiteAlbum" and c:IsAbleToHand()
end
function c34340038.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34340038.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c34340038.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c34340038.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c34340038.attackup(e,c)
	return c:GetCounter(0x18)*300
end
function c34340038.lfilter(c)
	return c:IsLevel(1) and c.setname=="WhiteMagician"
end
function c34340038.lfilter2(c)
	return c.setname=="WhiteMagician"
end
function c34340038.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE)
end
function c34340038.ctfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
end
function c34340038.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c34340038.ctfilter,1,nil,tp) then 
	   e:GetHandler():AddCounter(0x18,1) 
	end
	if eg:IsExists(c34340038.ctfilter2,1,nil,tp) then 
	   e:GetHandler():AddCounter(0x18,2) 
	end
end
