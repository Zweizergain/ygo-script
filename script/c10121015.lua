--正义之大天使 泰瑞尔
function c10121015.initial_effect(c)
	c:SetUniqueOnField(1,0,10121015)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x9336),2,true)   
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)  
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10121015.sprcon)
	e2:SetOperation(c10121015.sprop)
	c:RegisterEffect(e2) 
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c10121015.efilter)
	c:RegisterEffect(e4)
	--draw or destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10121015,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c10121015.drcost)
	e5:SetTarget(c10121015.drtg)
	e5:SetOperation(c10121015.drop)
	c:RegisterEffect(e5) 
end
function c10121015.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10121015.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.IsCanRemoveCounter(tp,1,1,0x1333,3,REASON_COST) and Duel.IsPlayerCanDraw(tp,1)
	local ct2=Duel.IsCanRemoveCounter(tp,1,1,0x1333,5,REASON_COST) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return ct1 or ct2
	end
	Duel.RemoveCounter(tp,1,1,0x1333,Duel.GetCounter(tp,1,1,0x1333),REASON_COST)
end
function c10121015.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.IsCanRemoveCounter(tp,1,1,0x1333,3,REASON_COST) and Duel.IsPlayerCanDraw(tp,1)
	local ct2=Duel.IsCanRemoveCounter(tp,1,1,0x1333,5,REASON_COST) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local ct3=0
	if ct1 and ((not ct2) or Duel.SelectYesNo(aux.Stringid(10121015,1))) then
	   Duel.Draw(tp,1,REASON_EFFECT)
	   ct3=1
	end
	if ct2 and ((not ct1) or ct3==0 or Duel.SelectYesNo(aux.Stringid(10121015,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
		if dg:GetCount()>0 then
		  Duel.HintSelection(dg)
		  Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function c10121015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c10121015.efilter(e,re)
	return re:IsActiveType(TYPE_EFFECT) and re:GetHandler():IsRace(RACE_FIEND)
end
function c10121015.spfilter1(c)
	return c:IsSetCard(0x9336) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial()
end
function c10121015.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c10121015.spfilter1,tp,LOCATION_MZONE,0,2,nil)
end
function c10121015.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10121015.spfilter1,tp,LOCATION_MZONE,0,2,2,nil)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end