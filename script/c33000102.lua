--融合之索尔德
--DoItYourself By if
function c33000102.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c33000102.ffilter,c33000102.ffilter2,true)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c33000102.splimit)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33000102,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,33000102)
	e3:SetCondition(c33000102.con)
	e3:SetTarget(c33000102.tg)
	e3:SetOperation(c33000102.op)
	c:RegisterEffect(e3)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c33000102.sumlimit)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33000102,4))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,33000102)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c33000102.spcon)
	e5:SetCost(c33000102.spcost)
	e5:SetTarget(c33000102.sptg)
	e5:SetOperation(c33000102.spop)
	c:RegisterEffect(e5)
end
function c33000102.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c33000102.ffilter(c)
    return c:IsSetCard(0x402)and c:IsType(TYPE_MONSTER) 
end
function c33000102.ffilter2(c)
    local tp=c:GetControler()
	return c:GetOwner()==1-tp
end
function c33000102.filter(c,e,tp)
	return  c:IsType(TYPE_FUSION)and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c33000102.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c33000102.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33000102.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  c:IsRelateToEffect(e) and c:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	end
	local g=Duel.GetMatchingGroup(c33000102.filter,tp,0,LOCATION_EXTRA,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCountFromEx(tp)>0 then
	   local sc=g:RandomSelect(tp,1)
	   Duel.HintSelection(sc)
	   Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c33000102.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsCode(33000102)and c:IsType(TYPE_FUSION)
end
function c33000102.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c33000102.mfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c33000102.mfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA 
end
function c33000102.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost()end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function c33000102.spfilter1(c,e,tp)
	return c:IsSetCard(0x402)and not c:IsType(TYPE_FUSION)and c:IsType(TYPE_XYZ)and 
	       c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c33000102.spfilter2(c,e,tp)
	return c:IsSetCard(0x402)and not c:IsType(TYPE_FUSION)and c:IsType(TYPE_SYNCHRO)and 
	       c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c33000102.spfilter3(c,e,tp)
	return c:IsSetCard(0x402)and not c:IsType(TYPE_FUSION)and c:IsType(TYPE_LINK)and 
	       c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c33000102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c33000102.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) or
      		Duel.IsExistingMatchingCard(c33000102.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) or 
			Duel.IsExistingMatchingCard(c33000102.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33000102.spop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c33000102.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
    local b2=Duel.IsExistingMatchingCard(c33000102.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)  
	local b3=Duel.IsExistingMatchingCard(c33000102.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if Duel.GetLocationCountFromEx(tp)>0 and (b1 or b2 or b3)then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	    local ops={}
	    local opval={}
	    local off=1
	    if b1 then
		ops[off]=aux.Stringid(33000102,1)
		opval[off-1]=1
		off=off+1
	    end
	    if b2 then
		ops[off]=aux.Stringid(33000102,2)
		opval[off-1]=2
		off=off+1
	    end
	    if b3 then
		ops[off]=aux.Stringid(33000102,3)
		opval[off-1]=3
		off=off+1
	    end
    local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		       local g=Duel.SelectMatchingCard(tp,c33000102.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			   Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	elseif opval[op]==2 then
			   local g=Duel.SelectMatchingCard(tp,c33000102.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			   Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	else
			   local g=Duel.SelectMatchingCard(tp,c33000102.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			   Duel.SpecialSummon(g,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
	end
	end
end
