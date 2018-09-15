--季雨 随和绀黑
function c10118010.initial_effect(c)
	c:EnableReviveLimit() 
	--xyz
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10118010,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.XyzCondition(nil,4,2,2))
	e1:SetTarget(Auxiliary.XyzTarget(nil,4,2,2))
	e1:SetOperation(c10118010.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1) 
	--link
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10118010,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Auxiliary.LinkCondition(aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),2,2,nil))
	e2:SetOperation(c10118010.linkop)
	e2:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10118010,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c10118010.con)
	e3:SetTarget(c10118010.rmtg)
	e3:SetOperation(c10118010.rmop)
	e3:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e3)
	--Destroy
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(10118010,3))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCondition(c10118010.con)
	e4:SetTarget(c10118010.destg)
	e4:SetOperation(c10118010.desop)
	e4:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e4)
end
function c10118010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)
end
function c10118010.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	   local tg=g:GetMinGroup(Card.GetAttack)
	   Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function c10118010.con(e)
	return e:GetHandler():IsSummonType(e:GetValue())
end
function c10118010.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c10118010.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10118010.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c10118010.rmfilter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,tg:GetCount(),0,0)
end
function c10118010.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10118010.rmfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	   local tg=g:GetMaxGroup(Card.GetAttack)
	   Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function c10118010.linkop(e,tp,eg,ep,ev,re,r,rp,c)
   local mg=Duel.GetMatchingGroup(aux.LConditionFilter,tp,LOCATION_MZONE,0,nil,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),c)
   local sg=Group.CreateGroup()
   for i=0,1 do
	   local cg=mg:Filter(aux.LCheckRecursive,sg,tp,sg,mg,c,i,1,2,nil)
	   if cg:GetCount()==0 then break end
	   local minct=1
	   if aux.LCheckGoal(tp,sg,c,1,i,nil) then
		  if not Duel.SelectYesNo(tp,210) then break end
		  minct=0
	   end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	   local g=cg:Select(tp,minct,1,nil)
	   if g:GetCount()==0 then return end
	   sg:Merge(g)
   end
   Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
   c:SetMaterial(sg)
   Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
function c10118010.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if og and not min then
	   local sg=Group.CreateGroup()
	   for tc in aux.Next(og) do
		   local sg1=tc:GetOverlayGroup()
		   sg:Merge(sg1)
	   end
	   Duel.SendtoGrave(sg,REASON_RULE)
	   c:SetMaterial(og)
	   Duel.Overlay(c,og)
	else
	   local mg=e:GetLabelObject()
	   local sg=Group.CreateGroup()
	   local tc=mg:GetFirst()
	   for tc in aux.Next(mg) do
		   local sg1=tc:GetOverlayGroup()
		   sg:Merge(sg1)
	   end
	   Duel.SendtoGrave(sg,REASON_RULE)
	   c:SetMaterial(mg)
	   Duel.Overlay(c,mg)
	   mg:DeleteGroup()
	end
end