--季雨 文静蓝白
function c10118002.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10118002,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10118002.discon)
	e1:SetCost(c10118002.discost)
	e1:SetTarget(c10118002.distg)
	e1:SetOperation(c10118002.disop)
	e1:SetValue(SUMMON_TYPE_RITUAL)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone() 
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	e2:SetLabel(0)
	c:RegisterEffect(e2)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10118002,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,0x11e0)
	e3:SetCountLimit(1,10118002)
	e3:SetCost(c10118002.rmcost)
	e3:SetTarget(c10118002.rmtg)
	e3:SetOperation(c10118002.rmop)
	c:RegisterEffect(e3)
end
function c10118002.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c10118002.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
end
function c10118002.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c10118002.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev) and ((bit.band(re:GetActivateLocation(),LOCATION_ONFIELD)~=0 and e:GetLabel()==1) or (bit.band(re:GetActivateLocation(),LOCATION_ONFIELD)==0 and e:GetLabel()==0))
end
function c10118002.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and c:IsSummonType(e:GetValue()) end
	Duel.Release(c,REASON_COST)
end
function c10118002.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c10118002.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsAbleToRemove() then
	   Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end