--都市传说 迷失乱码
function c34350003.initial_effect(c)
	--summon with
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34350003,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c34350003.otcon)
	e1:SetOperation(c34350003.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)  
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34350003,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c34350003.discon)
	e2:SetTarget(c34350003.distg)
	e2:SetOperation(c34350003.disop)
	c:RegisterEffect(e2)   
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34350003,3))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c34350003.thtg)
	e3:SetOperation(c34350003.thop)
	c:RegisterEffect(e3)
end
c34350003.setname="CityTales"
function c34350003.thfilter(c)
	return c.setname=="CityTales" and not c:IsCode(34350003) and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_DECK))
end
function c34350003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c34350003.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c34350003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c34350003.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c34350003.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp~=tp
end
function c34350003.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c34350003.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c34350003.otfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c.setname=="CityTales"
end
function c34350003.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local loc=LOCATION_GRAVE 
	if Duel.IsPlayerAffectedByEffect(tp,34350004) then loc=loc+LOCATION_DECK end
	local mg=Duel.GetMatchingGroup(c34350003.otfilter,tp,loc,0,nil)
	return c:GetLevel()>6 and minc<=2
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=2
			or Duel.CheckTribute(c,1) and mg:GetCount()>=1)
		or c:GetLevel()>4 and c:GetLevel()<=6 and minc<=1
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=1
end
function c34350003.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local loc=LOCATION_GRAVE 
	if Duel.IsPlayerAffectedByEffect(tp,34350004) then loc=loc+LOCATION_DECK end
	local mg=Duel.GetMatchingGroup(c34350003.otfilter,tp,loc,0,nil)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=2
	local b2=Duel.CheckTribute(c,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=mg:Select(tp,1,1,nil)
	if c:GetLevel()>6 then
		local g2=nil
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(34350003,1))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			g2=mg:Select(tp,1,1,g:GetFirst())
		else
			g2=Duel.SelectTribute(tp,c,1,1)
		end
		g:Merge(g2)
	end
	c:SetMaterial(g)
	local sg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_DECK)
	if sg:GetCount()>0 then
	   Duel.Remove(sg,POS_FACEUP,REASON_SUMMON+REASON_MATERIAL)
	   g:Sub(sg)
	end
	if g:GetCount()>0 then
	   Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	end
end