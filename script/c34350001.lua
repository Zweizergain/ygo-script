--都市传说 裂口女
function c34350001.initial_effect(c)
	--summon with
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34350001,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c34350001.otcon)
	e1:SetOperation(c34350001.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--draw
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(34350001,2))
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EVENT_REMOVE)
	e7:SetTarget(c34350001.drtg)
	e7:SetOperation(c34350001.drop)
	c:RegisterEffect(e7)
end
c34350001.setname="CityTales"
function c34350001.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c34350001.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c34350001.otfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c.setname=="CityTales"
end
function c34350001.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler() 
	local loc=LOCATION_GRAVE 
	if Duel.IsPlayerAffectedByEffect(tp,34350004) then loc=loc+LOCATION_DECK end
	local mg=Duel.GetMatchingGroup(c34350001.otfilter,tp,loc,0,nil)
	return c:GetLevel()>6 and minc<=2
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=2
			or Duel.CheckTribute(c,1) and mg:GetCount()>=1)
		or c:GetLevel()>4 and c:GetLevel()<=6 and minc<=1
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=1
end
function c34350001.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local loc=LOCATION_GRAVE 
	if Duel.IsPlayerAffectedByEffect(tp,34350004) then loc=loc+LOCATION_DECK end
	local mg=Duel.GetMatchingGroup(c34350001.otfilter,tp,loc,0,nil)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>=2
	local b2=Duel.CheckTribute(c,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=mg:Select(tp,1,1,nil)
	if c:GetLevel()>6 then
		local g2=nil
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(34350001,1))) then
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