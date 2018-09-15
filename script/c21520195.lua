--急流精怪-续航型
function c21520195.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c21520195.spcon)
	e1:SetOperation(c21520195.spop)
	c:RegisterEffect(e1)
	--synchro lv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(c21520195.lvval)
	c:RegisterEffect(e2)
	--back
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520195,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c21520195.thcon)
	e3:SetTarget(c21520195.thtg)
	e3:SetOperation(c21520195.thop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(21520195,ACTIVITY_SUMMON,c21520195.counterfilter)
	Duel.AddCustomActivityCounter(21520195,ACTIVITY_FLIPSUMMON,c21520195.counterfilter)
	Duel.AddCustomActivityCounter(21520195,ACTIVITY_SPSUMMON,c21520195.counterfilter)
end
function c21520195.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c21520195.spfilter(c)
	return not c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c21520195.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	if Duel.GetCustomActivityCount(21520195,tp,ACTIVITY_SUMMON)~=0 
		and Duel.GetCustomActivityCount(21520195,tp,ACTIVITY_FLIPSUMMON)~=0 
		and Duel.GetCustomActivityCount(21520195,tp,ACTIVITY_SPSUMMON)~=0 
		then return false end
	return not Duel.IsExistingMatchingCard(c21520195.spfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and not Duel.IsExistingMatchingCard(Card.IsType,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP)
end
function c21520195.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local code=e:GetHandler():GetCode()
	local ct=Duel.GetFlagEffect(tp,code)
	Duel.RegisterFlagEffect(tp,code,RESET_PHASE+PHASE_END,0,1)
	Duel.Damage(tp,100*2^ct,REASON_RULE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c21520195.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c21520195.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c21520195.lvval(e,c)
	local lv=e:GetHandler():GetLevel()
	if not c:IsAttribute(ATTRIBUTE_WATER) then return lv
	else
		return 3*65536+lv
	end
end
function c21520195.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local fg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()==fg:GetCount() and g:GetCount()==fg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)
end
function c21520195.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x496)
end
function c21520195.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c21520195.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	local ct=Duel.GetMatchingGroupCount(c21520195.thfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 and ct>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local thg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(thg)
		thg:KeepAlive()
		if Duel.Remove(thg,POS_FACEUP,REASON_EFFECT)>0 then
			local tc=thg:GetFirst()
			while tc do
				tc:RegisterFlagEffect(21520195,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				tc=thg:GetNext()
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_REMOVED)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabelObject(thg)
			e1:SetCondition(c21520195.rthcon)
			e1:SetOperation(c21520195.rthop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c21520195.rthfilter(c)
	return c:GetFlagEffect(21520195)~=0
end
function c21520195.rthcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c21520195.rthfilter,1,nil) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c21520195.rthop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c21520195.rthfilter,nil)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
