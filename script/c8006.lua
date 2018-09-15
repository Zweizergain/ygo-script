--来自异世界的沙耶
function c8006.initial_effect(c)
	--c:SetUniqueOnField(1,0,8006)
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c8006.hspcon)
	e1:SetOperation(c8006.hspop)
	c:RegisterEffect(e1)
	--LP up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8006,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	--e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c8006.discon)
	e2:SetOperation(c8006.operation)
	c:RegisterEffect(e2)
	--battle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(8006,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCost(c8006.cost)
	e5:SetTarget(c8006.target)
	e5:SetOperation(c8006.toperation)
	c:RegisterEffect(e5)
end
function c8006.filter(c)
	return c:IsReleasable() and c:IsCode(8100)
end
function c8006.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c8006.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,2,nil)
end
function c8006.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c8006.filter,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c8006.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c8006.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
	if te:IsActiveType(TYPE_EFFECT) and te:GetHandler()~=e:GetHandler() then
		Duel.Recover(e:GetHandlerPlayer(),500,REASON_EFFECT)
	end
end
function c8006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c8006.tfilter(c)
	return c:IsSetCard(0x901) and c:IsAbleToHand() and c:IsType(TYPE_FIELD) and c:IsType(TYPE_SPELL)
end
function c8006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c8006.tfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c8006.toperation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c8006.tfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end