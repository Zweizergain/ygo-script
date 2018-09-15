--翻身咸鱼
function c19000003.initial_effect(c)
	c:EnableUnsummonable() 
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19000003,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c19000003.thtg)
	e3:SetOperation(c19000003.thop)
	c:RegisterEffect(e3)   
end
function c19000003.thfilter(c,tp)
	return c:IsSetCard(0x1750) and c:IsAbleToHand()
end
function c19000003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c19000003.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19000003.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c19000003.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c19000003.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--
--
--
--
--
