--灵噬指挥官 耶莫拉
function c79131321.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1201),2,true)
	--reage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79131321,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79131321)
	e1:SetCondition(c79131321.recon)
	e1:SetTarget(c79131321.retg)
	e1:SetOperation(c79131321.reop)
	c:RegisterEffect(e1)
	--return to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79131321,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79131322)
	e2:SetCost(c79131321.rtgcost)
	e2:SetTarget(c79131321.rtgtg)
	e2:SetOperation(c79131321.rtgop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79131321,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,79131321)
	e3:SetTarget(c79131321.thtg)
	e3:SetOperation(c79131321.thop)
	c:RegisterEffect(e3)
end

function c79131321.thfil(c)
	return c:IsSetCard(0x1201) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c79131321.thfil2(c,code)
	return c:IsSetCard(0x1201) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsAbleToHand()
end

function c79131321.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79131321.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c79131321.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c79131321.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
			local tc=g:GetFirst()
			local code=tc:GetCode()
			local g2=Duel.SelectMatchingCard(tp,c79131321.thfil2,tp,LOCATION_DECK,0,1,1,nil,code)
			if g2:GetCount()>0 then
				g:Merge(g2)
			end
			if Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then				Duel.ConfirmCards(1-tp,g)
				Duel.BreakEffect()
				local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			end
	end
end
function c79131321.rtgfilter(c)
	return c:IsSetCard(0x1201) and c:IsFaceup()
end
function c79131321.rtgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206,2,REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1206,2,REASON_COST)
end
function c79131321.rtgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_MZONE) end
end
function c79131321.rtgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_STANDBY,1)
		c:RegisterEffect(e1)
	end
end
function c79131321.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79131321.refilter(c)
	return c:IsSetCard(0x1201) and c:IsAbleToRemove()
end
function c79131321.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79131321.refilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c79131321.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c79131321.refilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0  then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end