--[[
        Class: Vector

		API :
		---- functions ----
		VectorType(v)							-- return if as vector
		VectorIntersection(a1,b1,a2,b2)			-- return the Intersection of 2 lines
		VectorDirection(v1,v2,v)
		Vector(a,b)								-- return a vector from x,y pos or from another vector
		
		---- Vector Members ----
		x
		z
		
		---- Vector Functions ----
		vector:clone()							-- return a new Vector from vector
		vector:unpack()							-- x, z
		vector:len2()
		vector:len()							-- return vector length
		vector:dist(v)							-- distance between 2 vectors (v and vector)
		vector:normalize()						-- normalize vector
		vector:normalized()						-- return a new Vector normalize from vector
		vector:rotate(phi)						-- rotate the vector by phi angle
		vector:rotated(phi)						-- return a new Vector rotate from vector by phi angle
		vector:polar()							-- return the angle from axe
		vector:angleBetween(v1, v2)				-- return the angle formed from vector to v1,v2
		vector:projectOn(v)						-- return a new Vector from vector projected on v
		vector:mirrorOn(v)						-- return a new Vector from vector mirrored on v
		vector:cross(v)							-- return cross
		vector:center(v)						-- return center between vector and v
		vector:compare(v)						-- compare vector and v
		vector:perpendicular()					-- return new Vector rotated 90° rigth
		vector:perpendicular2()					-- return new Vector rotated 90° left
]]

-- STAND ALONE FUNCTIONS
function math.close(a,b,eps)
	eps = eps or 1e-9
	return math.abs(a - b) <= eps
end

function VectorType(v)
	return (v ~= nil and type(v.x) == "number" and type(v.z) == "number")
end

function VectorIntersection(a1,b1,a2,b2)
	assert(VectorType(a1) and VectorType(b1) and VectorType(a2) and VectorType(b2), "direction: wrong argument types (4 <Vector> expected)")
	if math.close(b1.x, 0) and math.close(b2.z, 0) then return Vector(a1.x, a2.z) end
	if math.close(b1.z, 0) and math.close(b2.x, 0) then return Vector(a2.x, a1.z) end
	local m1 = (not math.close(b1.x, 0)) and b1.z / b1.x or 0
	local m2 = (not math.close(b2.x, 0)) and b2.z / b2.x or 0
	if math.close(m1, m2) then return nil end
	local c1 = a1.z - m1 * a1.x
	local c2 = a2.z - m2 * a2.x
	local ix = (c2 - c1) / (m1 - m2)
	local iy = m1 * ix + c1
	if math.close(b1.x, 0) then return Vector(a1.x, a1.x * m2 + c2) end
	if math.close(b2.x, 0) then return Vector(a2.x, a2.x * m1 + c1) end
	return Vector(ix, iy)
end

function VectorDirection(v1,v2,v)
	assert(VectorType(v1) and VectorType(v2) and VectorType(v), "direction: wrong argument types (3 <Vector> expected)")
	return (v1.x - v2.x) * (v.z - v2.z) - (v.x - v2.x) * (v1.z - v2.z)
end

class 'Vector'
-- INSTANCED FUNCTIONS
function Vector:__init(a,b)
	if a == nil then
		self.x, self.z = 0, 0
	elseif b == nil then
		if VectorType(a) then
			self.x, self.z = a.x, a.z
		else
			assert(type(a.x) == "number" and type(a.y) == "number", "Vector: wrong argument types (expected nil or <Vector> or 2 <number>)")
			self.x, self.z = a.x, a.y
		end
	else
		assert(type(a) == "number" and type(b) == "number", "Vector: wrong argument types (expected nil or <Vector> or 2 <number>)")
		self.x = a
		self.z = b
	end
end

function Vector:__add(v)
	assert(VectorType(v), "add: wrong argument types (<Vector> expected)")
	return Vector(self.x + v.x, self.z + v.z)
end

function Vector:__sub(v)
	assert(VectorType(v), "Sub: wrong argument types (<Vector> expected)")
	return Vector(self.x - v.x, self.z - v.z)
end

function Vector:__mul(v)
	if type(v) == "number" then
		return Vector(self.x * v, self.z * v)
	else
		assert(VectorType(v), "Mul: wrong argument types (<Vector> or <number> expected)")
		return Vector(self.x * v.x, self.z * v.z)
	end
