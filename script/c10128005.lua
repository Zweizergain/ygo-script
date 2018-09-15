--奇妙物语 红烧南瓜
function c10128005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,10128005)
	e1:SetTarget(c10128005.target)
	e1:SetOperation(c10128005.activate)
	c:RegisterEffect(e1)  
	--pos change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10128005.poscon)
	e2:SetTarget(c10128005.postg)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e2)   
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10128005,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10128105)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c10128005.setcost)
	e3:SetTarget(c10128005.settg)
	e3:SetOperation(c10128005.setop)
	c:RegisterEffect(e3)
end
function c10128005.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c10128005.setfilter(c)
	return bit.band(c:GetType(),0x10002)==0x10002 and c:IsSSetable()
end
function c10128005.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10128005.setfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
end
function c10128005.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10128005.setfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local tc=g:RandomSelect(tp,1):GetFirst()
		if tc:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0) then
			Duel.NegateEffect(0)
			return
		end
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c10128005.postg(e,c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL 
		and bit.band(c:GetSummonLocation(),LOCATION_EXTRA)~=0
end
function c10128005.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_EFFECT)
end
function c10128005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10128005,0x6336,0x21,1000,2000,4,RACE_PYRO,ATTRIBUTE_FIRE) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10128005.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,10128005,0x6336,0x21,1000,2000,4,RACE_PYRO,ATTRIBUTE_FIRE) 
	then return end
		--c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		--c:RegisterEffect(e1,true)
		--Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	c:AddMonsterAttribute(TYPE_EFFECT)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	c:AddMonsterAttributeComplete()
	Duel.SpecialSummonComplete()
end