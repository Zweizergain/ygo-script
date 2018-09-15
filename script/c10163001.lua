--虚太古龙·虚妄神
function c10163001.initial_effect(c)
	c:SetSPSummonOnce(10163001)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c10163001.spcon)
	e2:SetOperation(c10163001.spop)
	c:RegisterEffect(e2)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10163001,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e3:SetCountLimit(1,10163001)
	e3:SetCost(c10163001.damcost)
	e3:SetTarget(c10163001.damtg)
	e3:SetOperation(c10163001.damop)
	c:RegisterEffect(e3)  
end
function c10163001.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_DRAGON+RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10163001.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10163001.spfilter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c10163001.damop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10163001.spfilter,tp,0x13,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and tc:IsHasEffect(EFFECT_NECRO_VALLEY) then return end
	if tc and Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
function c10163001.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c10163001.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	   local t={}
	   local p=1
	   for i=4,9 do 
		  if Duel.IsPlayerCanSpecialSummonMonster(tp,10163007,0x9333,0x4011,0,3000,i,RACE_DRAGON,ATTRIBUTE_EARTH)
		  then t[p]=i p=p+1 
		  end
	   end
	   t[p]=nil
	return t[1]
	end
	local t={}
	local p=1
	for i=4,9 do 
		if Duel.IsPlayerCanSpecialSummonMonster(tp,10163007,0x9333,0x4011,0,3000,i,RACE_DRAGON,ATTRIBUTE_DARK)
		then t[p]=i p=p+1 
		end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end

function c10163001.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,10163007,0x9333,0x4011,0,3000,e:GetLabel(),RACE_DRAGON,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,10163007)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_CHANGE_LEVEL)
	   e1:SetValue(e:GetLabel())
	   e1:SetReset(RESET_EVENT+0xfe0000)
	   token:RegisterEffect(e1)
	   Duel.BreakEffect()
	   Duel.Damage(1-tp,200,REASON_EFFECT)
	end
end
function c10163001.cfilter(c)
	return c:IsLevelAbove(8) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c10163001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetReleaseGroup(tp,true):Filter(c10163001.cfilter,c)
	return g:GetCount()>=2 and ft>-2 and g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>-ft
end
function c10163001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local g=Duel.GetReleaseGroup(tp,true):Filter(c10163001.cfilter,c)
	local sg=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		sg=g:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<2 then
			g:Sub(sg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local sg1=g:Select(tp,2-ct,2-ct,nil)
			sg:Merge(sg1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		sg=g:Select(tp,2,2,nil)
	end
	Duel.SendtoGrave(sg,REASON_COST)
end