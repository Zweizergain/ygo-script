--绯想天✿射命丸文
function c1230800.initial_effect(c)
	--summon with X tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1230800,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c1230800.otcon)
	e1:SetOperation(c1230800.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1230800,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1230800)
	e2:SetTarget(c1230800.retarget)
	e2:SetOperation(c1230800.reoperation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1230800,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,1230801)
	e3:SetCost(c1230800.spcost)
	e3:SetTarget(c1230800.thtg)
	e3:SetOperation(c1230800.thop)
	c:RegisterEffect(e3)
	--copy spell
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1230800,3))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e1)
	e4:SetCost(c1230800.cost)
	e4:SetCountLimit(1,1230802)
	e4:SetTarget(c1230800.target)
	e4:SetOperation(c1230800.operation)
	c:RegisterEffect(e4)
end
function c1230800.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:GetLevel()>6 and minc<=2
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckTribute(c,2))
		or c:GetLevel()>4 and c:GetLevel()<=6 and minc<=1
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckTribute(c,1)
end
function c1230800.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft
	if ct<=1 then ct=1 end 
	if c:GetLevel()>6 and ct<2 then ct=2 end 
	local g=Duel.SelectTribute(tp,c,ct,99)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c1230800.filter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c1230800.retarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFacedown() and chkc:IsAbleToDeck()	end
	if chk==0 then return Duel.IsExistingTarget(c1230800.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c1230800.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c1230800.reoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end


function c1230800.mgfilter(c,e,tp,fusc)
	return c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x12)==0x12 and c:GetReasonCard()==fusc 
		and c:IsAbleToDeckAsCost() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c1230800.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ag=c:GetMaterial()
	if chk==0 then return ag:IsExists(c1230800.mgfilter,1,nil,e,tp,c) end
	local dc=ag:FilterSelect(tp,c1230800.mgfilter,1,1,nil,e,tp,c)
	Duel.SendtoDeck(dc,nil,2,REASON_COST)
end
function c1230800.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c1230800.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end


function c1230800.filter44(c)
	return c:IsDiscardable() and bit.band(c:GetType(),TYPE_SPELL)~=0 and c:CheckActivateEffect(true,true,false)~=nil
end
function c1230800.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1230800.filter44,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1230800,1))
	local g=Duel.SelectMatchingCard(tp,c1230800.filter44,tp,LOCATION_HAND,0,1,1,nil)
	local te=g:GetFirst():CheckActivateEffect(false,true,true)
	c1230800[Duel.GetCurrentChain()]=te
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c1230800.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=c1230800[Duel.GetCurrentChain()]
	if chkc then
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
	end
	if chk==0 then return true end
	if not te then return end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c1230800.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=c1230800[Duel.GetCurrentChain()]
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
