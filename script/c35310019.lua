--远古恶魔的复苏
function c35310019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35310019,0))
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c35310019.target)
	e2:SetOperation(c35310019.operation)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--th
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35310019,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CVAL_CHECK)
	e3:SetCountLimit(1,35310119)
	e3:SetCost(c35310019.thcost)
	e3:SetTarget(c35310019.thtg)
	e3:SetOperation(c35310019.thop)
	c:RegisterEffect(e3)	 
end
c35310019.setname="acfiend"
function c35310019.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c35310019.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c35310019.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c35310019.filter(c,se)
	if not c:IsSummonableCard() then return false end
	local mi,ma=c:GetTributeRequirement()
	return mi>0 and (c:IsSummonable(false,se) or c:IsMSetable(false,se))
end
function c35310019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local se=e:GetLabelObject()
	if chk==0 then return Duel.IsExistingMatchingCard(c35310019.filter,tp,LOCATION_HAND,0,1,nil,se) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c35310019.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local se=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c35310019.filter,tp,LOCATION_HAND,0,1,1,nil,se)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(false,se)
		local s2=tc:IsMSetable(false,se)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,false,se)
		else
			Duel.MSet(tp,tc,false,se)
		end
	end
end
