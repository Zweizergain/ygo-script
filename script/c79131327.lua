--灵噬后勤官 舒尔
function c79131327.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1201),4,2)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79131327,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79131327)
	e1:SetCondition(c79131327.recon)
	e1:SetTarget(c79131327.retg)
	e1:SetOperation(c79131327.reop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79131327,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79131327)
	e2:SetCost(c79131327.rtgcost)
	e2:SetTarget(c79131327.rtgtg)
	e2:SetOperation(c79131327.rtgop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79131327,2))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,79131327)
	e3:SetTarget(c79131327.thtg)
	e3:SetOperation(c79131327.thop)
	c:RegisterEffect(e3)
end

function c79131327.thfil(c)
	return c:IsSetCard(0x1201) and c:IsAbleToHand()
end

function c79131327.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79131327.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c79131327.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c79131327.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c79131327.rtgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c79131327.rtgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local num=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(num*500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,num*500)
end
function c79131327.rtgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c79131327.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function c79131327.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local num=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(num*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,num*500)
end
function c79131327.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

