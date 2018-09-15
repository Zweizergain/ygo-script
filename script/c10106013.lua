--异位魔的威信
function c10106013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0x1e0)
	e1:SetTarget(c10106013.target1)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10106013,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCost(c10106013.thcost)
	e2:SetTarget(c10106013.thtg)
	e2:SetOperation(c10106013.thop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3338))
	e3:SetValue(c10106013.efilter)
	c:RegisterEffect(e3)
end
function c10106013.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_TRAP)
end
function c10106013.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
	if res and c10106013.thcost(e,tp,teg,tep,tev,tre,tr,trp,0) and c10106013.thtg(e,tp,teg,tep,tev,tre,tr,trp,0)
		and Duel.SelectYesNo(tp,94) then
		e:SetProperty(EFFECT_FLAG_DELAY)
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e:SetOperation(c10106013.thop)
		e:SetLabelObject(teg)
		c10106013.thcost(e,tp,teg,tep,tev,tre,tr,trp,1)
		c10106013.thtg(e,tp,teg,tep,tev,tre,tr,trp,1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c10106013.cfilter(c)
	return c:IsSetCard(0x3338) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c10106013.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10106013.cfilter,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():GetFlagEffect(10106013)==0 end
	e:GetHandler():RegisterFlagEffect(10106013,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10106013.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10106013.thfilter(c,ec)
	return c:IsAbleToHand() and c:GetLevel()==ec:GetLevel() and not c:IsCode(ec:GetCode()) and c:IsSetCard(0x3338)
end
function c10106013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   local ec=eg:GetFirst()
	   return eg:GetCount()==1 and ec:GetSummonPlayer()==tp and ec:IsSetCard(0x3338) and Duel.IsExistingMatchingCard(c10106013.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,ec)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10106013.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tg=Group.CreateGroup()
	if e:GetLabelObject() then tg:Merge(e:GetLabelObject()) else tg:Merge(eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10106013.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tg:GetFirst())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	e:SetLabelObject(nil)
end