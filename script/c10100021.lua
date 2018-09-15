--银河急战·强袭武装铠
function c10100021.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c10100021.ffilter,2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10100021.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10100021.sprcon)
	e2:SetOperation(c10100021.sprop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100021,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c10100021.eqtg)
	e3:SetOperation(c10100021.eqop)
	c:RegisterEffect(e3)
	--unequip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10100021,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c10100021.con)
	e4:SetTarget(c10100021.sptg)
	e4:SetOperation(c10100021.spop)
	c:RegisterEffect(e2) 
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e5)
	--AD
	local e6=Effect.CreateEffect(c)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_ONFIELD)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(c10100021.tg)
	e6:SetValue(1500)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	--actlimit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetRange(LOCATION_ONFIELD)
	e8:SetTargetRange(0,1)
	e8:SetValue(c10100021.aclimit)
	e8:SetCondition(c10100021.actcon)
	c:RegisterEffect(e8)
end
function c10100021.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if not tc then return false end
	if bit.band(e:GetType(),0x100)==0x100 then return tc:IsHasEffect(10100015)
	else return not tc:IsHasEffect(10100015)
	end
end
function c10100021.tg(e,tc)
	local g1,g2,c=tc:GetLinkedGroup(),tc:GetEquipGroup(),e:GetHandler()
	return (tc:IsHasEffect(10100029) and g1 and g1:IsContains(c)) or (g2 and g2:IsContains(c))
end
function c10100021.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c10100021.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c10100021.tg(e,a)) or (d and c10100021.tg(e,d))
end
function c10100021.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x339) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c10100021.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c10100021.matfilter(c,fc)
	return c:IsFusionSetCard(0x339)
		and c:IsReleasable() and c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579)
end
function c10100021.spfilter1(c,tp,g)
	return g:IsExists(c10100021.spfilter2,1,c,tp,c)
end
function c10100021.spfilter2(c,tp,mc)
	return c:GetFusionCode()~=mc:GetFusionCode()
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c10100021.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c10100021.matfilter,tp,LOCATION_MZONE,0,nil,c)
	return g:IsExists(c10100021.spfilter1,1,nil,tp,g)
end
function c10100021.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c10100021.matfilter,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c10100021.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c10100021.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST)
end
function c10100021.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10100005)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10100021.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(10100021,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100021.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x339)
end
function c10100021.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or (c:IsOnField() and c:IsFacedown()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c10100021.eqfilter,tp,LOCATION_MZONE,0,1,1,c)
	if g:GetCount()<=0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if not Duel.Equip(tp,c,tc,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c10100021.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function c10100021.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10100021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(10100021)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetEquipTarget() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	c:RegisterFlagEffect(10100021,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c10100021.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end