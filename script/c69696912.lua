--慵懒的图奇
function c69696912.initial_effect(c)
	--tohand1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69696912,3))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,69696912)
	e1:SetTarget(c69696912.tg1)
	e1:SetOperation(c69696912.op1)
	c:RegisterEffect(e1)
	--tohand2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69696912,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,696969121)
	e2:SetTarget(c69696912.tg2)
	e2:SetOperation(c69696912.op2)
	c:RegisterEffect(e2)
end
function c69696912.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c69696912.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69696912.filter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(69696912)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c69696912.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c69696912.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
			local tg=g:RandomSelect(tp,1)
			local tc=tg:GetFirst()
			if Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then 
				Duel.ConfirmCards(1-tp,tg)
				local dig=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsDiscardable,nil,tp)
				if dig:GetCount()>0 then
					Duel.BreakEffect()
					local sg=dig:RandomSelect(1-tp,1)
					local dic=sg:GetFirst()
					Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
					if tc==dic then 
						Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(69696912,0))
						Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(69696912,1))
						Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(69696912,2))
						e:GetHandler():RegisterFlagEffect(69696912,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
					end
				end
			end 
	 end
end
function c69696912.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69696912.filter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(69696912)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c69696912.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c69696912.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
			local tg=g:RandomSelect(tp,1)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
	end
end

