--超量之索尔德
--DoItYourself By if
function c33000104.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c33000104.ffilter,4,2)
	c:EnableReviveLimit()
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c33000104.splimit)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33000104,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,33000104)
	e3:SetCondition(c33000104.con)
	e3:SetTarget(c33000104.tg)
	e3:SetOperation(c33000104.op)
	c:RegisterEffect(e3)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c33000104.sumlimit)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33000104,4))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,33000104)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c33000104.spcon)
	e5:SetCost(c33000104.spcost)
	e5:SetTarget(c33000104.sptg)
	e5:SetOperation(c33000104.spop)
	c:RegisterEffect(e5)
end
function c33000104.ffilter(c)
    local tp=c:GetControler()
	return  (c:IsSetCard(0x402)or c:GetOwner()==1-tp)and c:IsType(TYPE_MONSTER)
end
function c33000104.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c33000104.filter(c,e,tp)
	return  c:IsType(TYPE_XYZ)and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c33000104.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c33000104.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33000104.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  c:IsRelateToEffect(e) and c:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	end
	local g=Duel.GetMatchingGroup(c33000104.filter,tp,0,LOCATION_EXTRA,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCountFromEx(tp)>0 then
	   local sc=g:RandomSelect(tp,1)
	   Duel.HintSelection(sc)
	   Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c33000104.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsCode(33000104)and c:IsType(TYPE_XYZ)
end
function c33000104.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c33000104.mfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c33000104.mfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA 
end
function c33000104.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost()end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function c33000104.spfilter1(c,e,tp)
	return c:IsSetCard(0x402)and not c:IsType(TYPE_XYZ)and c:IsType(TYPE_SYNCHRO)and 
	       c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c33000104.spfilter2(c,e,tp)
	return c:IsSetCard(0x402)and not c:IsType(TYPE_XYZ)and c:IsType(TYPE_FUSION)and 
	       c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)and c:CheckFusionMaterial()
end
function c33000104.spfilter3(c,e,tp)
	return c:IsSetCard(0x402)and not c:IsType(TYPE_XYZ)and c:IsType(TYPE_LINK)and 
	       c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c33000104.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c33000104.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) or
      		Duel.IsExistingMatchingCard(c33000104.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) or 
			Duel.IsExistingMatchingCard(c33000104.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33000104.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c33000104.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
    local b2=Duel.IsExistingMatchingCard(c33000104.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)  
	local b3=Duel.IsExistingMatchingCard(c33000104.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if Duel.GetLocationCountFromEx(tp)<=0 or not (b1 or b2 or b3)then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	    local ops={}
	    local opval={}
	    local off=1
	    if b1 then
		ops[off]=aux.Stringid(33000104,1)
		opval[off-1]=1
		off=off+1
	    end
	    if b2 then
		ops[off]=aux.Stringid(33000104,2)
		opval[off-1]=2
		off=off+1
	    end
	    if b3 then
		ops[off]=aux.Stringid(33000104,3)
		opval[off-1]=3
		off=off+1
	    end
    local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		       local g=Duel.SelectMatchingCard(tp,c33000104.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			   Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	elseif opval[op]==2 then
			   local g=Duel.SelectMatchingCard(tp,c33000104.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			   local tc=g:GetFirst()
	           if not tc then return end
	           tc:SetMaterial(nil)
			   Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	else
			   local g=Duel.SelectMatchingCard(tp,c33000104.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			   Duel.SpecialSummon(g,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
	end
end
