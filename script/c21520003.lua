--乱数原符-N
function c21520003.initial_effect(c)
	--change attack & defence
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520003,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(c21520003.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetOperation(c21520003.defval)
	c:RegisterEffect(e2)
	--summons
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520003,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetOperation(c21520003.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetOperation(c21520003.defval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetOperation(c21520003.defval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetOperation(c21520003.defval)
	c:RegisterEffect(e8)
	--special summon
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(21520003,1))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,21520003)
	e9:SetCondition(c21520003.con)
	e9:SetTarget(c21520003.tg)
	e9:SetOperation(c21520003.op)
	c:RegisterEffect(e9)
	--special summon from deck
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(21520003,2))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_HAND)
	e10:SetCountLimit(1,21520003)
	e10:SetCost(c21520003.cost)
	e10:SetTarget(c21520003.target)
	e10:SetOperation(c21520003.operation)
	c:RegisterEffect(e10)
end
function c21520003.MinValue(...)
	local val=...
	return val or 0
end
function c21520003.MaxValue(...)
	local val=...
	return val or 1344
end
function c21520003.atkval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520003.MinValue()
	local tempmax=c21520003.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+1344)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520003.defval(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520003.MinValue()
	local tempmax=c21520003.MaxValue()
	local c=e:GetHandler()
	math.randomseed(c:GetFieldID()+Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetTurnCount()+1344+1)
	local val=math.random(tempmin,tempmax)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0xdfc0000)
	c:RegisterEffect(e1)
end
function c21520003.con(e,tp,eg,ep,ev,re,r,rp)
	local tempmin=c21520003.MinValue()
	local tempmax=c21520003.MaxValue()
	return e:GetHandler():GetAttack()>=tempmax/2
end
function c21520003.sfilter(c,e,tp)
	if c:IsSetCard(0x493) then
		return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
	else
		return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
end
function c21520003.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c21520003.sfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c21520003.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520003.sfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(tp,1)
	local tc=sg:GetFirst()
	Duel.SetTargetCard(tc)
	if Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)>0 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
	end
end
function c21520003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() 
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c21520003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21520003.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21520003.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c21520003.sfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if not g or g:GetCount()<=0 then return end
	local rg=g:RandomSelect(tp,1)
	if rg:GetCount()==1 then
		Duel.SpecialSummonStep(rg:GetFirst(),0,tp,tp,false,true,POS_FACEUP)
		if not rg:GetFirst():IsSetCard(0x493) and not Duel.IsExistingMatchingCard(c21520003.chkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
			local sum=rg:GetFirst():GetOriginalLevel()
			Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
			Duel.BreakEffect()
			Duel.Damage(tp,sum*500,REASON_RULE)
		end
		Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		local hg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
		Duel.Remove(hg,POS_FACEUP,REASON_EFFECT)
	end
end
function c21520003.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x493) and c:IsType(TYPE_FIELD)
end
