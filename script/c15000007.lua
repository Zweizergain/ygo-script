--调律叠光士
function c15000007.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_XMAT_COUNT_LIMIT)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15000007,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c15000007.spcon)
	c:RegisterEffect(e1)
	--xyz limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetValue(c15000007.xyz_level)
	c:RegisterEffect(e2)
	--synchro level change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15000007,1))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_LEVEL)
	e3:SetValue(c15000007.slevel)
	c:RegisterEffect(e3)
end
function c15000007.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x105)
end
function c15000007.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c15000007.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c15000007.xyz_level(e,c,rc)
	return 0x3000+c:GetLevel()
end
function c15000007.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return 10*65536+lv
end
