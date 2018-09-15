--☯知识与避世的少女☯
--require "nef/thcz"
function c60401.initial_effect(c)
	--Thcz.TheSynchroSummonOfPaysageONLY(c,Thcz.Tfilter,c60401.cfilter,true,nil)
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x813),1)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60401,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_SPSUMMON,TIMING_BATTLE_START)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()~=tp
	end)
	e1:SetCountLimit(1,60401)
	e1:SetTarget(c60401.target)
	e1:SetOperation(c60401.operation)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60401,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return c:GetSummonType()==SUMMON_TYPE_SYNCHRO
	end)
	e3:SetOperation(c60401.regop)
	c:RegisterEffect(e3)
	--atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c60401.adval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
end
function c60401.cfilter(c)
	return c:IsSetCard(0x813) and not c:IsType(TYPE_TUNER)
end
function c60401.adval(e,c)
	return Duel.GetMatchingGroupCount(c60401.filter6,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*200
end
function c60401.filter6(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c60401.filter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c60401.tg2(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chk==0 then 
		local c=e:GetHandler()
		local ct=c:GetMaterialCount()-1
		return ct>0 and Duel.IsExistingMatchingCard(c60401.filter,tp,LOCATION_DECK,0,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK)
end
function c60401.regop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
	local ct=c:GetMaterialCount()-1
	if Duel.IsExistingMatchingCard(c60401.filter,tp,LOCATION_DECK,0,ct,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c60401.filter,tp,LOCATION_DECK,0,ct,ct,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60401.target(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chk==0 then 
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tg=g:GetMaxGroup(Card.GetAttack)
		return  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>=tg:GetCount() end
end
function c60401.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		local tc=tg:GetFirst()
		while tc do
			if Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 then  
				Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fc0000)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			else
				Duel.SendtoGrave(tc,REASON_RULE)
			end 
			tc=tg:GetNext()
		end 
	end 
end
