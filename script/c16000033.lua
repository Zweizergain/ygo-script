--【PCG先行卡】植占师-太阳元素
function c16000033.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c16000033.ffilter,2,false)
end
function c16000033.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x101)
end