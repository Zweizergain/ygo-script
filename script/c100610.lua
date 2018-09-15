--神符「神所踏足之御神渡」
function c100610.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100610.cost1)
	e1:SetTarget(c100610.target1)
	e1:SetOperation(c100610.activate)
	c:RegisterEffect(e1)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(100610,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(c100610.cost)
    e1:SetTarget(c100610.target)
    e1:SetOperation(c100610.operation)
    c:RegisterEffect(e1)    	
	--zha ka
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100610,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c100610.disct)
	e2:SetTarget(c100610.distg)
	e2:SetOperation(c100610.disop) 
	c:RegisterEffect(e2)
	--instant
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100610,2))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c100610.condition2)
	e3:SetTarget(c100610.target2)
	e3:SetOperation(c100610.activate)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
end
function c100610.filter(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function c100610.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	if (tp~=tn and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2))
		and Duel.IsExistingMatchingCard(c100610.filter,tp,LOCATION_HAND,0,1,nil)
		and Duel.SelectYesNo(tp,94) then
		e:SetLabel(1)
	end
end
function c100610.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabel()~=1 then return end
	if Duel.GetTurnPlayer()==tp then return end 
	e:GetHandler():RegisterFlagEffect(100610,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c100610.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToHand() and c:GetAttack()==2*c:GetDefense()
end
function c100610.cost(e,tp,eg,ep,ev,re,r,rp,chk)    
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c100610.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100610.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100610.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c100610.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 

function c100610.filter(c)
	return (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1))
		and c:IsAttribute(ATTRIBUTE_WIND)
end
function c100610.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=1 then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetTurnPlayer()==tp then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c100610.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0xfe0000)
			e1:SetValue(LOCATION_HAND)
			tc:RegisterEffect(e1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
function c100610.condition2(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return tn~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c100610.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100610.filter,tp,LOCATION_HAND,0,1,nil) 
		and e:GetHandler():GetFlagEffect(100610)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end


function c100610.disct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c100610.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100610.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end