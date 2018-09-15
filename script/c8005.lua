--渴望关怀的沙耶
function c8005.initial_effect(c)
	--c:SetUniqueOnField(1,0,8005)
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c8005.hspcon)
	e1:SetOperation(c8005.hspop)
	c:RegisterEffect(e1)
	--LP up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8005,0))
	e2:SetType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c8005.discon)
	e2:SetTarget(c8005.rectg)
	e2:SetOperation(c8005.recop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c8005.target)
	e4:SetOperation(c8005.activate)
	c:RegisterEffect(e4)
end
function c8005.filter(c)
	return c:IsReleasable() and c:IsCode(8100)
end
function c8005.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c8005.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c8005.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c8005.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c8005.discon(e,tp,eg,ep,ev,re,r,rp)	
	return ep~=tp
end
function c8005.rectg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)	
	Duel.SetTargetParam(600)	
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,600)
end
function c8005.recop(e,tp,eg,ep,ev,re,r,rp) 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)   
	Duel.Recover(p,d,REASON_EFFECT)
end
function c8005.tfilter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x901) and c:IsType(TYPE_MONSTER)
end
function c8005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c8005.tfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c8005.tfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c8005.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
end