--夺宝阵·破晓
function c10140002.initial_effect(c)
	c:EnableCounterPermit(0x331)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c10140002.ctop)
	c:RegisterEffect(e2)
	--special summon1
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(10140002,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c10140002.cost1)
	e3:SetTarget(c10140002.tg1)
	e3:SetOperation(c10140002.op1)
	c:RegisterEffect(e3)
	--special summon12
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(10140002,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c10140002.cost2)
	e4:SetTarget(c10140002.tg2)
	e4:SetOperation(c10140002.op2)
	c:RegisterEffect(e4)
end

function c10140002.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1344,9,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x331,9,REASON_COST)
end

function c10140002.filter2(c,e,tp)
	return c:IsSetCard(0x5333) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10140002.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10140002.filter2,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end

function c10140002.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10140002.filter2,tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		Duel.ShuffleDeck(tp)
	end
end

function c10140002.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1344,6,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x331,6,REASON_COST)
end

function c10140002.filter1(c,e,tp)
	return c:IsSetCard(0x3313) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c10140002.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10140002.filter1,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end

function c10140002.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10140002.filter1,tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		Duel.ShuffleDeck(tp)
	end
end

function c10140002.ctfilter(c)
	return (c:IsSetCard(0x3313) or c:IsSetCard(0x5333)) and c:IsType(TYPE_MONSTER)
end

function c10140002.ctop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 local g=eg:Filter(c10140002.ctfilter,nil)
	  if g:GetCount()>0 then 
		local count=0
		local tc=g:GetFirst()
		while tc do
		 if tc:IsSetCard(0x5333) then count=count+3 
		 else count=count+1
		 end
		 tc=g:GetNext()
		end
	 c:AddCounter(0x343,count)
	  end
end

