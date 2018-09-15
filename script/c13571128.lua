local m=13571128
local cm=_G["c"..m]
cm.name="矮人先锋 扎鲁马古斯"
function cm.initial_effect(c)
	--Level Change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.lvop)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEVEL_UP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.damop)
	c:RegisterEffect(e2)
end
--Level Change
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p1,p2=true,true
	if c:IsFaceup() and c:IsLevelAbove(1) then
		local tc=eg:GetFirst()
		while tc do
			local lv=0
			if tc:IsControler(tp) and p1 then lv,p1=-1,false end
			if tc:IsControler(1-tp) and p2 then lv,p2=1,false end
			if lv~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
				e1:SetValue(lv)
				e1:SetReset(RESET_EVENT+0x1ff0000)
				c:RegisterEffect(e1)
			end
			tc=eg:GetNext()
		end
	end
end
--Damage
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Damage(1-tp,400,REASON_EFFECT)
end