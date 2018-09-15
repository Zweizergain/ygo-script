--终焉之索尔德
--DoItYourself By if
function c33000107.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon from hand
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetCondition(c33000107.hspcon)
	e2:SetOperation(c33000107.hspop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33000107,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,33000107)
	e3:SetCost(c33000107.cost)
	e3:SetTarget(c33000107.target)
	e3:SetOperation(c33000107.operation)
	c:RegisterEffect(e3)
	 --Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33000107,5))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c33000107.destg)
	e4:SetOperation(c33000107.desop)
	c:RegisterEffect(e4)
	--tograve2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33000107,6))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c33000107.spcon)
	e3:SetTarget(c33000107.sptg)
	e3:SetOperation(c33000107.spop)
	c:RegisterEffect(e3)
	if not c33000107.global_flag then
		c33000107.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c33000107.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33000107.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(33000102) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),33000102,0,0,0)
		elseif tc:IsCode(33000103) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),33000103,0,0,0)
		elseif tc:IsCode(33000104) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),33000104,0,0,0)
		elseif tc:IsCode(33000105) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),33000105,0,0,0)
		end
	end
end
function c33000107.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),Card.IsCode,1,nil,33000101)and Duel.GetFlagEffect(tp,33000102)>0 and Duel.GetFlagEffect(tp,33000103)>0 and Duel.GetFlagEffect(tp,33000104)>0 and Duel.GetFlagEffect(tp,33000105)>0
end
function c33000107.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsCode,1,1,nil,33000101)
	Duel.Release(g,REASON_COST)
end
function c33000107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return  c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_DISCARD+REASON_COST)
end
function c33000107.filter(c)
	return c:IsCode(33000101) and c:IsAbleToHand()
end
function c33000107.mfilter1(c)
	return c:IsSetCard(0x402) and c:IsAbleToGraveAsCost()and c:IsType(TYPE_FUSION)
end
function c33000107.mfilter2(c)
	return c:IsSetCard(0x402) and c:IsAbleToGraveAsCost()and c:IsType(TYPE_SYNCHRO)
end
function c33000107.mfilter3(c)
	return c:IsSetCard(0x402) and c:IsAbleToGraveAsCost()and c:IsType(TYPE_XYZ)
end
function c33000107.mfilter4(c)
	return c:IsSetCard(0x402) and c:IsAbleToGraveAsCost()and c:IsType(TYPE_LINK)
end
function c33000107.nfilter(c,tpe)
	return c:IsFaceup() and c:IsType(tpe)
end
function c33000107.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c33000107.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c33000107.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c33000107.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c33000107.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a1=Duel.IsExistingMatchingCard(c33000107.mfilter1,tp,LOCATION_EXTRA,0,1,nil)
	local a2=Duel.IsExistingMatchingCard(c33000107.mfilter2,tp,LOCATION_EXTRA,0,1,nil)
	local a3=Duel.IsExistingMatchingCard(c33000107.mfilter3,tp,LOCATION_EXTRA,0,1,nil)
	local a4=Duel.IsExistingMatchingCard(c33000107.mfilter4,tp,LOCATION_EXTRA,0,1,nil)
    local b1=Duel.IsExistingMatchingCard(c33000107.nfilter,tp,0,LOCATION_MZONE,1,nil,TYPE_FUSION)
	local b2=Duel.IsExistingMatchingCard(c33000107.nfilter,tp,0,LOCATION_MZONE,1,nil,TYPE_SYNCHRO)
	local b3=Duel.IsExistingMatchingCard(c33000107.nfilter,tp,0,LOCATION_MZONE,1,nil,TYPE_XYZ)
	local b4=Duel.IsExistingMatchingCard(c33000107.nfilter,tp,0,LOCATION_MZONE,1,nil,TYPE_LINK)
    if chk==0 then return (a1 and b1) or(a2 and b2) or(a3 and b3) or (a4 and b4)end
    local off=1
	local ops={}
	local opval={}
	if (a1 and b1) then
		ops[off]=aux.Stringid(33000107,1)
		opval[off-1]=1
		off=off+1
	end
	if (a2 and b2) then
		ops[off]=aux.Stringid(33000107,2)
		opval[off-1]=2
		off=off+1
	end
	if (a3 and b3)  then
		ops[off]=aux.Stringid(33000107,3)
		opval[off-1]=3
		off=off+1
	end
    if (a4 and b4)  then
		ops[off]=aux.Stringid(33000107,4)
		opval[off-1]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	     if opval[op]==1 then
		        local g=Duel.SelectMatchingCard(tp,c33000107.mfilter1,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.SendtoGrave(g,REASON_COST)
				 e:SetLabel(TYPE_FUSION)
		 elseif opval[op]==2 then
			    local g1=Duel.SelectMatchingCard(tp,c33000107.mfilter2,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.SendtoGrave(g1,REASON_COST)
				 e:SetLabel(TYPE_SYNCHRO)
	     elseif opval[op]==3 then
			    local g3=Duel.SelectMatchingCard(tp,c33000107.mfilter3,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.SendtoGrave(g3,REASON_COST)
				 e:SetLabel(TYPE_XYZ)
		 else
		        local g4=Duel.SelectMatchingCard(tp,c33000107.mfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
				Duel.SendtoGrave(g4,REASON_COST)
				 e:SetLabel(TYPE_LINK)
	     end
	local  mg=Duel.GetMatchingGroup(c33000107.nfilter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,mg,mg:GetCount(),0,0)
end
function c33000107.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33000107.nfilter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
	if g:GetCount()>0 then
	Duel.Destroy(g,REASON_EFFECT)
	end
end
function c33000107.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp  and e:GetHandler():GetPreviousControler()==tp and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c33000107.setfilter(c)
	return c:IsSetCard(0x402) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c33000107.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0xe,0xe)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c33000107.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0xe,0xe)
	Duel.SendtoGrave(g,REASON_EFFECT)
    local g1=Duel.SelectMatchingCard(tp,c33000107.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 then
		local c=e:GetHandler()
		local tc=g1:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,g1)
	end
end
