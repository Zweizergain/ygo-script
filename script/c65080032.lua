--彩虹之天气模样
function c65080032.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c65080032.spcon)
	e1:SetTarget(c65080032.sptg)
	e1:SetOperation(c65080032.spop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65080032,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65080032.spdtg)
	e2:SetOperation(c65080032.spdop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c65080032.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end

function c65080032.spcfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x109)	
end

function c65080032.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65080032.spcfil,1,nil)
end

function c65080032.spfil(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x109) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c65080032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65080032.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function c65080032.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65080032.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65080032.effil(c)
	return c:IsSetCard(0x109) and c:IsFaceup()
end

function c65080032.eftg(e,c)
	local tp=e:GetHandler():GetControler()
	local tkg=Duel.GetMatchingGroup(c65080032.effil,tp,LOCATION_SZONE,0,nil)
	local tc=tkg:GetFirst()
	local g=Group.CreateGroup()
	while tc do 
		local g1=tc:GetColumnGroup()
		g:Merge(g1)
		tc=tkg:GetNext()
	end
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x109) and g:IsContains(c) and c:GetSequence()<5 
end

function c65080032.spfilter(c,e,tp)
	return c:IsSetCard(0x109) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c65080032.spdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c65080032.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and (ft>-1 or (e:GetHandler():GetSequence()>4 and ft>0)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65080032.spdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local g=Duel.SelectMatchingCard(tp,c65080032.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65080032.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c65080032.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_DECK)
end