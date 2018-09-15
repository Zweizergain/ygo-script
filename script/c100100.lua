--丰收之神✿秋穰子
function c100100.initial_effect(c)
	--summon with X tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100100,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c100100.otcon)
	e1:SetOperation(c100100.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--1 level
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(100100,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,100101)
    e2:SetCost(c100100.cost)
    e2:SetTarget(c100100.target)
    e2:SetOperation(c100100.operation)
    c:RegisterEffect(e2)   
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100100,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,100100)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCost(c100100.drcost)
	e4:SetTarget(c100100.drtg)
	e4:SetOperation(c100100.drop)
	c:RegisterEffect(e4)
end
function c100100.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:GetLevel()>6 and minc<=2
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckTribute(c,2))
		or c:GetLevel()>=1 and c:GetLevel()<=6 and minc<=1
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckTribute(c,1)
end
function c100100.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if ct<=1 then ct=1 end 
	if c:GetLevel()>6 and ct<2 then ct=2 end 
	local g=Duel.SelectTribute(tp,c,ct,99)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c100100.mgfilter(c,e,tp,fusc)
	return  c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x12)==0x12 and c:GetReasonCard()==fusc
		and c:IsAbleToDeckAsCost() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c100100.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ag=c:GetMaterial()
	if chk==0 then return ag and ag:GetCount()>0 and ag:IsExists(c100100.mgfilter,1,nil,e,tp,c) end
	local dc=ag:FilterSelect(tp,c100100.mgfilter,1,1,nil,e,tp,c)
	Duel.SendtoDeck(dc,nil,2,REASON_COST)
end
function c100100.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c100100.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c100100.cost(e,tp,eg,ep,ev,re,r,rp,chk)    
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	--Use For AI
	Duel.RegisterFlagEffect(tp,100100,RESET_PHASE+PHASE_END,0,1)
end
function c100100.filter(c)
	return c:GetLevel()==1 and c:IsAbleToHand() and c:IsSetCard(0x208)
end
function c100100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100100.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100100.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100100.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end