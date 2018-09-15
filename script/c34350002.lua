--都市传说 瘦长鬼影
function c34350002.initial_effect(c)
	--summon with
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34350002,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c34350002.otcon)
	e1:SetOperation(c34350002.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1) 
	--tg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34350002,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c34350002.tgcon)
	e3:SetTarget(c34350002.tgtg)
	e3:SetOperation(c34350002.tgop)
	c:RegisterEffect(e3)   
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34350002,3))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetOperation(c34350002.tgop2)
	c:RegisterEffect(e2)
end
c34350002.setname="CityTales"
function c34350002.tgop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
	   Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_RETURN)
	end
end
function c34350002.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c34350002.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsExistingMatchingCard(c34350002.tgfilter,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,1-tp,LOCATION_ONFIELD)
end
function c34350002.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(1-tp,c34350002.tgfilter,tp,0,LOCATION_ONFIELD,2,2,nil)
	if tg:GetCount()==2 then
	   Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c34350002.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c34350002.otfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c.setname=="CityTales"
end
function c34350002.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local loc=LOCATION_GRAVE 
	if Duel.IsPlayerAffectedByEffect(tp,34350004) then loc=loc+LOCATION_DECK end
	local mg=Duel.GetMatchingGroup(c34350002.otfilter,tp,loc,0,nil)
	return c:GetLevel()>6 and minc<=2
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=2
			or Duel.CheckTribute(c,1) and mg:GetCount()>=1)
		or c:GetLevel()>4 and c:GetLevel()<=6 and minc<=1
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=1
end
function c34350002.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local loc=LOCATION_GRAVE 
	if Duel.IsPlayerAffectedByEffect(tp,34350004) then loc=loc+LOCATION_DECK end
	local mg=Duel.GetMatchingGroup(c34350002.otfilter,tp,loc,0,nil)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=2
	local b2=Duel.CheckTribute(c,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=mg:Select(tp,1,1,nil)
	if c:GetLevel()>6 then
		local g2=nil
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(34350002,1))) then
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