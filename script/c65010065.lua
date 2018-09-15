--终末旅者 鲁克
function c65010065.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65010065,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,65010065)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c65010065.target)
	e1:SetOperation(c65010065.operation)
	c:RegisterEffect(e1)
end
c65010065.setname="RagnaTravellers"
function c65010065.filter(c,e,sp)
	return (c.setname=="RagnaTravellers" or c:IsCode(65010082)) and c:IsType(TYPE_MONSTER) and not c:IsCode(65010065) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c65010065.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010065.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65010065.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=Duel.SelectMatchingCard(tp,c65010065.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local sc=sg:GetFirst()
	if sc then
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e3:SetValue(1)
		sc:RegisterEffect(e3)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		sc:RegisterEffect(e5)
		Duel.SpecialSummonComplete()
	end
end