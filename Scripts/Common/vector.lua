class 'vector'
function vector:isVector(v)
	return (v ~= nil and type(v.x) == "number" and type(v.z) == "number")
end
function vector:closeTo(a,b,eps)
	eps = eps or 1e-9
	return math.abs(a - b) <= eps
end

function vector:intersection(a1,b1,a2,b2)
	assert(vector:isVector(a1) and vector:isVector(b1) and vector:isVector(a2) and vector:isVector(b2), "direction: wrong argument types (4 <vector> expected)")
	if vector:closeTo(b1.x, 0.0) and vector:closeTo(b2.z, 0.0) then return vector(a1.x, a2.z) end
	if vector:closeTo(b1.z, 0.0) and vector:closeTo(b2.x, 0.0) then return vector(a2.x, a1.z) end
	local m1 = (not vector:closeTo(b1.x, 0.0)) and b1.z / b1.x or 0.0
	local m2 = (not vector:closeTo(b2.x, 0.0)) and b2.z / b2.x or 0.0
	if vector:closeTo(m1, m2) then return nil end
	local c1 = a1.z - m1 * a1.x
	local c2 = a2.z - m2 * a2.x
	local ix = (c2 - c1) / (m1 - m2)
	local iy = m1 * ix + c1
	if vector:closeTo(b1.x, 0.0) then return vector(a1.x, a1.x * m2 + c2) end
	if vector:closeTo(b2.x, 0.0) then return vector(a2.x, a2.x * m1 + c1) end
	return vector(ix, iy)
end

function vector:direction(v1,v2,v)
	assert(vector:isVector(v1) and vector:isVector(v2) and vector:isVector(v), "direction: wrong argument types (3 <vector> expected)")
	return (v1.x - v2.x) * (v.z - v2.z) - (v.x - v2.x) * (v1.z - v2.z)
end

function vector:__init(a,b)
	if a == nil then
		self.x, self.z = 0, 0
	elseif b == nil then
		if vector:isVector(a) then
			self.x, self.z = a.x, a.z
		else
			assert(type(a.x) == "number" and type(a.y) == "number", "vector: wrong argument types (expected nil or <vector> or 2 <number>)")
			self.x, self.z = a.x, a.y
		end
	else
		assert(type(a) == "number" and type(b) == "number", "vector: wrong argument types (expected nil or <vector> or 2 <number>)")
		self.x = a
		self.z = b
	end
end

function vector:__add(v)
	assert(self:isVector(v), "add: wrong argument types (<vector> expected)")
	return vector(self.x + v.x, self.z + v.z)
end

function vector:__sub(v)
	assert(self:isVector(v), "Sub: wrong argument types (<vector> expected)")
	return vector(self.x - v.x, self.z - v.z)
end

--old Scale function is same as vector * scale
function vector:__mul(v)
	if type(v) == "number" then
		return vector(self.x * v, self.z * v)
	else
		assert(self:isVector(v), "Mul: wrong argument types (<vector> or <number> expected)")
		return vector(self.x * v.x, self.z * v.z)
	end
end

function vector:__div(v)
	if type(v) == "number" then
		assert(v ~= 0, "Div: wrong argument types (expected divider ~= 0)")
		return vector(self.x / v, self.z / v)
	else
		assert(self:isVector(v), "Div: wrong argument types (<vector> or <number> expected)")
		assert(v.x ~= 0 and v.z ~= 0, "Div: wrong argument types (expected divider ~= 0)")
		return vector(self.x / v.x, self.z / v.z)
	end
end

function vector:__lt(v)
	assert(self:isVector(v), "__lt: wrong argument types (<vector> expected)")
	return self.x < v.x or (self.x == v.x and self.z < v.z)
end

function vector:__le(v)
	assert(self:isVector(v), "__le: wrong argument types (<vector> expected)")
	return self.x <= v.x and self.z <= v.z
end

function vector:__eq(v)
	assert(self:isVector(v), "__eq: wrong argument types (<vector> expected)")
	return self.x == v.x and self.z == v.z
end

function vector:__unm()
	return vector(- self.x, - self.z)
end

function vector:__tostring()
	return "("..tonumber(self.x)..","..tonumber(self.z)..")"
end

function vector:clone()
	return vector(self.x, self.z)
end

function vector:unpack()
	return self.x, self.z
end

-- old LengthSQ
function vector:len2()
	return self.x * self.x + self.z * self.z
end

-- old Length
function vector:len()
	return math.sqrt(vector:len2())
end

function vector:dist(v)
	assert(self:isVector(v), "dist: wrong argument types (<vector> expected)")
	local a = self - v
	return a:len()
end

function vector:normalize()
	local len = self:len()
	if len ~= 0 then self.x, self.z = self.x / len, self.z / len end
end

function vector:normalized()
	return self:clone():normalize()
end

function vector:rotate(v)
	assert(type(v) == "number", "Rotate: wrong argument types (expected <number> for phi)")
	local c, s = math.cos(v), math.sin(v)
	self.x, self.z = c * self.x - s * self.z, s * self.x + c * self.z
end

function vector:rotated(v)
	assert(type(v) == "number", "Rotated: wrong argument types (expected <number> for phi)")
	return self:clone():rotate(phi)
end

function vector:polar()
	if self:closeTo(self.x, 0) then
		if self.z > 0 then return 90
		elseif self.z < 0 then return 270
		else return 0
		end
	else
		local theta = math.deg(math.atan(self.z / self.x))
		if self.x < 0 then theta = theta + 180 end
		if theta < 0 then theta = theta + 360 end
	end
	return theta
end

function vector:angleBetween(v1, v2)
	assert(self:isVector(v1) and self:isVector(v2), "angleBetween: wrong argument types (2 <vector> expected)")
	local p1, p2 = v1 - self, v2 - self
	local theta = p1:polar() - p2:polar()
	if theta < 0 then theta = theta + 360 end
	if theta > 180 then theta = 360 - theta end
end

function vector:projectOn(v)
	assert(self:isVector(v), "projectOn: invalid argument: cannot project vector on " .. type(v))
	local s = (self.x * v.x + self.z * v.z) / (v.x * v.x + v.z * v.z)
	return vector(s * v.x, s * v.z)
end

function vector:mirrorOn(v)
	assert(self:isVector(v), "mirrorOn: invalid argument: cannot mirror vector on " .. type(v))
	local s = 2 * (self.x * v.x + self.z * v.z) / (v.x * v.x + v.z * v.z)
	return vector(s * v.x - self.x, s * v.z - self.z)
end

function vector:cross(v)
	assert(self:isVector(v), "cross: wrong argument types (<vector> expected)")
	return self.x * v.z - self.z * v.x
end

function vector:center(v)
	assert(self:isVector(v), "center: wrong argument types (<vector> expected)")
	return vector((self.x + v.x) / 2, (self.z + v.z) / 2)
end

function vector:compare(v)
	assert(self:isVector(v), "compare: wrong argument types (<vector> expected)")
	local ret = self.x - other.x
	if ret == 0 then ret = self.z - other.z	end
	return ret
end

function vector:perpendicular()
	return vector(-self.y, self.x)
end

function vector:perpendicular2()
	return vector(self.y, -self.x)
end
