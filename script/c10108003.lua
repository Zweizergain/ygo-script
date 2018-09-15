--糖果派 甜甜圈
function c10108003.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10108003,4))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c10108003.eftg)
	e1:SetOperation(c10108003.efop)
	c:RegisterEffect(e1)
	c10108003[c]=e1
end
function c10108003.sumfilter(c)
	return c:IsSetCard(0x9338) and c:IsSummonable(true,nil)
end
function c10108003.thfilter(c)
	return c:IsSetCard(0x9338) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c10108003.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_TOKEN) and Duel.IsPlayerCanDraw(tp,1)
	local b3=Duel.IsExistingMatchingCard(c10108003.sumfilter,tp,LOCATION_HAND,0,1,nil)
	local b4=Duel.IsExistingMatchingCard(c10108003.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 or b3 or b4 end
	local off=1
	local ops,opval,g={},{}
	if b1 then
		ops[off]=aux.Stringid(10108003,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(10108003,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(10108003,2)
		opval[off-1]=3
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(10108003,3)
		opval[off-1]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	elseif sel==2 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_TOKEN)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif sel==3 then
		e:SetCategory(CATEGORY_SUMMON)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)  
	else
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function c10108003.efop(e,tp,eg,ep,ev,re,r,rp)
	local sel,g=e:GetLabel()
	if sel==1 then
		g=Duel.GetFirstTarget()
		if g:IsRelateToEffect(e) then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	elseif sel==2 then
		g=Duel.GetFirstTarget()
		if g:IsRelateToEffect(e) and Duel.Destroy(g,REASON_EFFECT)~=0 then
		   Duel.Draw(tp,1,REASON_EFFECT)
		end
	elseif sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		g=Duel.SelectMatchingCard(tp,c10108003.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.Summon(tp,g:GetFirst(),true,nil)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10108003.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	end
end