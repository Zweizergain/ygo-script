--天选圣女 神圣之布伦希尔德
function c10120009.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x9331),3,true)
	c:SetUniqueOnField(1,0,10120009)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetDescription(aux.Stringid(10120009,0))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10120009.spcon)
	e2:SetOperation(c10120009.spop)
	c:RegisterEffect(e2)
	--special summon rule2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10120009,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c10120009.spcon2)
	c:RegisterEffect(e3)
	if c10120009.counter==nil then
		c10120009.counter=true
		c10120009[0]=0
		c10120009[1]=0
		--dissummon
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON)
		ge1:SetOperation(c10120009.snop)
		Duel.RegisterEffect(ge1,0) 
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON)
		Duel.RegisterEffect(ge3,0) 
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge5:SetOperation(c10120009.resetcount)
		Duel.RegisterEffect(ge5,0) 
	end
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c10120009.efilter)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(10120009)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c10120009.atkop)
	--c:RegisterEffect(e5)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(c10120009.drop)
	--c:RegisterEffect(e6)
end

function c10120009.drop(e,tp,eg,ep,ev,re,r,rp)
	  Duel.Hint(HINT_CARD,0,10120009)
	  Duel.Draw(tp,1,REASON_EFFECT)
end

function c10120009.drfilter(c,tp)
	return c:IsSetCard(0x9331) 
end

function c10120009.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if tp==rp then
	  Duel.Hint(HINT_CARD,0,10120009)
	  local e1=Effect.CreateEffect(c)
	  e1:SetType(EFFECT_TYPE_SINGLE)
	  e1:SetCode(EFFECT_UPDATE_ATTACK)
	  e1:SetValue(200)
	  e1:SetReset(RESET_EVENT+0x1ff0000)
	  c:RegisterEffect(e1)
	end
end

function c10120009.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c10120009.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c10120009[0]=0
	c10120009[1]=0
end

function c10120009.snop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsExists(c10120009.sfilter,1,nil) then
		c10120009[rp]=c10120009[rp]+1
		local tg=eg:Filter(c10120009.sfilter,nil)
		tg:KeepAlive()
		--c10120009[2]:Clear() 
		--c10120009[2]:Merge(tg)
		local ge2=Effect.CreateEffect(e:GetHandler())
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON_SUCCESS) 
		ge2:SetOperation(c10120009.ssop)
		Duel.RegisterEffect(ge2,0) 
		ge2:SetLabelObject(tg)
		local ge4=ge2:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge4,0) 
		ge4:SetLabelObject(tg)
		local tc=tg:GetFirst()
		while tc do
		  tc:RegisterFlagEffect(10120009,RESET_EVENT+RESET_OVERLAY+0x00102000+RESET_PHASE+PHASE_END,0,0)
		  tc=tg:GetNext()
		end
   end
end

function c10120009.ssop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsExists(c10120009.sfilter,1,nil) then
	  --Duel.RaiseEvent(e:GetHandler(),10120009,e,0,rp,0,0)
	 local tg=eg:Filter(c10120009.sfilter2,nil)
	 if e:GetLabelObject():Equal(tg) then
		c10120009[rp]=c10120009[rp]-1
	   if c10120009[rp]<0 then c10120009[rp]=0 end
	 end
   end
   e:Reset() 
end

function c10120009.sfilter(c)
	return c:IsSetCard(0x9331) and c:IsFaceup()
end

function c10120009.sfilter2(c)
	return c:IsSetCard(0x9331) and c:IsFaceup() and c:GetFlagEffect(10120009)~=0
end

function c10120009.spfilter(c,fc)
	return c:IsFusionSetCard(0x9331) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
end

function c10120009.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c10120009[tp]>=3
end

function c10120009.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c10120009.spfilter,tp,LOCATION_MZONE,0,3,nil,c)
end

function c10120009.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10120009.spfilter,tp,LOCATION_MZONE,0,3,3,nil,c)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end