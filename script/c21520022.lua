--乱数终点
function c21520022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520022,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21520022)
	e1:SetCost(c21520022.cost)
	e1:SetTarget(c21520022.target)
	e1:SetOperation(c21520022.operation)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520022,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21520022)
	e2:SetCost(c21520022.gacost)
	e2:SetTarget(c21520022.gatg)
	e2:SetOperation(c21520022.gaop)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c21520022.handcon)
	c:RegisterEffect(e3)
end
function c21520022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c21520022.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c21520022.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return e:GetLabelObject()~=se
end
function c21520022.spfilter(c,e,tp)
	if c:IsSetCard(0x493) then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,true,POS_FACEUP_ATTACK,tp)
	else
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp)
	end
end
function c21520022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c21520022.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,Duel.GetLocationCount(tp,LOCATION_MZONE),tp,LOCATION_GRAVE)
end
function c21520022.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=Duel.GetMatchingGroup(c21520022.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=sg:Select(tp,ft,ft,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,true,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EFFECT_SET_ATTACK)
		e3:SetValue(3200)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e4:SetCondition(c21520022.rdcon)
		e4:SetOperation(c21520022.rdop)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4,true)
		--not randomly
		if not tc:IsSetCard(0x493) then
			if tc:IsType(TYPE_XYZ) then 
				sum=sum+tc:GetOriginalRank()
			else
				sum=sum+tc:GetOriginalLevel()
			end
		end
		tc=g:GetNext()
	end
	--not randomly
	if sum>0 and not Duel.IsExistingMatchingCard(c21520022.chkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		Duel.BreakEffect()
		Duel.Damage(tp,sum*500,REASON_RULE)
	end
	Duel.SpecialSummonComplete()
end
function c21520022.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsType(TYPE_FIELD)
end
function c21520022.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c21520022.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c21520022.cfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function c21520022.gacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520022.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520022.cfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c21520022.spsfilter(c,e,tp)
	return c:IsSetCard(0x5493) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c21520022.gatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	local op=0
	if ct>=20 and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c21520022.spsfilter,tp,LOCATION_DECK,0,1,nil,e,tp)) 
		and e:GetHandler():IsAbleToHand() and e:GetHandler():IsAbleToDeck() then
		op=Duel.SelectOption(tp,aux.Stringid(21520022,2),aux.Stringid(21520022,3),aux.Stringid(21520022,4))
	elseif ct>=10 and e:GetHandler():IsAbleToHand() and e:GetHandler():IsAbleToDeck() then
		op=Duel.SelectOption(tp,aux.Stringid(21520022,2),aux.Stringid(21520022,3))
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520022,2))
	end
	if op==0 then Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,LOCATION_GRAVE) 
	elseif op==1 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE) 
	elseif op==2 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,Duel.GetLocationCount(tp,LOCATION_MZONE)>0,tp,LOCATION_DECK) end
	e:SetLabel(op)
end
function c21520022.gaop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not e:GetHandler():IsLocation(LOCATION_GRAVE) then return end
	local op=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if op==0 and e:GetHandler():IsAbleToDeck() then 
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	elseif op==1 and e:GetHandler():IsAbleToHand() then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	elseif op==2 and (ft>0 and Duel.IsExistingMatchingCard(c21520022.spsfilter,tp,LOCATION_DECK,0,1,nil,e,tp)) then
		local sg=Duel.GetMatchingGroup(c21520022.spsfilter,tp,LOCATION_DECK,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=c21520022.group_unique_code(sg):Select(tp,ft,ft,nil)
		if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,true,POS_FACEUP) end
	end
end
function c21520022.group_unique_code(g)
	local check={}
	local tg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		for i,code in ipairs({tc:GetCode()}) do
			if not check[code] then
				check[code]=true
				tg:AddCard(tc)
			end
		end
		tc=g:GetNext()
	end
	return tg
end
function c21520022.hafilter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c21520022.handcon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c21520022.hafilter,tp,LOCATION_ONFIELD,0,1,nil)
end
