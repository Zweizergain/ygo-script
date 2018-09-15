--猛毒性 Ah·Re·Dos
function c24762457.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,24762457)
	e2:SetTarget(c24762457.e2tg)
	e2:SetCost(c24762457.e2cost)
	e2:SetOperation(c24762457.e2op)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,24762458)
	e5:SetCost(c24762457.e5cost)
	e5:SetTarget(c24762457.e5tg)
	e5:SetOperation(c24762457.e5op)
	c:RegisterEffect(e5)
end
function c24762457.e5costfil(c)
	return c:IsSetCard(0x1390) and c:IsFaceup() and c:IsReleasable()
end
function c24762457.e5cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c24762457.e5costfil,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c24762457.e5costfil,tp,LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local bb=g:GetFirst()
		local bb1=Duel.GetMatchingGroupCount(c24762457.bbfil,tp,  LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,tp,bb)
		if bb1~=0 then
			Duel.Release(tc,REASON_COST)
			if tc:GetPreviousEquipTarget():IsCode(24762458) then
				e:SetLabel(1)
			else e:SetLabel(0)
			end
		else 
			Duel.Release(tc,REASON_COST)
			e:SetLabel(0)
		end
	end
end
function c24762457.bbfil(c,e,tp,bb)
	return c:GetEquipGroup():IsContains(bb)
end
function c24762457.e5opfil(c)
	return c:IsCode(24762457) and c:IsAbleToHand()
end
function c24762457.e5opfil2(c)
	return c:IsSetCard(0x1390) and c:IsAbleToGrave()
end
function c24762457.e5tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24762457.e5opfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c24762457.e5op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c24762457.e5opfil,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if e:GetLabel()==1 then
			local g2=Duel.GetMatchingGroup(c24762457.e5opfil2,tp,LOCATION_DECK,0,nil)
			if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(24762457,4)) then 
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,c24762457.e5opfil2,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoGrave(g,REASON_EFFECT)
				end
			end
		end
	end
end
function c24762457.e2tgfil(c)
	return c:IsFaceup()
end
function c24762457.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c24762457.e2tgfil,tp,0,LOCATION_MZONE,1,nil) end
end
function c24762457.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 and Duel.IsExistingMatchingCard(c24762457.e2tgfil,tp,0,LOCATION_MZONE,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(24762457,0))
	local g=Duel.SelectMatchingCard(tp,c24762457.e2tgfil,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
		if Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and not tc:IsType(TYPE_PENDULUM) then
			if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
			local e10=Effect.CreateEffect(c)
			e10:SetDescription(aux.Stringid(24762457,1))
			e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e10:SetType(EFFECT_TYPE_SINGLE)
			e10:SetReset(RESET_EVENT+0x1fc0000)
			e10:SetCode(EFFECT_CHANGE_TYPE)
			e10:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e10)
			Duel.RaiseEvent(tc,EVENT_CUSTOM+47408488,e,0,tp,0,0)
			local e9=Effect.CreateEffect(c)
			e9:SetDescription(aux.Stringid(24762457,2))
			e9:SetType(EFFECT_TYPE_SINGLE)
			e9:SetCode(EFFECT_ADD_CODE)
			e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e9:SetValue(24562464)
			e9:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e9)
			else
			Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			local e8=Effect.CreateEffect(c)
			e8:SetDescription(aux.Stringid(24762457,1))
			e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetReset(RESET_EVENT+0x1fc0000)
			e8:SetCode(EFFECT_CHANGE_TYPE)
			e8:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			c:RegisterEffect(e8)
			Duel.RaiseEvent(c,EVENT_CUSTOM+47408488,e,0,tp,0,0)
			local e5=Effect.CreateEffect(c)
			e5:SetDescription(aux.Stringid(24762457,3))
			e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e5:SetType(EFFECT_TYPE_FIELD)
			e5:SetCode(EFFECT_SET_BASE_ATTACK)
			e5:SetRange(LOCATION_ONFIELD)
			e5:SetReset(RESET_EVENT+0x1fe0000)
			e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e5:SetTarget(c24762457.atktarget)
			e5:SetValue(0)
			c:RegisterEffect(e5,true)
			end
		else
		Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		local e7=Effect.CreateEffect(c)
		e7:SetDescription(aux.Stringid(24762457,1))
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetReset(RESET_EVENT+0x1fc0000)
		e7:SetCode(EFFECT_CHANGE_TYPE)
		e7:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e7)
		Duel.RaiseEvent(c,EVENT_CUSTOM+47408488,e,0,tp,0,0)
		local e6=Effect.CreateEffect(c)
		e6:SetDescription(aux.Stringid(24762457,3))
		e6:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_SET_BASE_ATTACK)
		e6:SetRange(LOCATION_ONFIELD)
		e6:SetReset(RESET_EVENT+0x1fe0000)
		e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e6:SetTarget(c24762457.atktarget)
		e6:SetValue(0)
		c:RegisterEffect(e6,true)
		end
end
function c24762457.atktarget(e,c)
	local gp=e:GetHandler():GetControler()
	local g=e:GetHandler():GetColumnGroup()
	return c:IsControler(gp) and g:IsContains(c)
end
function c24762457.e1cfil(c)
	return c:IsSetCard(0x1390) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION) and c:IsReleasable()
end
function c24762457.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24762457.e1cfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c24762457.e1cfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.Release(g,REASON_COST)
end