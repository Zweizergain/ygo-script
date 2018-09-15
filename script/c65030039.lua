--祸摆线奏者 乌儿
function c65030039.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c65030039.hspcon)
	c:RegisterEffect(e0)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c65030039.spcon)
	c:RegisterEffect(e1)
	--summon&spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,65030039)
	e2:SetTarget(c65030039.thtg)
	e2:SetOperation(c65030039.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetCountLimit(1)
	e4:SetTarget(c65030039.cttg)
	e4:SetOperation(c65030039.ctop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--spsummonlimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	e6:SetCondition(c65030039.sumcona)
	e6:SetTarget(c65030039.sumlimit)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetTargetRange(1,0)
	e7:SetCondition(c65030039.sumconb)
	c:RegisterEffect(e7)
	--leave
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_LEAVE_FIELD)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetCountLimit(1,11614521)
	e8:SetCondition(c65030039.lecon)
	e8:SetTarget(c65030039.letg)
	e8:SetOperation(c65030039.leop)
	c:RegisterEffect(e8)
end
function c65030039.hspcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c65030039.hspfil,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 or not e:GetHandler():IsLocation(LOCATION_HAND))
end
function c65030039.hspfil(c)
	return c:IsSetCard(0xdaf) and not c:IsDisabled()
end

function c65030039.spcon(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 or not e:GetHandler():IsLocation(LOCATION_HAND)
end
function c65030039.filter(c)
	return c:IsSetCard(0xdaf) and c:IsAbleToHand()
end
function c65030039.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030039.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c65030039.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65030039.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65030039.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c65030039.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.GetControl(c,1-tp) end
end
function c65030039.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_HAND) and not c:IsSetCard(0xdaf)
end
function c65030039.sumcona(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetControler()~=e:GetHandler():GetOwner()
end
function c65030039.sumconb(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetControler()==e:GetHandler():GetOwner()
end
function c65030039.lecon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetPreviousControler()~=e:GetHandler():GetOwner()
end
function c65030039.filter2(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c65030039.letg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030039.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_EXTRA,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c65030039.leop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65030039.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_EXTRA,1,5,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end