--神之国度 阿斯加德
function c10120010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10120010,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCountLimit(2,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c10120010.netg)
	e2:SetOperation(c10120010.neop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e4)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10120010,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetHintTiming(TIMING_END_PHASE)
	e3:SetTarget(c10120010.sptg)
	e3:SetOperation(c10120010.spop)
	c:RegisterEffect(e3)
	--level
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_LEVEL)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9331))
	e5:SetValue(-1)
	c:RegisterEffect(e5) 
	if c10120010.counter==nil then
		c10120010.counter=true
	   c10120010[0]=0
	   c10120010[1]=0
		--dissummon
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON)
		ge1:SetOperation(c10120010.snop)
		Duel.RegisterEffect(ge1,0) 
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON)
		Duel.RegisterEffect(ge3,0) 
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge5:SetOperation(c10120010.resetcount)
		Duel.RegisterEffect(ge5,0) 
	end
end

function c10120010.filter(c,e,tp)
	return c:IsSetCard(0x9331) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10120010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return c10120010[tp]>=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10120010.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end

function c10120010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10120010.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c10120010.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c10120010[0]=0
	c10120010[1]=0
end

function c10120010.snop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsExists(c10120010.sfilter,1,nil) then
		c10120010[rp]=c10120010[rp]+1
		local tg=eg:Filter(c10120010.sfilter,nil)
		tg:KeepAlive()
		--c11200009[2]:Clear() 
		--c11200009[2]:Merge(tg)
		local ge2=Effect.CreateEffect(e:GetHandler())
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON_SUCCESS) 
		ge2:SetOperation(c10120010.ssop)
		Duel.RegisterEffect(ge2,0) 
		ge2:SetLabelObject(tg)
		local ge4=ge2:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge4,0) 
		ge4:SetLabelObject(tg)
		local tc=tg:GetFirst()
		while tc do
		  tc:RegisterFlagEffect(10120010,RESET_EVENT+RESET_OVERLAY+0x01020000+RESET_PHASE+PHASE_END,0,0)
		  tc=tg:GetNext()
		end
   end
end

function c10120010.ssop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsExists(c10120010.sfilter,1,nil) then
	  --Duel.RaiseEvent(e:GetHandler(),11200009,e,0,rp,0,0)
	 local tg=eg:Filter(c10120010.sfilter2,nil)
	 if e:GetLabelObject():Equal(tg) then
		c10120010[rp]=c10120010[rp]-1
	   if c10120010[rp]<0 then c10120010[rp]=0 end
	 end
   end
   e:Reset() 
end

function c10120010.sfilter(c)
	return c:IsSetCard(0x9331) and c:IsFaceup()
end

function c10120010.sfilter2(c)
	return c:IsSetCard(0x9331) and c:IsFaceup() and c:GetFlagEffect(10120010)~=0
end

function c10120010.spfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp
		and c:IsSetCard(0x9331) 
end

function c10120010.spfilter2(c,e,tp,tg)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x9331) and not tg:IsExists(Card.IsCode,1,nil,c:GetCode())
end

function c10120010.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	local tg=eg:Filter(c10120010.spfilter,nil,tp)
		 if tg:GetCount()<=0 then return false end
	return Duel.IsExistingMatchingCard(c10120010.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,tg) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=0 and Duel.GetCurrentChain()==0
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end

function c10120010.neop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.NegateSummon(eg)
	 Duel.Destroy(eg,REASON_EFFECT)
	 local tg=eg:Filter(c10120010.spfilter,nil,tp)
	 local sg=Duel.GetMatchingGroup(c10120010.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp,tg)
	 if sg:GetCount()>0 then
	   Duel.BreakEffect()
	   local g=sg:Select(tp,1,1,nil)
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	 end
end