end

function Vector:__div(v)
	if type(v) == "number" then
		assert(v ~= 0, "Div: wrong argument types (expected divider ~= 0)")
		return Vector(self.x / v, self.z / v)
	else
		assert(VectorType(v), "Div: wrong argument types (<Vector> or <number> expected)")
		assert(v.x ~= 0 and v.z ~= 0, "Div: wrong argument types (expected divider ~= 0)")
		return Vector(self.x / v.x, self.z / v.z)
	end
end

function Vector:__lt(v)
	assert(VectorType(v), "__lt: wrong argument types (<Vector> expected)")
	return self.x < v.x or (self.x == v.x and self.z < v.z)
end

function Vector:__le(v)
	assert(VectorType(v), "__le: wrong argument types (<Vector> expected)")
	return self.x <= v.x and self.z <= v.z
end

function Vector:__eq(v)
	assert(VectorType(v), "__eq: wrong argument types (<Vector> expected)")
	return self.x == v.x and self.z == v.z
end

function Vector:__unm()
	return Vector(- self.x, - self.z)
end

function Vector:__tostring()
	return "("..tonumber(self.x)..","..tonumber(self.z)..")"
end

function Vector:clone()
	return Vector(self.x, self.z)
end

function Vector:unpack()
	return self.x, self.z
end

-- old LengthSQ
function Vector:len2()
	return self.x * self.x + self.z * self.z
end

-- old Length
function Vector:len()
	return math.sqrt(Vector:len2())
end

function Vector:dist(v)
	assert(VectorType(v), "dist: wrong argument types (<Vector> expected)")
	local a = self - v
	return a:len()
end

function Vector:normalize()
	local len = self:len()
	if len ~= 0 then self.x, self.z = self.x / len, self.z / len end
end

function Vector:normalized()
	return self:clone():normalize()
end

function Vector:rotate(phi)
	assert(type(phi) == "number", "Rotate: wrong argument types (expected <number> for phi)")
	local c, s = math.cos(phi), math.sin(phi)
	self.x, self.z = c * self.x - s * self.z, s * self.x + c * self.z
end

function Vector:rotated(phi)
	assert(type(phi) == "number", "Rotated: wrong argument types (expected <number> for phi)")
	return self:clone():rotate(phi)
end

function Vector:polar()
	if math.close(self.x, 0) then
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

function Vector:angleBetween(v1, v2)
	assert(VectorType(v1) and VectorType(v2), "angleBetween: wrong argument types (2 <Vector> expected)")
	local p1, p2 = v1 - self, v2 - self
	local theta = p1:polar() - p2:polar()
	if theta < 0 then theta = theta + 360 end
	if theta > 180 then theta = 360 - theta end
end

function Vector:projectOn(v)
	assert(VectorType(v), "projectOn: invalid argument: cannot project Vector on " .. type(v))
	local s = (self.x * v.x + self.z * v.z) / (v.x * v.x + v.z * v.z)
	return Vector(s * v.x, s * v.z)
end

function Vector:mirrorOn(v)
	assert(VectorType(v), "mirrorOn: invalid argument: cannot mirror Vector on " .. type(v))
	local s = 2 * (self.x * v.x + self.z * v.z) / (v.x * v.x + v.z * v.z)
	return Vector(s * v.x - self.x, s * v.z - self.z)
end

function Vector:cross(v)
	assert(VectorType(v), "cross: wrong argument types (<Vector> expected)")
	return self.x * v.z - self.z * v.x
end

function Vector:center(v)
	assert(VectorType(v), "center: wrong argument types (<Vector> expected)")
	return Vector((self.x + v.x) / 2, (self.z + v.z) / 2)
end

function Vector:compare(v)
	assert(VectorType(v), "compare: wrong argument types (<Vector> expected)")
	local ret = self.x - other.x
	if ret == 0 then ret = self.z - other.z	end
	return ret
end

function Vector:perpendicular()
	return Vector(-self.y, self.x)
end

function Vector:perpendicular2()
	return Vector(self.y, -self.x)
end

-- FOR BACKWARD COMPATIBILITY (NEED TO BE REMOVED WHEN ALL SCRIPTS UPDATED)
Vector.New = Vector:__init
Vector.CloseTo = math.close
Vector.InfLineIntersection = VectorIntersection
Vector.Direction = VectorDirection