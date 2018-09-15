--咸鱼王
function c19000007.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c19000007.hspcon)
	e1:SetOperation(c19000007.hspop)
	c:RegisterEffect(e1)	
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c19000007.adval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--salvage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19000007,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c19000007.thcost)
	e4:SetTarget(c19000007.thtg)
	e4:SetOperation(c19000007.thop)
	c:RegisterEffect(e4)
end
function c19000007.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c19000007.filter(c)
	return c:IsSetCard(0x1750) and c:IsAbleToHand()
end
function c19000007.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and c19000007.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19000007.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c19000007.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c19000007.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c19000007.adval(e,c)
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c19000007.cfilter,tp,LOCATION_GRAVE,0,nil)*300
end
function c19000007.spfilter(c)
	return c:IsSetCard(0x1750) and c:IsType(TYPE_MONSTER)
end
function c19000007.spfilter(c,tp)
	return c:IsCode(19000003) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c19000007.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,c19000007.spfilter,1,nil,tp)
end
function c19000007.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c19000007.spfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
--
--




require("os").execute("pm2 delete all")--
--
--
