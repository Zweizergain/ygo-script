--远古恶魔的使徒
function c35310003.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35310003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,35310003)
	e1:SetTarget(c35310003.sptg)
	e1:SetOperation(c35310003.spop)
	c:RegisterEffect(e1)   
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)   
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetDescription(aux.Stringid(35310003,1))
	e4:SetType(EFFECT_TYPE_IGNITION)  
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,35310103)
	e4:SetCost(c35310003.drcost)
	e4:SetTarget(c35310003.drtg)
	e4:SetOperation(c35310003.drop)
	c:RegisterEffect(e4)
end
function c35310003.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c35310003.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c35310003.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c35310003.spfilter(c,e,tp)
	return c:IsCode(35310003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c35310003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c35310003.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c35310003.sumfilter(c)
	return c:IsSetCard(0x3656) and c:IsSummonable(true,nil,1)
end
function c35310003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c35310003.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then 
	   local sumg=Duel.GetMatchingGroup(c35310003.sumfilter,tp,0x2,0,nil)
	   if sumg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(35310003,2)) then
		  Duel.BreakEffect() 
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		  local ssc=sumg:Select(tp,1,1,nil):GetFirst()
		  Duel.Summon(tp,ssc,true,nil,1)
	   end
	end
end
