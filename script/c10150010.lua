--真究极完全态大飞蛾
function c10150010.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c10150010.spcon)
	e1:SetOperation(c10150010.spop)
	c:RegisterEffect(e1)   
	--turn count
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150010,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c10150010.cost)
	e2:SetTarget(c10150010.target)
	e2:SetOperation(c10150010.operation)
	c:RegisterEffect(e2) 
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c10150010.efilter)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10150010,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c10150010.sptg2)
	e4:SetOperation(c10150010.spop2)
	c:RegisterEffect(e4)
end

function c10150010.filter(c,e,tp)
	return c:IsCode(48579379) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end

function c10150010.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10150010.filter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end

function c10150010.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10150010.filter,tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end

function c10150010.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function c10150010.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local an=e:GetLabel()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end 
	--local turne=tc[tc]
	--local op=turne:GetOperation()
	--local n=1
	--while n<=an do
	 --op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
	 --n=n+1
	 tc:SetTurnCounter(tc:GetTurnCounter()+an)
	--end
end

function c10150010.filter(c)
	return c:IsCode(40024595) and c:IsFaceup() and c:GetEquipTarget()~=nil
end

function c10150010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c10150010.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10150010.filter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10150010,3))
	local g=Duel.SelectTarget(tp,c10150010.filter,tp,LOCATION_SZONE,0,1,1,nil)
end

function c10150010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,400) and e:GetHandler():IsDiscardable() end
	local lp=Duel.GetLP(tp)
	if lp>=2800 then lp=2800 end
	local t={}
	local l=1
	while l*400<=lp do
		t[l]=l*400
		l=l+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10150010,2))
	local announce=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	Duel.PayLPCost(tp,announce)
	e:SetLabel(announce/400)
end

function c10150010.eqfilter(c)
	return c:IsCode(40024595) and c:GetTurnCounter()>=8
end
function c10150010.rfilter(c)
	return c:IsCode(58192742) and c:GetEquipGroup():FilterCount(c10150010.eqfilter,nil)>0
end
function c10150010.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c10150010.rfilter,1,nil)
end
function c10150010.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c10150010.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
