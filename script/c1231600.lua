--非想天则✿东风谷早苗
function c1231600.initial_effect(c)
	--summon with X tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1231600,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c1231600.otcon)
	e1:SetOperation(c1231600.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1231600,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,1231600)
	e2:SetTarget(c1231600.thtg)
	e2:SetOperation(c1231600.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCountLimit(1,1231601)
	e4:SetTarget(c1231600.tdtg)
	e4:SetOperation(c1231600.tdop)
	c:RegisterEffect(e4)
	--lvup
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1231600,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,1231602)
	e5:SetCondition(c1231600.descon)
	e5:SetCost(c1231600.cost)
	e5:SetOperation(c1231600.operation)
	c:RegisterEffect(e5)
end
function c1231600.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:GetLevel()>6 and minc<=2
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckTribute(c,2))
		or c:GetLevel()>1 and c:GetLevel()<=6 and minc<=1
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckTribute(c,1)
end
function c1231600.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if ct<=1 then ct=1 end 
	if c:GetLevel()>6 and ct<2 then ct=2 end 
	local g=Duel.SelectTribute(tp,c,ct,99)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c1231600.thfilter(c)
	return (c:IsCode(100000) or c:IsSetCard(0x1601)) and c:IsAbleToHand()
end
function c1231600.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1231600.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1231600.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c1231600.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tc and tc:GetCount()>0 then
		tc=tc:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c1231600.thfilter2(c)
	return (c:IsCode(100000) or c:IsSetCard(0x1601)) and c:IsAbleToDeck()
end
function c1231600.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1231600.thfilter2,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c1231600.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c1231600.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if tc and tc:GetCount()>0 then
		tc=tc:GetFirst()
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)==1 then 
			Duel.BreakEffect()
			Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,e:GetHandler())		
		end 
	end
end

function c1231600.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE
end
function c1231600.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x208) and not c:IsPublic()
end
function c1231600.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1231600.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c1231600.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function c1231600.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local code=e:GetLabel()
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	end
end





















