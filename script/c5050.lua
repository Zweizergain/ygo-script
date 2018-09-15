--娘化世界
function c5050.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5050,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,5050)
	e2:SetTarget(c5050.drtg)
	e2:SetOperation(c5050.drop)
	c:RegisterEffect(e2)
	--zsw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(c5050.ctop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	 --destroy
	--local e5=Effect.CreateEffect(c)
	--e5:SetCategory(CATEGORY_DESTROY)
	--e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	--e5:SetRange(LOCATION_FZONE)
	--e5:SetCode(5050)
	--e5:SetTarget(c5050.destg)
	--e5:SetOperation(c5050.desop)
	--c:RegisterEffect(e5)
	--remove
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c5050.recon)
	e6:SetTarget(c5050.retg)
	e6:SetOperation(c5050.reop)
	c:RegisterEffect(e6)
	--tohand
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_PREDRAW)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCondition(c5050.thcon)
	e7:SetTarget(c5050.thtg)
	e7:SetOperation(c5050.thop)
	c:RegisterEffect(e7)
end
function c5050.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c5050.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
	local g=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-p,g)
	if not g:IsSetCard(0x900) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(p,Card.IsAbleToGrave,p,LOCATION_HAND,0,1,1,nil)
	 if sg:GetCount()>0 then
	 Duel.SendtoGrave(sg,REASON_EFFECT)
	 end
	end
	Duel.ShuffleHand(p)   
end
end
function c5050.cfilter(c)
	return c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER)
end
function c5050.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c5050.cfilter,1,nil) then
		e:GetHandler():AddCounter(0x16,1)
	end
end
function c5050.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_FZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),1-tp,0)
end
function c5050.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldCard(1,LOCATION_SZONE,5)  
	if sg and sg:IsDestructable() and Duel.Destroy(sg,REASON_EFFECT)>0 then 
	Duel.BreakEffect()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c5050.filter)
	e:GetHandler():RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c5050.sfilter)
	e:GetHandler():RegisterEffect(e2)
	end
end
function c5050.filter(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c5050.sfilter(e,c,tp)
	return c:IsType(TYPE_FIELD) and Duel.GetFieldCard(tp,LOCATION_SZONE,5)~=nil
end
function c5050.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x16)
	e:SetLabel(ct)
	return rp~=tp and ct>0 and c:GetPreviousControler()==tp and c:IsReason(REASON_DESTROY)
end
function c5050.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabel()
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,g,nil)  
	and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,g,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,PLAYER_ALL,g)
end
function c5050.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,ct,ct,nil)
		local g2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,ct,ct,nil)
		g1:Merge(g2)
		if g1:GetCount()>0 then
			Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		end
end
function c5050.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c5050.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c5050.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	_replace_count=_replace_count+1
	if _replace_count<=_replace_max and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end