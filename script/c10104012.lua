--Q兽 辛勃
function c10104012.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10104012,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,10104012)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c10104012.target)
	e1:SetOperation(c10104012.operation)
	c:RegisterEffect(e1)
	--synchro level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e2:SetTarget(c10104012.syntg)
	e2:SetValue(1)
	e2:SetOperation(c10104012.synop)
	c:RegisterEffect(e2)	
end
function c10104012.filter(c)
	return c:IsFaceup() and c:GetLevel()>=1 and c:IsSetCard(0xa330)
end
function c10104012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10104012.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10104012.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c10104012.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_UPDATE_LEVEL)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   e1:SetValue(1)
	   tc:RegisterEffect(e1)
	   if c:IsRelateToEffect(e) then
		 if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SendtoGrave(c,REASON_RULE)
		 end
	   end 
	end
end
function c10104012.cardiansynlevel(c,ct)
	return ct
end
function c10104012.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c10104012.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local lv2=syncard:GetLevel()-1
	local lv3=syncard:GetLevel()-2
	if lv<=0 and lv2<=0 and lv3<=0 then return false end
	local g=Duel.GetMatchingGroup(c10104012.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	local res2=g:CheckWithSumEqual(c10104012.cardiansynlevel,lv2,minc,maxc,1)
	local res3=g:CheckWithSumEqual(c10104012.cardiansynlevel,lv3,minc,maxc,2)
	return res or res2 or res3
end
function c10104012.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local lv2=syncard:GetLevel()-1
	local lv3=syncard:GetLevel()-2
	local g=Duel.GetMatchingGroup(c10104012.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	local res2=g:CheckWithSumEqual(c10104012.cardiansynlevel,lv2,minc,maxc,1)
	local res3=g:CheckWithSumEqual(c10104012.cardiansynlevel,lv3,minc,maxc,2)
	local sg,op=nil,100
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10104012,1))
	if res3 and res2 and res then
	   op=Duel.SelectOption(tp,aux.Stringid(10104012,2),aux.Stringid(10104012,3),aux.Stringid(10104012,4))
	elseif res and res2 then
	   op=Duel.SelectOption(tp,aux.Stringid(10104012,2),aux.Stringid(10104012,3))
	elseif res and res3 then
	   op=Duel.SelectOption(tp,aux.Stringid(10104012,2),aux.Stringid(10104012,4))
	   if op==1 then op=2 end
	elseif res2 and res3 then
	   op=Duel.SelectOption(tp,aux.Stringid(10104012,3),aux.Stringid(10104012,4))+1
	end
	if op==100 then
	   if res then op=0
	   elseif res2 then op=1
	   else op=2
	   end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	if op==0 then
		sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	elseif op==1 then
		sg=g:SelectWithSumEqual(tp,c10104012.cardiansynlevel,lv2,minc,maxc,1)
	else
		sg=g:SelectWithSumEqual(tp,c10104012.cardiansynlevel,lv3,minc,maxc,2)
	end
	Duel.SetSynchroMaterial(sg)  
end