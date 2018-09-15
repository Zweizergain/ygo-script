--猛毒性 Do·Re·Pion
function c24562461.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24562461,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(c24562461.e1con)
	e1:SetTarget(c24562461.e1tg)
	e1:SetOperation(c24562461.e1op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c24562461.e2cost)
	e2:SetCountLimit(1,24562462)
	e2:SetTarget(c24562461.e2tg)
	e2:SetOperation(c24562461.e2op)
	c:RegisterEffect(e2)
end
function c24562461.e2costfil(c)
	return c:IsSetCard(0x1390) and c:IsAbleToRemoveAsCost()
end
function c24562461.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c24562461.e2costfil,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24562461.e2costfil,tp,LOCATION_HAND,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c24562461.e2opfil(c,e,tp)
	return c:IsSetCard(0x1390) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c24562461.e2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c24562461.e2tgfil,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local g2=Duel.GetMatchingGroup(c24562461.e2opfil,tp,LOCATION_DECK,0,nil,e,tp)
		if tc:IsCode(24562462) and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(24562461,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(24562461,2))
				local sg=g2:Select(tp,1,1,nil)
				local sc=sg:GetFirst()
				local b1=sc:IsAbleToHand()
				local b2=sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				local op=0
				if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(24562461,3),aux.Stringid(24562461,4))
				elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(24562461,3))
				else op=Duel.SelectOption(tp,aux.Stringid(24562461,4))+1 end
				if op==0 then
					Duel.SendtoHand(sc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sc)
				else
					Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				end
		else
			Duel.ShuffleHand(tp)
		end
	end
end
function c24562461.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24562461.e2tgfil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c24562461.e2tgfil(c)
	return c:IsSetCard(0x1390) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup()
end
function c24562461.e1con(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	if not tc:IsSetCard(0x1390) and tc:IsFaceup() then return false end
	e:SetLabelObject(tc)
	return tc:IsOnField()
end
function c24562461.e1op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,Group.FromCards(tc))
	end
end
function c24562461.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=ev
	local label=Duel.GetFlagEffectLabel(0,24562461)
	if label then
		if ev==bit.rshift(label,16) then ct=bit.band(label,0xffff) end
	end
	local ce,cp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tf=ce:GetTarget()
	local ceg,cep,cev,cre,cr,crp=Duel.GetChainEvent(ct)
	if chkc then return chkc:IsOnField() and c24562461.filter(chkc,ce,cp,tf,ceg,cep,cev,cre,cr,crp) end
	if chk==0 then return Duel.IsExistingTarget(c24562461.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject(),ce,cp,tf,ceg,cep,cev,cre,cr,crp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c24562461.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetLabelObject(),ce,cp,tf,ceg,cep,cev,cre,cr,crp)
	local val=ct+bit.lshift(ev+1,16)
	if label then
		Duel.SetFlagEffectLabel(0,24562461,val)
	else
		Duel.RegisterFlagEffect(0,24562461,RESET_CHAIN,0,1,val)
	end
end
function c24562461.filter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end