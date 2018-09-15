--残霞帝 终焉的王 岚
function c23330031.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c23330031.ffilter1,aux.FilterEqualFunction(Card.GetLevel,8),true)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c23330031.spcon)
	e1:SetOperation(c23330031.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c23330031.actlimit)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--r
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23330031,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c23330031.rtg)
	e3:SetOperation(c23330031.rop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(23330031,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetTarget(c23330031.ttg)
	e4:SetOperation(c23330031.top)
	c:RegisterEffect(e4)
	--tod
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(23330031,1))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetTarget(c23330031.tdtg)
	e5:SetOperation(c23330031.tdop)
	c:RegisterEffect(e5)
end
function c23330031.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23330031.thfilter2,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(c23330031.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c23330031.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c23330031.thfilter2,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		g=Duel.SelectMatchingCard(tp,c23330031.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
function c23330031.tdfilter(c)
	return c:GetLevel()==8 and c:IsFaceup() and c:IsAbleToDeck()
end
function c23330031.thfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c:IsFaceup()
end
function c23330031.thfilter(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c23330031.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23330031.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c23330031.top(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c23330031.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c23330031.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetDecktopGroup(tp,2)
	local g2=Duel.GetDecktopGroup(1-tp,2)
	if chk==0 then return g1 and g2 and g1:GetCount()>=2 and g2:GetCount()>=2 and g1:FilterCount(Card.IsAbleToRemove,nil)>=2 and g2:FilterCount(Card.IsAbleToRemove,nil)>=2 end
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,4,0,LOCATION_DECK)
end
function c23330031.rop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,2)
	local g2=Duel.GetDecktopGroup(1-tp,2)
	g1:Merge(g2)
	if g1:GetCount()<=0 then return end
	if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)~=0 then
	   local dg=Duel.GetOperatedGroup():Filter(Card.IsType,nil,TYPE_MONSTER)
	   if dg:GetCount()>=0 then
		  Duel.Damage(1-tp,dg:GetCount()*500,REASON_EFFECT)
	   end
	end
end
function c23330031.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e) and re:GetHandler():IsLocation(LOCATION_HAND) and re:IsActiveType(TYPE_MONSTER)
end
function c23330031.ffilter1(c)
	return c:IsFusionSetCard(0x555) and c:IsFusionType(TYPE_FUSION)
end
function c23330031.rfilter(c,fc)
	return (c23330031.ffilter1(c) or c:GetLevel()==8)
		and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function c23330031.spfilter1(c,tp,g)
	return g:IsExists(c23330031.spfilter2,1,c,tp,c)
end
function c23330031.spfilter2(c,tp,mc)
	return (c23330031.ffilter1(c) and mc:GetLevel()==8
		or c23330031.ffilter1(mc) and c:GetLevel()==8)
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c23330031.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c23330031.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	return rg:IsExists(c23330031.spfilter1,1,nil,tp,rg)
end
function c23330031.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(c23330031.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=rg:FilterSelect(tp,c23330031.spfilter1,1,1,nil,tp,rg)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=rg:FilterSelect(tp,c23330031.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
