--狱火机·路西弗格
function c98707004.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c98707004.spcon)
	e2:SetOperation(c98707004.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98707004,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c98707004.descost)
	e3:SetTarget(c98707004.destg)
	e3:SetOperation(c98707004.desop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98707004,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetCondition(c98707004.rmcon)
	e4:SetCost(c98707004.rmcost)
	e4:SetTarget(c98707004.rmtg)
	e4:SetOperation(c98707004.rmop)
	c:RegisterEffect(e4)
end
function c98707004.spfilter(c)
	return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) and (c:IsAbleToRemoveAsCost() or c:IsLocation(LOCATION_REMOVED))
end
function c98707004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local sum=0
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsFaceup() and tc:IsType(TYPE_EFFECT) then
			if tc:IsType(TYPE_XYZ) then sum=sum+tc:GetRank()
			else sum=sum+tc:GetLevel() end
		end
	end
	if sum>8 then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<0 then return false end
	local loc=LOCATION_GRAVE+LOCATION_HAND
	if c:IsHasEffect(98707001) then
		loc=LOCATION_REMOVED+LOCATION_HAND
	end
	if c:IsHasEffect(34822850) then
		if ft>0 then
			return Duel.IsExistingMatchingCard(c98707004.spfilter,tp,LOCATION_MZONE+loc,0,1,c)
		else
			return Duel.IsExistingMatchingCard(c98707004.spfilter,tp,LOCATION_MZONE,0,1,nil)
		end
	else
		return ft>0 and Duel.IsExistingMatchingCard(c98707004.spfilter,tp,loc,0,1,c)
	end
end
function c98707004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=nil
	local loc=LOCATION_GRAVE+LOCATION_HAND
	if c:IsHasEffect(98707001) then
		loc=LOCATION_REMOVED+LOCATION_HAND
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if c:IsHasEffect(34822850) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			g=Duel.SelectMatchingCard(tp,c98707004.spfilter,tp,LOCATION_MZONE+loc,0,1,1,c)
		else
			g=Duel.SelectMatchingCard(tp,c98707004.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
		end
	else
		g=Duel.SelectMatchingCard(tp,c98707004.spfilter,tp,loc,0,1,1,c)
	end
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	g:Sub(g2)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SendtoGrave(g2,REASON_COST+REASON_RETURN)
end
function c98707004.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c98707004.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98707004.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c98707004.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c98707004.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsReleasable,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsReleasable,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c98707004.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c98707004.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
