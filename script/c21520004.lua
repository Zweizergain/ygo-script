--乱数原符-D
function c21520004.initial_effect(c)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520004,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520004.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520004.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520004,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520004.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520004.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520004.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520004.defval)
	c:RegisterEffect(e8)
	--remove
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(21520004,1))
	e9:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,21520004)
	e9:SetCondition(c21520004.condition1)
	e9:SetTarget(c21520004.target1)
	e9:SetOperation(c21520004.operation1)
	c:RegisterEffect(e9)
	--[[
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(21520004,1))
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetCategory(CATEGORY_REMOVE)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_HAND)
	e10:SetCountLimit(1,21520004)
	e10:SetCost(c21520004.cost2)
	e10:SetTarget(c21520004.target2)
	e10:SetOperation(c21520004.operation2)
	c:RegisterEffect(e10)
	--]]
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e11:SetDescription(aux.Stringid(21520004,4))
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_HAND)
	e11:SetCountLimit(1,21520004)
	e11:SetCost(c21520004.cost2)
	e11:SetTarget(c21520004.target2)
	e11:SetOperation(c21520004.operation2)
	c:RegisterEffect(e11)
end
function c21520004.MinValue(...)
	local val=...
	return val or 0
end
function c21520004.MaxValue(...)
	local val=...
	return val or 1792
end
function c21520004.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520004.MinValue()
	local tempmax=c21520004.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+1792)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520004.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520004.MinValue()
	local tempmax=c21520004.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+1792+1)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520004.condition1(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520004.MinValue()
	local tempmax=c21520004.MaxValue()
	return e:GetHandler():GetAttack()>=tempmax/2
end
function c21520004.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end
end
function c21520004.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()==0 then return end
	local rg=g:RandomSelect(tp,1)
	local tc=rg:GetFirst()
	local atk=0
	if tc:IsType(TYPE_MONSTER) then
		atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	Duel.Recover(1-tp,atk,REASON_EFFECT)
end
function c21520004.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c21520004.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,LOCATION_DECK)>=8 
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
end
function c21520004.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local g2=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
	if g1:GetCount()<4 or g2:GetCount()<4 then return end
	local rg1=g1:RandomSelect(tp,4)
	local rg2=g2:RandomSelect(1-tp,4)
	Duel.ConfirmCards(tp,rg1)
	Duel.ConfirmCards(1-tp,rg2)
	local op1=2
	local op2=2
	local smg1=nil
	local smg2=nil
	local sgg1=nil
	local sgg2=nil
	local nolimit=false
	local smg=Group.CreateGroup()
	if (Duel.IsPlayerCanSpecialSummon(tp) and rg1:FilterCount(c21520004.spfilter,nil,e,tp)>0) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) then
		op1=Duel.SelectOption(tp,aux.Stringid(21520004,2),aux.Stringid(21520004,3))
	elseif (Duel.IsPlayerCanSpecialSummon(tp) and rg1:FilterCount(c21520004.spfilter,nil,e,tp)>0) 
		and not Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520004,2))
		op1=0
	elseif Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) 
		and not (Duel.IsPlayerCanSpecialSummon(tp) and rg1:FilterCount(c21520004.spfilter,nil,e,tp)>0) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520004,3))
		op1=1
	end
	if (Duel.IsPlayerCanSpecialSummon(1-tp) and rg2:FilterCount(c21520004.spfilter,nil,e,1-tp)>0) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) then
		op2=Duel.SelectOption(1-tp,aux.Stringid(21520004,2),aux.Stringid(21520004,3))
	elseif (Duel.IsPlayerCanSpecialSummon(1-tp) and rg2:FilterCount(c21520004.spfilter,nil,e,1-tp)>0) 
		and not Duel.IsExistingMatchingCard(Card.IsAbleToGrave,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) then
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(21520004,2))
		op2=0
	elseif Duel.IsExistingMatchingCard(Card.IsAbleToGrave,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) 
		and not (Duel.IsPlayerCanSpecialSummon(1-tp) and rg2:FilterCount(c21520004.spfilter,nil,e,1-tp)>0) then
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(21520004,3))
		op2=1
	end
	if op1==0 and op2==0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		smg1=rg1:FilterSelect(tp,c21520004.spfilter,1,1,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		smg2=rg2:FilterSelect(1-tp,c21520004.spfilter,1,1,nil,e,1-tp)
		smg:Merge(smg1)
		smg:Merge(smg2)
		local tc=smg:GetFirst()
		while tc do
			if tc:IsSetCard(0x493) then nolimit=true end
			Duel.SpecialSummonStep(tc,0,tc:GetControler(),tc:GetControler(),false,nolimit,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
			nolimit=false
			tc=smg:GetNext()
		end
	elseif op1==1 and op2==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		sgg1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(sgg1,REASON_RULE)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		smg2=rg2:FilterSelect(1-tp,c21520004.spfilter,1,1,nil,e,1-tp):GetFirst()
		if smg2:IsSetCard(0x493) then nolimit=true end
		Duel.SpecialSummonStep(smg2,0,1-tp,1-tp,false,nolimit,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		smg2:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		smg2:RegisterEffect(e2,true)
	elseif op1==0 and op2==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		smg1=rg1:FilterSelect(tp,c21520004.spfilter,1,1,nil,e,tp):GetFirst()
		if smg1:IsSetCard(0x493) then nolimit=true end
		Duel.SpecialSummonStep(smg1,0,tp,tp,false,nolimit,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		smg1:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		smg1:RegisterEffect(e2,true)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		sgg2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(sgg2,REASON_RULE)
	elseif op1==1 and op2==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		sgg1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(sgg1,REASON_RULE)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		sgg2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(sgg2,REASON_RULE)
	end
	Duel.SpecialSummonComplete()
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
end
function c21520004.spfilter(c,e,tp)
	if c:IsSetCard(0x493) then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,true) and c:IsType(TYPE_MONSTER)
	else
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
	end
end
--[[
function c21520004.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c21520004.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	local rg=g:RandomSelect(tp,1)
	local tc=rg:GetFirst()
	e:SetLabelObject(tc)
	Duel.SetTargetCard(rg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
end
function c21520004.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsType(TYPE_MONSTER) then
		if not tc:IsLocation(LOCATION_GRAVE) then return end
		local ct=0
		if tc:IsType(TYPE_XYZ) then
			ct=0
		else
			ct=tc:GetLevel()
		end
		local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
		if ct>sg:GetCount() then ct=sg:GetCount() end
		local rmg=sg:RandomSelect(tp,ct)
		if Duel.Remove(rmg,POS_FACEUP,REASON_EFFECT) then
			local rec=rmg:GetFirst()
			local recover=0
			while rec do
				local atk=rec:GetTextAttack()
				if atk<0 then atk=0 end
				recover=recover+atk
				rec=rmg:GetNext()
			end
			local lp=Duel.GetLP(1-tp)+recover
			Duel.SetLP(1-tp,lp)
		end
	end
end
function c21520004.dfilter(c,tp)
	return c:GetOwner()==tp
end
--]]