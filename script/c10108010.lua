--糖果派 mlgdd
function c10108010.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10108010,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10108010.drcon1)
	e1:SetCost(c10108010.drcost)
	e1:SetTarget(c10108010.drtg)
	e1:SetOperation(c10108010.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c10108010.drcon2)
	c:RegisterEffect(e2)
	--effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10108010,1))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c10108010.eftg)
	e3:SetOperation(c10108010.efop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	c10108010[c]=e3  
end
function c10108010.tgfilter(c)
	return c:IsSetCard(0x9338) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c10108010.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c10108010.tgfilter,tp,LOCATION_DECK,0,1,nil) then sel=sel+1 end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,10108009,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		sel=Duel.SelectOption(tp,aux.Stringid(10108010,2),aux.Stringid(10108010,3))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(10108010,2))
	else
		Duel.SelectOption(tp,aux.Stringid(10108010,3))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	else
		e:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end
end
function c10108010.efop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	   local g=Duel.SelectMatchingCard(tp,c10108010.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	   if g:GetCount()>0 then
		  Duel.SendtoGrave(g,REASON_EFFECT)
	   end
	else
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	   local token=Duel.CreateToken(tp,10108009)
	   if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_ADD_TYPE)
		  e1:SetReset(RESET_EVENT+0x1fe0000)
		  e1:SetValue(TYPE_TUNER)
		  token:RegisterEffect(e1)
		end
	end
end
function c10108010.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10108010.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c10108010.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c10108010.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c10108010.cfilter(c)
	return c:IsCode(10108008) and c:IsFaceup()
end
function c10108010.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c10108010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c10108010.sumfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10108010.sumfilter(c)
	return c:IsSetCard(0x9338) and c:IsSummonable(true,nil)
end
function c10108010.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	   local g=Duel.SelectMatchingCard(tp,c10108010.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
			 if g:GetCount()>0 then
				Duel.Summon(tp,g:GetFirst(),true,nil)
			 end
	end
end