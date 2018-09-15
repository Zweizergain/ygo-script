--远古恶魔 魔皇维克托
function c35310008.initial_effect(c)
	c:EnableReviveLimit()
	--connot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c35310008.spcon)
	e2:SetOperation(c35310008.spop)
	c:RegisterEffect(e2)
	--des
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35310008,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c35310008.destg)
	e3:SetOperation(c35310008.desop)
	c:RegisterEffect(e3)	
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5)
end
function c35310008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAttackable,LOCATION_MZONE,0,1,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function c35310008.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsAttackable,tp,LOCATION_MZONE,0,1,1,nil,1)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   if Duel.Destroy(g,REASON_EFFECT)~=0 then
		  local atk=g:GetFirst():GetAttack()
		  if atk<=0 then return end
		  Duel.BreakEffect()
		  local c=e:GetHandler() 
		  local b1=c:IsRelateToEffect(e) and c:IsFaceup()
		  if b1 and not Duel.SelectYesNo(tp,aux.Stringid(35310008,1)) then
			 local e1=Effect.CreateEffect(c)
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetCode(EFFECT_UPDATE_ATTACK)
			 e1:SetReset(RESET_EVENT+0x1ff0000)
			 e1:SetValue(atk)
			 c:RegisterEffect(e1)
		  else
			 Duel.Recover(tp,atk,REASON_EFFECT)
		  end
	   end
	end
end
function c35310008.spfilter(c)
	return c:IsSetCard(0x3656) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c35310008.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c35310008.spfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=5
end
function c35310008.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c35310008.spfilter,tp,LOCATION_GRAVE,0,nil)
	local rg=Group.CreateGroup()
	for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end