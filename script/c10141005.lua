--夺宝奇兵·泽塔
function c10141005.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10141005)
	e1:SetCondition(c10141005.spcon)
	e1:SetOperation(c10141005.spop)
	c:RegisterEffect(e1) 
	--xyzsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10141005,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetCost(c10141005.xyzcost)
	e2:SetCondition(c10141005.xyzcon)
	e2:SetTarget(c10141005.xyztg)
	e2:SetOperation(c10141005.xyzop)
	c:RegisterEffect(e2)	
end

function c10141005.xyzcon(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

function c10141005.xyzfilter2(c,mg)
	return c:IsXyzSummonable(mg) and c:IsType(TYPE_XYZ)
end 

function c10141005.xyzfilter1(c)
	return c:IsSetCard(0x5333) and c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end

function c10141005.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function c10141005.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		  local g=Duel.GetMatchingGroup(c10141005.xyzfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		  return Duel.IsExistingMatchingCard(c10141005.xyzfilter2,tp,LOCATION_EXTRA,0,1,nil,g) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=-1
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c10141005.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c10141005.xyzfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local xyzg=Duel.GetMatchingGroup(c10141005.xyzfilter2,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g,1,10)
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		--local sg=g:FilterSelect(tp,xyz.xyz_filter,xyz.xyz_count,xyz.xyz_count,nil)
		--Duel.XyzSummon(tp,xyz,sg)
	end
end

function c10141005.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10141005.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end

function c10141005.spfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x3333)
end

function c10141005.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10141005.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end