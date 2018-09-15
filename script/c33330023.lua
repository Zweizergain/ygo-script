--深界三层-大断层
function c33330023.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33330023,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33330023,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33330023.tcost)
	e1:SetTarget(c33330023.ttg)
	e1:SetOperation(c33330023.top)
	c:RegisterEffect(e1)  
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x556))
	e2:SetValue(1)
	c:RegisterEffect(e2)   
	--s c
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33330023,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCost(c33330023.scost)
	e4:SetCountLimit(1,33330023)
	e4:SetTarget(c33330023.stg)
	e4:SetOperation(c33330023.sop)
	c:RegisterEffect(e4) 
	--xxxx
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33330023,3))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c33330023.con2)
	e3:SetTarget(c33330023.tg2)
	e3:SetOperation(c33330023.op2)
	c:RegisterEffect(e3)
	--count
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_LEAVE_FIELD_P)
	e7:SetOperation(c33330023.contop)
	c:RegisterEffect(e7)
	e3:SetLabelObject(e7) 
	Duel.AddCustomActivityCounter(33330023,ACTIVITY_SUMMON,c33330023.counterfilter)
	Duel.AddCustomActivityCounter(33330023,ACTIVITY_SPSUMMON,c33330023.counterfilter)
end
function c33330023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(33330023,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(33330023,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33330023.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c33330023.splimit(e,c)
	return not c:IsSetCard(0x556)
end
function c33330023.counterfilter(c)
	return c:IsSetCard(0x556)
end
function c33330023.contop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetCounter(0x1019))
end
function c33330023.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c33330023.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local ct=e:GetLabelObject():GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ct*2000)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c33330023.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	if Duel.Damage(tp,ct*2000,REASON_EFFECT)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33330023.filter3),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c33330023.filter3(c)
	return c:IsCode(33330024) and c:IsAbleToHand()
end
function c33330023.sfilter(c,e,tp)
	return c:IsSetCard(0x556) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33330023.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x1019,1) and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c33330023.sfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,tp,0)
end
function c33330023.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	c:AddCounter(0x1019,1)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33330023.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   g:GetFirst():AddCounter(0x1019,1) 
	end
end
function c33330023.indesval(e,re,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c33330023.tcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c33330023.filter(c)
	return c:IsCode(33330019) and c:IsAbleToHand()
end
function c33330023.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33330023.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c33330023.top(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33330023.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end







