--勇者·斗·恶龙！
function c10140005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10140005.cost)
	e1:SetCondition(c10140005.condition)
	e1:SetTarget(c10140005.target)
	e1:SetOperation(c10140005.activate)
	c:RegisterEffect(e1)	
end

function c10140005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10140005)==0 end
	Duel.RegisterFlagEffect(tp,10140005,0,0,0)
end

function c10140005.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10140005.filter,tp,LOCATION_SZONE,LOCATION_SZONE,2,nil) and Duel.GetCurrentPhase()==PHASE_BATTLE 
end

function c10140005.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6333) and c:GetSequence()<5
end

function c10140005.spfilter2(c,e,tp)
	return c:IsSetCard(0x5333)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end

function c10140005.spfilter1(c,e,tp)
	return c:IsSetCard(0x3333)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end

function c10140005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3 and Duel.IsExistingMatchingCard(c10140005.spfilter1,tp,0x13,0,3,nil,e,tp) and Duel.IsExistingMatchingCard(c10140005.spfilter2,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0x13)
end

function c10140005.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local gc=Duel.SelectMatchingCard(tp,c10140005.spfilter2,tp,0x13,0,1,1,nil,e,tp):GetFirst()
	if gc and Duel.SpecialSummon(gc,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3 and Duel.IsExistingMatchingCard(c10140005.spfilter1,tp,0x13,0,3,nil,e,tp) then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local sg=Duel.SelectMatchingCard(tp,c10140005.spfilter1,tp,0x13,0,3,3,nil,e,tp)
		local tc=sg:GetFirst()
		 while tc do
		   if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK) then
			  tc:RegisterFlagEffect(10140005,RESET_EVENT+0x1fe0000,0,1)
		   end
		   tc=g:GetNext()
		 end
		   Duel.SpecialSummonComplete()
		sg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c10140005.con)
		e1:SetOperation(c10140005.op)
		e1:SetLabelObject(sg)
		Duel.RegisterEffect(e1,tp)
  end
end 

function c10140005.sfilter(c,fid)
	return c:GetFlagEffect(c10140005)~=0
end

function c10140005.con(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c10140005.sfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end

function c10140005.op(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	if lp<=3000 then
		Duel.SetLP(tp,0)
	else
		Duel.SetLP(tp,lp-3000)
	end
end

