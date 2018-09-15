--Q兽 泰雷斯通
function c10104008.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10104008)
	e1:SetCondition(c10104008.spcon)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10104008,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10104108)
	e2:SetCost(c10104008.lvcost)
	e2:SetTarget(c10104008.lvtg)
	e2:SetOperation(c10104008.lvop)
	c:RegisterEffect(e2)
end
function c10104008.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10104008.lvfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsSetCard(0xa330)
end
function c10104008.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10104008.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c10104008.lvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectMatchingCard(tp,c10104008.lvfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	local op,val=0,0
	if tc:IsLevelAbove(2) then 
	   op=Duel.SelectOption(tp,aux.Stringid(10104008,1),aux.Stringid(10104008,2))
	else
	   op=Duel.SelectOption(tp,aux.Stringid(10104008,1))
	end
	if op==0 then val=1 else val=-1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(val)
	tc:RegisterEffect(e1)
end
function c10104008.sprfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa330)
end
function c10104008.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10104008.sprfilter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end