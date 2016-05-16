class = {}
function class:new(n)
	n = n or {}
	setmetatable(n, self)
	self.__index = self
	return n
end