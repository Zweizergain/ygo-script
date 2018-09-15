--一番的宝物
function c10140001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10140001,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10140001)
	e2:SetCondition(c10140001.sercon)
	e2:SetTarget(c10140001.sertg)
	e2:SetOperation(c10140001.serop)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10140001,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c10140001.cost)
	e3:SetOperation(c10140001.operation)
	c:RegisterEffect(e3)
end

function c10140001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10140001.filter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c10140001.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(g:GetFirst())
end

function c10140001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
end

function c10140001.filter(c)
	return c:IsSetCard(0x6333) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsPublic()
end

function c10140001.sercon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function c10140001.thfilter1(c)
	return c:IsSetCard(0x3333) and c:IsAbleToHand()
end

function c10140001.thfilter2(c)
	return c:IsSetCard(0x5333) and c:IsAbleToHand()
end

function c10140001.sertg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c10140001.thfilter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c10140001.thfilter2,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g1:GetCount()>0 or g2:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c10140001.serop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.CreateGroup()
	local tc=nil
	local g1=Duel.GetMatchingGroup(c10140001.thfilter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c10140001.thfilter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()<=0 and g2:GetCount()<=0 then return end
	if g1:GetCount()>0 then 
	   g1:Merge(g2)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tc=g1:Select(tp,1,1,nil):GetFirst()
		sg:AddCard(tc)
		g1:Remove(Card.IsCode,nil,tc:GetCode())
		 if tc:IsSetCard(0x3333) then
		   if g1:FilterCount(Card.IsSetCard,nil,0x3333)>0 and Duel.SelectYesNo(tp,aux.Stringid(10140001,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			tc=g1:FilterSelect(tp,Card.IsSetCard,1,1,nil,0x3333):GetFirst()
			sg:AddCard(tc)  
			g1:Remove(Card.IsCode,nil,tc:GetCode())
			 if g1:FilterCount(Card.IsSetCard,nil,0x3333)>0 and Duel.SelectYesNo(tp,aux.Stringid(10140001,1)) then
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			  tc=g1:FilterSelect(tp,Card.IsSetCard,1,1,nil,0x3333):GetFirst()
			  sg:AddCard(tc)
			 end
			end 
		 end
	else	
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tc=g2:Select(tp,1,1,nil):GetFirst()
		sg:AddCard(tc)  
	end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
