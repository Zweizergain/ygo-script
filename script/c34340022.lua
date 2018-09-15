--白色乐章–窃取
function c34340022.initial_effect(c)
	--th
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34340022,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c34340022.thcon)
	e1:SetTarget(c34340022.thtg)
	e1:SetOperation(c34340022.thop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34340022,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c34340022.drcon)
	e2:SetTarget(c34340022.drtg)
	e2:SetOperation(c34340022.drop)
	c:RegisterEffect(e2)	
end
c34340022.setname="WhiteAlbum"
function c34340022.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp)) and c:IsReason(REASON_DESTROY) and c.setname=="WhiteMagician"
end
function c34340022.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c34340022.cfilter,1,nil,tp)
end
function c34340022.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_GRAVE)
end
function c34340022.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToHand),tp,0,LOCATION_GRAVE,1,1,nil)	
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end
function c34340022.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:IsReason(REASON_DESTROY)
end
function c34340022.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c34340022.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
	   local tc=Duel.GetOperatedGroup():GetFirst()
	   Duel.ConfirmCards(1-tp,tc)
	   if tc:IsType(TYPE_MONSTER) then Duel.Recover(tp,1000,REASON_EFFECT)
	   else
		  Duel.Damage(tp,1000,REASON_EFFECT)
	   end
	end
end
