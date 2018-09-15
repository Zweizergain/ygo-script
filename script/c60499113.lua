--Du 蝎子
function c60499113.initial_effect(c)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60499113,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,60499113)
	e4:SetCondition(c60499113.spcon)
	e4:SetTarget(c60499113.sptg)
	e4:SetOperation(c60499113.spop)
	c:RegisterEffect(e4) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60499190)
	e1:SetCost(c60499113.thcost)
	e1:SetTarget(c60499113.target)
	e1:SetOperation(c60499113.activate)
	c:RegisterEffect(e1)   
end
function c60499113.spfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_TOKEN)
end
function c60499113.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60499113.spfilter,1,nil,tp)
end
function c60499113.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c60499113.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,60499101,0,0x4011,0,0,3,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,60499101)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60499113.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,2,nil,TYPE_TOKEN) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,2,2,nil,TYPE_TOKEN)
	Duel.Release(g,REASON_COST)
end
function c60499113.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60499113.filter11(c)
	return c:IsFaceup() and c:IsCode(60499105)
end
function c60499113.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c60499113.filter11,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(60499105) then
	Duel.Draw(tp,1,REASON_EFFECT)
	end
end