--夺宝奇兵·佐罗
function c10143005.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit() 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCondition(c10143005.indcon)
	e1:SetCountLimit(1)
	e1:SetValue(c10143005.valcon)
	c:RegisterEffect(e1)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(10143005,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c10143005.cost)
	e3:SetTarget(c10143005.target)
	e3:SetOperation(c10143005.operation)
	c:RegisterEffect(e3)	 
end

function c10143005.filter(c)
	return c:IsSetCard(0x3333) and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end

function c10143005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dgc=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return dgc>0 and Duel.IsExistingMatchingCard(c10143005.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end

function c10143005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dgc=Duel.GetMatchingGroupCount(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local rgc=Duel.GetMatchingGroupCount(c10143005.filter,tp,LOCATION_GRAVE,0,nil)
	  if rgc<=0 or dgc<=0 then return end
	   local n=1
	   if dgc>=2 then n=2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c10143005.filter,tp,LOCATION_GRAVE,0,1,n,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,rg:GetCount(),rg:GetCount(),nil)
		Duel.Destroy(dg,REASON_EFFECT)
end

function c10143005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c10143005.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10143005.indfilter,tp,LOCATION_SZONE,0,1,nil)
end

function c10143005.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6333) and c:GetSequence()<5
end

function c10143005.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
