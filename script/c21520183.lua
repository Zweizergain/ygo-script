--曲形魔-克莱因
function c21520183.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),10,3,nil,nil,99)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c21520183.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_EXTRA)
	e2:SetCondition(c21520183.spcon)
	e2:SetOperation(c21520183.spop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetDescription(aux.Stringid(21520183,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c21520183.drcost)
	e3:SetTarget(c21520183.drtg)
	e3:SetOperation(c21520183.drop)
	c:RegisterEffect(e3)
	--atk & def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c21520183.adval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e5)
	--imune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetCondition(c21520183.econ)
	e6:SetValue(c21520183.efilter)
	c:RegisterEffect(e6)
	--material
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(21520183,1))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,21520183)
	e7:SetCost(c21520183.cost)
	e7:SetTarget(c21520183.target)
	e7:SetOperation(c21520183.operation)
	c:RegisterEffect(e7)
	--destroy replace
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetCode(EFFECT_DESTROY_REPLACE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(c21520183.reptg)
	c:RegisterEffect(e8)
end
function c21520183.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ or se:GetHandler()==e:GetHandler()
end
function c21520183.spfilter1(c)
	return c:IsSetCard(0x490) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c21520183.spfilter2(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c21520183.spfilter3(c)
	return (c:IsSetCard(0x490) or c:IsRace(RACE_FIEND)) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c21520183.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c21520183.spfilter3,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,e:GetHandler())
	return g:IsExists(c21520183.spfilter1,3,nil) and g:GetCount()>=3
end
function c21520183.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(c21520183.spfilter3,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=g1:FilterSelect(tp,c21520183.spfilter1,3,3,nil)
	g1:Sub(g2)
	local g=Group.CreateGroup()
	if Duel.SelectYesNo(tp,93) then
		g=g1:Select(tp,1,g1:GetCount(),nil)
	end
	g:Merge(g2)
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21520183.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c21520183.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21520183.drop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c21520183.adval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFaceup,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*400
end
function c21520183.econ(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c21520183.efilter(e,te)
	return not te:IsActiveType(TYPE_COUNTER) and te:GetHandler()~=e:GetHandler()
end
function c21520183.filter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler() and c:IsFaceup()
end
function c21520183.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c21520183.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520183.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		and e:GetHandler():IsType(TYPE_XYZ) end
end
function c21520183.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local ct=c:GetOverlayCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c21520183.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct+1,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		if c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(c,Group.FromCards(tc))
		end
		tc=g:GetNext()
	end
end
function c21520183.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local ct=math.ceil(e:GetHandler():GetOverlayCount()/2)
		return e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_EFFECT) end
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then 
		local ct=math.ceil(c:GetOverlayCount()/2)
		c:RemoveOverlayCard(tp,ct,ct,REASON_EFFECT)
		return true
	else return false end
end
