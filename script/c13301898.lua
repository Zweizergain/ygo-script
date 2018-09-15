--火花棱镜
function c13301898.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c13301898.target)
	e1:SetOperation(c13301898.operation)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c13301898.eqlimit)
	c:RegisterEffect(e4)
	--indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(c13301898.valcon)
	c:RegisterEffect(e5)
	--Untargetable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--SpecialSummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(13301898,0))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1,13301898)
	e7:SetCost(c13301898.spcost)
	e7:SetTarget(c13301898.sptg)
	e7:SetOperation(c13301898.spop)
	c:RegisterEffect(e7)
end
function c13301898.eqlimit(e,c)
	return c:IsCode(13301897)
end
function c13301898.filter(c)
	return c:IsFaceup() and c:IsCode(13301897)
end
function c13301898.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c13301898.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13301898.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c13301898.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c13301898.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
	   Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c13301898.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c13301898.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec:IsReleasable() end
	e:SetLabel(ec:GetCode())
	Duel.Release(ec,REASON_COST)
end
function c13301898.spfilter(c,e,tp,code)
	return c:IsCode(13301896) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c13301898.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c13301898.spfilter,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,nil,e,tp,e:GetHandler():GetEquipTarget():GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_DECK)
end
function c13301898.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13301898.spfilter,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
