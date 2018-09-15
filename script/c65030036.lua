--祸摆交游者 多拉
function c65030036.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c65030036.hspcon)
	c:RegisterEffect(e0)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c65030036.spcon)
	c:RegisterEffect(e1)
	--summon&spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65030036)
	e2:SetTarget(c65030036.thtg)
	e2:SetOperation(c65030036.thop)
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
	e4:SetTarget(c65030036.cttg)
	e4:SetOperation(c65030036.ctop)
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
	e6:SetCondition(c65030036.sumcona)
	e6:SetTarget(c65030036.sumlimit)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetTargetRange(1,0)
	e7:SetCondition(c65030036.sumconb)
	c:RegisterEffect(e7)
	--leave
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_LEAVE_FIELD)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetCondition(c65030036.lecon)
	e8:SetTarget(c65030036.letg)
	e8:SetOperation(c65030036.leop)
	c:RegisterEffect(e8)
end
function c65030036.hspcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c65030036.hspfil,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 or not e:GetHandler():IsLocation(LOCATION_HAND))
end
function c65030036.hspfil(c)
	return c:IsSetCard(0xdaf) and not c:IsDisabled()
end

function c65030036.spcon(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 or not e:GetHandler():IsLocation(LOCATION_HAND)
end

function c65030036.filter(c,e,tp)
	local at=c:GetAttribute()
	local rc=c:GetRace()
	return Duel.IsExistingMatchingCard(c65030036.spfilter,tp,LOCATION_DECK,0,1,nil,at,rc,e,tp)
end

function c65030036.spfilter(c,at,rc,e,tp)
	return c:GetAttribute()==at and c:GetRace()==rc and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c65030036.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and c65030036.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65030036.filter,tp,0,LOCATION_MZONE,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c65030036.filter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c65030036.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return false end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		local at=tc:GetAttribute()
		local rc=tc:GetRace()
		local g=Duel.SelectMatchingCard(tp,c65030036.spfilter,tp,LOCATION_DECK,0,1,1,nil,at,rc,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c65030036.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c65030036.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.GetControl(c,1-tp) end
end
function c65030036.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_HAND) and not c:IsSetCard(0xdaf)
end
function c65030036.sumcona(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetControler()~=e:GetHandler():GetOwner()
end
function c65030036.sumconb(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetControler()==e:GetHandler():GetOwner()
end
function c65030036.lecon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetPreviousControler()~=e:GetHandler():GetOwner()
end

function c65030036.filter2(c,e,tp)
	return c:IsSetCard(0xdaf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end 

function c65030036.letg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(c65030036.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil,0xdaf)  and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_GRAVE)
end
function c65030036.leop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local ct=g:GetCount()
	if ct>Duel.GetLocationCount(1-tp,LOCATION_MZONE) then ct=Duel.GetLocationCount(1-tp,LOCATION_MZONE) end
	if ct==0 then return false end
	local sg=Duel.SelectMatchingCard(tp,c65030036.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,ct,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)
	end
end