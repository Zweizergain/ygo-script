--原初八文-震
function c21520203.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c21520203.cfilter,1,1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520203,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c21520203.destg)
	e1:SetOperation(c21520203.desop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520203,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c21520203.thcon)
	e2:SetTarget(c21520203.thtg)
	e2:SetOperation(c21520203.thop)
	c:RegisterEffect(e2)
end
function c21520203.cfilter(c)
	local g=Duel.GetMatchingGroup(c21520203.ckfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
		return (c:IsLinkAttribute(ATTRIBUTE_LIGHT) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000) or (c:IsSetCard(0x492) and not c:IsCode(21520203))
	else
		return c:IsLinkAttribute(ATTRIBUTE_LIGHT) and c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000
	end
end
function c21520203.ckfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x492) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:GetOriginalType()&TYPE_SPELL==TYPE_SPELL or c:GetOriginalType()&TYPE_TRAP==TYPE_TRAP)
end
function c21520203.desfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsFaceup()
end
function c21520203.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local ct=Duel.GetMatchingGroupCount(c21520203.desfilter,tp,LOCATION_MZONE,0,nil,ATTRIBUTE_LIGHT)
		return ct>0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,math.min(1,ct),nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local ct=Duel.GetMatchingGroupCount(c21520203.desfilter,tp,LOCATION_MZONE,0,nil,ATTRIBUTE_LIGHT)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,math.min(1,ct),0,LOCATION_MZONE)
end
function c21520203.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c21520203.desfilter,tp,LOCATION_MZONE,0,nil,ATTRIBUTE_LIGHT)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if ct>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,math.min(g:GetCount(),ct),nil)
		if Duel.Destroy(sg,REASON_EFFECT)>0 then
			local og=Duel.GetOperatedGroup()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(og:GetCount()*200)
			e:GetHandler():RegisterEffect(e1)
		end
	end
end
function c21520203.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function c21520203.checkfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c21520203.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21520203.checkfilter,1,e:GetHandler(),tp)
end
function c21520203.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520203.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21520203.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21520203.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c21520203.sumlimit)
		e1:SetLabel(g:GetFirst():GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c21520203.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
