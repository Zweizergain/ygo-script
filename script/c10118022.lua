--季雨 蓝色魔力
function c10118022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10118022,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10118022.target)
	e1:SetOperation(c10118022.activate)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10118022,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10118022)
	e2:SetCondition(c10118022.thcon)
	e2:SetTarget(c10118022.thtg)
	e2:SetOperation(c10118022.thop)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)   
end
function c10118022.confilter(c,e)
	return c:IsPreviousLocation(LOCATION_MZONE) and c==e:GetLabelObject() and c:GetFlagEffect(10118022)~=0
end
function c10118022.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10118022.confilter,1,nil,e)
end
function c10118022.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10118022.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c10118022.ritfilter(c)
   return c:IsReleasableByEffect() and c:IsSetCard(0x5331) and c:IsType(TYPE_MONSTER) and c:IsCanBeRitualMaterial(nil)
end
function c10118022.filter(c,e,tp,m,m2)
	if not c:IsSetCard(0x5331) or bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg1=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	local mg2=m2:Filter(Card.IsCanBeRitualMaterial,c,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:IsLocation(LOCATION_EXTRA) then
	   ft=Duel.GetLocationCountFromEx(tp,tp)
	end
	if ft>0 then
		return mg1:CheckWithSumGreater(Card.GetRitualLevel,8,c) or mg2:GetCount()>0
	else
		return mg1:IsExists(c10118022.mfilterf,1,nil,tp,mg1,c) or (mg2:GetCount()>0 and mg2:IsExists(c10118022.mfilterf2,1,nil,tp,c) and c10118022.checkfield(tp))
	end
end
function c10118022.checkfield(tp)
	return (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or not Duel.IsExistingMatchingCard(c10118022.cfilter,tp,LOCATION_MZONE,0,1,nil)) and Duel.GetFlagEffect(tp,10118022)<=0
end
function c10118022.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_SPELLCASTER)
end
function c10118022.mfilterf2(c,tp,rc)
	return c:IsLocation(LOCATION_MZONE) and ((rc:IsLocation(LOCATION_HAND) and c:GetSequence()<5) or (rc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,c)>0))
end
function c10118022.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and ((rc:IsLocation(LOCATION_HAND) and c:GetSequence()<5) or (rc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,c)>0)) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,8,rc)
	else return false 
	end
end
function c10118022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c10118022.ritfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
		return Duel.IsExistingMatchingCard(c10118022.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,mg,mg2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c10118022.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c10118022.ritfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10118022.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,mg1,mg2):GetFirst()
	if mg2:GetCount()>0 then
	   mg2=mg2:Filter(Card.IsCanBeRitualMaterial,tc,tc)
	end
	local exritual=false
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if tc:IsLocation(LOCATION_EXTRA) then
	   ft=Duel.GetLocationCountFromEx(tp,tp)
	end
	if c10118022.checkfield(tp) and mg2:GetCount()>0 and (ft>0 or mg2:IsExists(c10118022.mfilterf2,1,nil,tp,tc)) and Duel.SelectYesNo(tp,aux.Stringid(10118022,2)) then 
	   exritual=true 
	   Duel.RegisterFlagEffect(tp,10118022,RESET_PHASE+PHASE_END,0,1)
	end
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local mat,matex=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			if exritual then
			   matex=mg2:Select(tp,1,1,nil)
			   mat=matex:Clone()
			else
			   mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,8,tc)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			if exritual then
			   matex=mg2:FilterSelect(tp,c10118022.mfilterf2,1,1,nil,tp,tc)
			   mat=matex:Clone()
			else
			   mat=mg:FilterSelect(tp,c10118022.mfilterf,1,1,nil,tp,mg,tc)
			   Duel.SetSelectedCard(mat)
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			   local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,8,tc)
			   mat:Merge(mat2)
			end
		end
		tc:SetMaterial(mat)
		if matex then 
		   Duel.SendtoGrave(matex,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL+REASON_RELEASE)
		else
		   Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:RegisterFlagEffect(10118022,RESET_EVENT+0x17a0000,0,1)
		e:GetLabelObject():SetLabelObject(tc)
		tc:CompleteProcedure()
	end 
end