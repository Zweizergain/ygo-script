--下击暴流
function c24672402.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24672402,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCondition(c24672402.chcon)
	e1:SetTarget(c24672402.chtg)
	e1:SetOperation(c24672402.chop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24672402,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,24672402)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c24672402.e3tg)
	e3:SetCondition(c24672402.e3con)
	e3:SetOperation(c24672402.e3op)
	c:RegisterEffect(e3)
end
function c24672402.e3op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local spg=Duel.SelectMatchingCard(tp,c24672402.e3tgfil,tp,LOCATION_GRAVE,0,1,1,nil)
		if spg:GetCount()>0 then
			Duel.SSet(tp,spg:GetFirst())
			Duel.ConfirmCards(1-tp,spg)
		end
end
function c24672402.e3tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c24672402.e3tgfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c24672402.e3tgfil(c)
	return c:IsCode(90135989) and c:IsSSetable()
end
function c24672402.sdfilter(c)
	return not c:IsSetCard(0x18) and c:IsFaceup()
end
function c24672402.e3con(e)
	return not Duel.IsExistingMatchingCard(c24672402.sdfilter,tp,LOCATION_MZONE,0,1,nil) and (Duel.GetTurnCount()~=e:GetHandler():GetTurnID() or e:GetHandler():IsReason(REASON_RETURN))
end
function c24672402.e1fil(c)
	return c:IsSetCard(0x18) and c:IsFaceup() and c:IsCanChangePosition()
end
function c24672402.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24672402.e1fil,rp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c24672402.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c24672402.e1fil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
function c24672402.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c24672402.repop)
end
function c24672402.chcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE)
end