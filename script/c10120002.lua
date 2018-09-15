--天选圣女 圣盔葛琳洁德
function c10120002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10120002)
	e1:SetCondition(c10120002.spcon)
	c:RegisterEffect(e1)	  
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(10120002,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetOperation(c10120002.dsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10120002,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c10120002.sptg)
	e4:SetOperation(c10120002.spop)
	c:RegisterEffect(e4)
		--dissummon
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON)
		ge1:SetOperation(c10120002.snop)
		ge1:SetLabelObject(e4)
		Duel.RegisterEffect(ge1,0) 
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON_SUCCESS) 
		ge2:SetOperation(c10120002.ssop)
		ge2:SetLabelObject(e4)
		Duel.RegisterEffect(ge2,0) 
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON)
		ge3:SetLabelObject(e4)
		Duel.RegisterEffect(ge3,0) 
		local ge4=ge2:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge4:SetLabelObject(e4)
		Duel.RegisterEffect(ge4,0) 

end

function c10120002.spfilter2(c,e,tp)
	return c:IsSetCard(0x9331) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end

function c10120002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then 
		if e:GetHandler():GetFlagEffect(10120002)==0 then return false end  
		   e:GetHandler():ResetFlagEffect(10120002)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10120002.spfilter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,e:GetHandler(),e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end

function c10120002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10120002.spfilter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,e:GetHandler(),e,tp)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c10120002.snop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsContains(e:GetOwner()) then
	e:GetOwner():RegisterFlagEffect(10120002,RESET_EVENT+RESET_OVERLAY+0x01020000,0,0)
   end
end

function c10120002.ssop(e,tp,eg,ep,ev,re,r,rp)
   if eg:IsContains(e:GetOwner()) then
	e:GetOwner():ResetFlagEffect(10120002)
   end
end

function c10120002.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		--dissummon
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(10120002,2))
		e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_SUMMON)
		e1:SetCountLimit(1+EFFECT_COUNT_CODE_SINGLE)
		e1:SetCondition(c10120002.discon)
		e1:SetTarget(c10120002.distg)
		e1:SetOperation(c10120002.disop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1) 
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON)
		c:RegisterEffect(e2) 
end

function c10120002.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==ep and Duel.GetCurrentChain()==0
end

function c10120002.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c10120002.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end

function c10120002.spfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_FAIRY)
end

function c10120002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and not Duel.IsExistingMatchingCard(c10120002.spfilter,tp,LOCATION_MZONE,0,1,nil)
end