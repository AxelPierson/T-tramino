pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

t_list = {}

line = 0

level = 1
spd = 1
c = 0

function _init()
		palt(0, false)
		add(t_list, tetra:new())
		etat = 0
end

function _draw()
	cls()
	if (btn(4)) then
	  etat = 1
	end
	if (etat == 1) then
	  map(0, 0, 0, 0, 16, 16)
	  for e in all(t_list) do
		  e:draw();
	  end
	  print ("line")
	  print (line)
	  print ("level")
	  print (level)
	end
	if (etat == 0) then
	   map(16, 0, 0, 0, 16, 16)
	end
end

function _update()
 if (etat == 1) then
	 for e in all(t_list) do
		 if (e.mv == 1) then
		 	e:update();
		 end
	 end
	 check_line()
	 destroy();
	 if (line % 5 == 0 and c == 1) then
	 	level += 1
	 	spd += 0.25
	 	c = 0
	 end
	end
end

-->8

tetra = {x1, y1, x2, y2, x3, y3, x4, y4, sqr, spd, shape, move, state, d}
tetra.__index = tetra

function tetra:new()
	obj = {}
	setmetatable(obj, tetra)
	
	obj.spd = spd;
	obj.shape = flr(rnd(7)) + 1;
	obj.state = 0;
	
	--square
	if (obj.shape == 1) then
		obj.x1 = 56;
 	obj.y1 = -16;
 	obj.x2 = 64;
 	obj.y2 = -16;
 	obj.x3 = 56;
 	obj.y3 = -8;
 	obj.x4 = 64;
 	obj.y4 = -8;
	end
	
	--line
	if(obj.shape == 2) then
		obj.x1 = 64;
 	obj.y1 = -32;
 	obj.x2 = 64;
 	obj.y2 = -24;
 	obj.x3 = 64;
 	obj.y3 = -16;
 	obj.x4 = 64;
 	obj.y4 = -8;
	end
	
	--t shape
	if(obj.shape == 3) then
	 obj.x1 = 64;
 	obj.y1 = -16;
 	obj.x2 = 56;
 	obj.y2 = -8;
 	obj.x3 = 64;
 	obj.y3 = -8;
 	obj.x4 = 72;
 	obj.y4 = -8;
	end
	
	--z shape
	if(obj.shape == 4) then
	 obj.x1 = 72;
 	obj.y1 = -24;
 	obj.x2 = 72;
 	obj.y2 = -16;
 	obj.x3 = 64;
 	obj.y3 = -16;
 	obj.x4 = 64;
 	obj.y4 = -8;
	end
	
	--s shape
	if(obj.shape == 5) then
	 obj.x1 = 64;
 	obj.y1 = -16;
 	obj.x2 = 72;
 	obj.y2 = -16;
 	obj.x3 = 56;
 	obj.y3 = -8;
 	obj.x4 = 64;
 	obj.y4 = -8;
	end
	
	--l shape
	if(obj.shape == 6) then
	 obj.x1 = 72;
 	obj.y1 = -16;
 	obj.x2 = 56;
 	obj.y2 = -8;
 	obj.x3 = 64;
 	obj.y3 = -8;
 	obj.x4 = 72;
 	obj.y4 = -8;
	end
	
 --j shape
 if(obj.shape == 7) then
	 obj.x1 = 56;
 	obj.y1 = -16;
 	obj.x2 = 56;
 	obj.y2 = -8;
 	obj.x3 = 64;
 	obj.y3 = -8;
 	obj.x4 = 72;
 	obj.y4 = -8;
	end
	obj.mv = 1;
	obj.d = 0
	return obj
end

function tetra:draw()
	spr(self.shape, self.x1, self.y1);
	spr(self.shape, self.x2, self.y2);
 spr(self.shape, self.x3, self.y3);
 spr(self.shape, self.x4, self.y4);
end

function tetra:update()
	if(self:colision()) then
		self.y1 += self.spd;
		self.y2 += self.spd;
		self.y3 += self.spd;
		self.y4 += self.spd;
		if btnp(1) and self.mv == 1 and self:r_col() then
			self.x1 += 8
			self.x2 += 8
			self.x3 += 8
			self.x4 += 8
		end
		
		if btnp(0) and self.mv == 1 and self:l_col() then
			self.x1 -= 8
			self.x2 -= 8
			self.x3 -= 8
			self.x4 -= 8
		end
		
		if btnp(2) and self.mv == 1 then
			self:rotate()
		end
		
		if btn(3) and self.mv == 1 then
			self.y1 += 2;
			self.y2 += 2;
			self.y3 += 2;
			self.y4 += 2;
		end
	end
	
	if (self:colision() == false and self.mv != 0) then
		self.mv = 0;
		self:offset()
		if (self.y1 > 0) then
			add(t_list, tetra:new());
		end
	end
end
-->8
function tetra:offset()
	while (self.y1 % 8 != 0) do
		self.y1 = ceil(self.y1);
		self.y2 = ceil(self.y2);
		self.y3 = ceil(self.y3);
		self.y4 = ceil(self.y4);
		self.y1 -= 1;
		self.y2 -= 1;
		self.y3 -= 1;
		self.y4 -= 1;
	end
end

function tetra:colision()
	if (self.y1 >= 120 or self.y2 >= 120 or self.y3 >= 120 or self.y4 >= 120) then
		return (false)
	end
	for e in all(t_list) do
	 if (e.y1 != self.y1) then
	 	if ((self.y1 + 8 >= e.y1 and self.y1 + 8 < e.y1 + 8 and self.x1 == e.x1) 
	 		or (self.y2 + 8 >= e.y1 and self.y2 + 8 < e.y1 + 8 and self.x2 == e.x1) 
	 		or (self.y3 + 8 >= e.y1 and self.y3 + 8 < e.y1 + 8 and self.x3 == e.x1)
	 		or (self.y4 + 8 >= e.y1 and self.y4 + 8 < e.y1 + 8 and self.x4 == e.x1)) then
			 self:offset()
			 return (false)
	 	end
	 	if ((self.y1 + 8 >= e.y2 and self.y1 + 8 < e.y2 + 8 and self.x1 == e.x2)
	 		or (self.y2 + 8 >= e.y2 and self.y2 + 8 < e.y2 + 8 and self.x2 == e.x2)
				or (self.y3 + 8 >= e.y2 and self.y3 + 8 < e.y2 + 8 and self.x3 == e.x2)
				or (self.y4 + 8 >= e.y2 and self.y4 + 8 < e.y2 + 8 and self.x4 == e.x2)) then
		 	self:offset()
		 	return (false)
	 	end
	 	if ((self.y1 + 8 >= e.y3 and self.y1 + 8 < e.y3 + 8 and self.x1 == e.x3)
	 		or (self.y2 + 8 >= e.y3 and self.y2 + 8 < e.y3 + 8 and self.x2 == e.x3)
	 		or (self.y3 + 8 >= e.y3 and self.y3 + 8 < e.y3 + 8 and self.x3 == e.x3)
	 		or (self.y4 + 8 >= e.y3 and self.y4 + 8 < e.y3 + 8 and self.x4 == e.x3)) then
		 	self:offset()
		 	return (false)
	 	end
	 	if ((self.y1 + 8 >= e.y4 and self.y1 + 8 < e.y4 + 8 and self.x1 == e.x4)
	 		or (self.y2 + 8 >= e.y4 and self.y2 + 8 < e.y4 + 8 and self.x2 == e.x4)
	 		or (self.y3 + 8 >= e.y4 and self.y3 + 8 < e.y4 + 8 and self.x3 == e.x4)
	 		or (self.y4 + 8 >= e.y4 and self.y4 + 8 < e.y4 + 8 and self.x2 == e.x4)) then
		 	return (false)
  	end
  end
	end
	return (true)
end

function tetra:r_col()
	if (self.x1 >= 120 or self.x2 >= 120 or self.x3 >= 120 or self.x4 >= 120) then
		return (false);
	end
	for e in all(t_list) do
		if (self.x1 != e.x1) then
			if ((self.x1 + 8 >= e.x1 and self.x1 + 8 < e.x1 + 8 and self.y1 + 8 >= e.y1 and self.y1 + 8 < e.y1 + 8)
				or (self.x2 + 8 >= e.x1 and self.x2 + 8 < e.x1 + 8 and self.y2 + 8 >= e.y1 and self.y2 + 8 < e.y1 + 8)
				or (self.x3 + 8 >= e.x1 and self.x3 + 8 < e.x1 + 8 and self.y3 + 8 >= e.y1 and self.y3 + 8 < e.y1 + 8)
				or (self.x4 + 8 >= e.x1 and self.x4 + 8 < e.x1 + 8 and self.y4 + 8 >= e.y1 and self.y4 + 8 < e.y1 + 8)) then
				return (false)
			end
			if ((self.x1 + 8 >= e.x2 and self.x1 + 8 < e.x2 + 8 and self.y1 + 8 >= e.y2 and self.y1 + 8 < e.y2 + 8)
				or (self.x2 + 8 >= e.x2 and self.x2 + 8 < e.x2 + 8 and self.y2 + 8 >= e.y2 and self.y2 + 8 < e.y2 + 8)
				or (self.x3 + 8 >= e.x2 and self.x3 + 8 < e.x2 + 8 and self.y3 + 8 >= e.y2 and self.y3 + 8 < e.y2 + 8)
				or (self.x4 + 8 >= e.x2 and self.x4 + 8 < e.x2 + 8 and self.y4 + 8 >= e.y2 and self.y4 + 8 < e.y2 + 8)) then
				return (false)
			end
			if ((self.x1 + 8 >= e.x3 and self.x1 + 8 < e.x3 + 8 and self.y1 + 8 >= e.y3 and self.y1 + 8 < e.y3 + 8)
				or (self.x2 + 8 >= e.x3 and self.x2 + 8 < e.x3 + 8 and self.y2 + 8 >= e.y3 and self.y2 + 8 < e.y3 + 8)
				or (self.x3 + 8 >= e.x3 and self.x3 + 8 < e.x3 + 8 and self.y3 + 8 >= e.y3 and self.y3 + 8 < e.y3 + 8)
				or (self.x4 + 8 >= e.x3 and self.x4 + 8 < e.x3 + 8 and self.y4 + 8 >= e.y3 and self.y4 + 8 < e.y3 + 8)) then
				return (false)
			end
			if ((self.x1 + 8 >= e.x4 and self.x1 + 8 < e.x4 + 8 and self.y1 + 8 >= e.y4 and self.y1 + 8 < e.y4 + 8)
				or (self.x2 + 8 >= e.x4 and self.x2 + 8 < e.x4 + 8 and self.y2 + 8 >= e.y4 and self.y2 + 8 < e.y4 + 8)
				or (self.x3 + 8 >= e.x4 and self.x3 + 8 < e.x4 + 8 and self.y3 + 8 >= e.y4 and self.y3 + 8 < e.y4 + 8)
				or (self.x4 + 8 >= e.x4 and self.x4 + 8 < e.x4 + 8 and self.y4 + 8 >= e.y4 and self.y4 + 8 < e.y4 + 8)) then
				return (false)
			end
		end
	end
	return (true)
end


function tetra:l_col()
	if (self.x1 <= 0 or self.x2 <= 0 or self.x3 <= 0 or self.x4 <= 0) then
		return (false);
	end
	for e in all(t_list) do
		if (self.x1 != e.x1) then
			if ((self.x1 <= e.x1 + 8 and self.x1 + 8 > e.x1 and self.y1 + 8 >= e.y1 and self.y1 + 8 < e.y1 + 8)
				or (self.x2 <= e.x1 + 8 and self.x2 + 8 > e.x1 and self.y2 + 8 >= e.y1 and self.y2 + 8 < e.y1 + 8)
				or (self.x3 <= e.x1 + 8 and self.x3 + 8 > e.x1 and self.y3 + 8 >= e.y1 and self.y3 + 8 < e.y1 + 8)
				or (self.x4 <= e.x1 + 8 and self.x4 + 8 > e.x1 and self.y4 + 8 >= e.y1 and self.y4 + 8 < e.y1 + 8)) then
				return (false)
			end
			if ((self.x1 <= e.x2 + 8 and self.x1 + 8 > e.x2 and self.y1 + 8 >= e.y2 and self.y1 + 8 < e.y2 + 8)
				or (self.x2 <= e.x2 + 8 and self.x2 + 8 > e.x2 and self.y2 + 8 >= e.y2 and self.y2 + 8 < e.y2 + 8)
				or (self.x3 <= e.x2 + 8 and self.x3 + 8 > e.x2 and self.y3 + 8 >= e.y2 and self.y3 + 8 < e.y2 + 8)
				or (self.x4 <= e.x2 + 8 and self.x4 + 8 > e.x2 and self.y4 + 8 >= e.y2 and self.y4 + 8 < e.y2 + 8)) then
				return (false)
			end
			if ((self.x1 <= e.x3 + 8 and self.x1 + 8 > e.x3 and self.y1 + 8 >= e.y3 and self.y1 + 8 < e.y3 + 8)
				or (self.x2 <= e.x3 + 8 and self.x2 + 8 > e.x3 and self.y2 + 8 >= e.y3 and self.y2 + 8 < e.y3 + 8)
				or (self.x3 <= e.x3 + 8 and self.x3 + 8 > e.x3 and self.y3 + 8 >= e.y3 and self.y3 + 8 < e.y3 + 8)
				or (self.x4 <= e.x3 + 8 and self.x4 + 8 > e.x3 and self.y4 + 8 >= e.y3 and self.y4 + 8 < e.y3 + 8)) then
				return (false)
			end
			if ((self.x1 <= e.x4 + 8 and self.x1 + 8 > e.x4 and self.y1 + 8 >= e.y4 and self.y1 + 8 < e.y4 + 8)
				or (self.x2 <= e.x4 + 8 and self.x2 + 8 > e.x4 and self.y2 + 8 >= e.y4 and self.y2 + 8 < e.y4 + 8)
				or (self.x3 <= e.x4 + 8 and self.x3 + 8 > e.x4 and self.y3 + 8 >= e.y4 and self.y3 + 8 < e.y4 + 8)
				or (self.x4 <= e.x4 + 8 and self.x4 + 8 > e.x4 and self.y4 + 8 >= e.y4 and self.y4 + 8 < e.y4 + 8)) then
				return (false)
			end
		end
	end
	return (true)
end

function tetra:rotate()
	if (self.shape == 2) then
		self:r_line()
	end
	if (self.shape == 3) then
		self:r_t_shape()
	end
	if (self.shape == 4) then
		self:r_z_shape()
	end
	if (self.shape == 5) then
		self:r_s_shape()
	end
	if (self.shape == 6) then
		self:r_l_shape()
	end
	if (self.shape == 7) then
		self:r_j_shape()
	end
end
-->8
function tetra:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
	self.x1 = x1
	self.y1 = y1
	self.x2 = x2
	self.y2 = y2
	self.x3 = x3
	self.y3 = y3
	self.x4 = x4
	self.y4 = y4
end

function tetra:r_line()
	local x1 = self.x1
	local y1 = self.y1
	local x2 = self.x2
	local y2 = self.y2
	local x3 = self.x3
	local y3 = self.y3
	local x3 = self.x3
	local y3 = self.y3
	local x4 = self.x4
	local y4 = self.y4

	if (self.state == 0) then
		self:set_rotate(x2 - 8, y2, x2, y2, x2 + 8, y2, x2 + 16, y2)
		self.state = 1;
		if ((self:r_col() == false) 
			or (self:l_col() == false)) then
				self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
				self.state = 0;
		end
	else
		if (self.state == 1) then
		self:set_rotate(x2, y2 + 8, x2, y2, x2, y2 - 8, x2, y2 - 16)
		self.state = 0;
		end
		if (self:colision() == false) then
			self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
			self.state = 0
		end
	end
end

function tetra:r_t_shape()
	local x1 = self.x1
	local y1 = self.y1
	local x2 = self.x2
	local y2 = self.y2
	local x3 = self.x3
	local y3 = self.y3
	local x3 = self.x3
	local y3 = self.y3
	local x4 = self.x4
	local y4 = self.y4

	if (self.state == 0) then
		self.x2 = x3
		self.y2 = y3 + 8 
		self.state = 1;
		if ((self:colision() == false)
			or (self:r_col() == false)
			or (self:l_col() == false)) then
				self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
				self.state = 0;
		end
	else
		if (self.state == 1) then
			self.x1 = x3 - 8
			self.y1 = y3
			self.state = 2;
			if ((self:colision() == false)
				or (self:r_col() == false)
				or (self:l_col() == false)) then
				self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
				self.state = 1;
			end
		else
			if (self.state == 2) then
				self.x4 = x3
				self.y4 = y3 - 8
				self.state = 3
				if ((self:colision() == false)
					or (self:r_col() == false)
					or (self:l_col() == false)) then
					self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
					self.state = 2;
				end
			else
				if (self.state == 3) then
					self:set_rotate(x3, y3 - 8, x3 - 8, y3, x3, y3, x3 + 8, y3)
					self.state = 0
					if ((self:colision() == false)
						or (self:r_col() == false)
						or (self:l_col() == false)) then
						self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
						self.state = 3;
					end
				end
			end
		end
	end
end

function tetra:r_z_shape()
  
	local x1 = self.x1
	local y1 = self.y1
	local x2 = self.x2
	local y2 = self.y2
	local x3 = self.x3
	local y3 = self.y3
	local x3 = self.x3
	local y3 = self.y3
	local x4 = self.x4
	local y4 = self.y4
	
 if (self.state == 0) then
 self:set_rotate(x2 - 8, y2, x2, y2, x2 - 8, y2 - 8, x2 - 16, y2 - 8)
 self.state = 1;
 if ((self:colision() == false)
			or (self:r_col() == false)
			or (self:l_col() == false)) then
				self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
				self.state = 0;
		end
 else
  if (self.state == 1) then
  	self:set_rotate(x2, y2 - 8, x2, y2, x2 - 8, y2 + 8, x2 - 8, y2)
   self.state = 0
   if ((self:colision() == false)
				or (self:r_col() == false)
				or (self:l_col() == false)) then
					self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
					self.state = 1;
			end
 	end
 end
end

function tetra:r_s_shape()
 local x1 = self.x1
	local y1 = self.y1
	local x2 = self.x2
	local y2 = self.y2
	local x3 = self.x3
	local y3 = self.y3
	local x3 = self.x3
	local y3 = self.y3
	local x4 = self.x4
	local y4 = self.y4

	if (self.state == 0) then
		self:set_rotate(x1, y2 - 8, x2, y2, x2 - 8, y2, x2, y4)
  self.state = 1;
  if ((self:colision() == false)
			or (self:r_col() == false)
			or (self:l_col() == false)) then
				self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
				self.state = 0;
		end
 else
 	if (self.state == 1) then
 		self:set_rotate(x1, y2, x2, y2, x2 - 8, y2 + 8, x2 - 16, y4)
  	self.state = 0;
  	if ((self:colision() == false)
				or (self:r_col() == false)
				or (self:l_col() == false)) then
				self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
				self.state = 1;
			end
  end
 end
end

function tetra:r_l_shape()
	local x1 = self.x1
	local y1 = self.y1
	local x2 = self.x2
	local y2 = self.y2
	local x3 = self.x3
	local y3 = self.y3
	local x3 = self.x3
	local y3 = self.y3
	local x4 = self.x4
	local y4 = self.y4
	
	if (self.state == 0) then
  self:set_rotate(x2, y2 - 16, x2, y2, x2, y2 - 8, x2 + 8, y2)
  self.state = 1;
  if ((self:colision() == false)
				or (self:r_col() == false)
				or (self:l_col() == false)) then
				self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
				self.state = 0;
			end
 else
  if (self.state == 1) then
  	self:set_rotate(x1, y2 - 8, x2, y2, x2 + 8, y3, x2 + 16, y2 - 8)  
   self.state = 2
   if ((self:colision() == false)
				or (self:r_col() == false)
				or (self:l_col() == false)) then
				self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
				self.state = 1;
			end
  else
   if (self.state == 2) then
   	self:set_rotate(x1, y1, x2, y2, x2, y2 - 16, x2 - 8, y2 - 16)
    self.state = 3;
   	if ((self:colision() == false)
					or (self:r_col() == false)
					or (self:l_col() == false)) then
					self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
					self.state = 2;
				end
   else
    if (self.state == 3) then
    	self:set_rotate(x2 - 8, y2, x2, y2, x2 + 8, y2, x2 + 8, y2 - 8)
     self.state = 0;
    	if ((self:colision() == false)
						or (self:r_col() == false)
						or (self:l_col() == false)) then
						self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
						self.state = 3;
					end
  		end
   end
  end
 end
end

function tetra:r_j_shape()
 local x1 = self.x1
	local y1 = self.y1
	local x2 = self.x2
	local y2 = self.y2
	local x3 = self.x3
	local y3 = self.y3
	local x3 = self.x3
	local y3 = self.y3
	local x4 = self.x4
	local y4 = self.y4

 if (self.state == 0) then
 	self:set_rotate(x1, y2 + 8, x3, y3 + 8, x3, y3, x3, y3 - 8)
  self.state = 1;
  if ((self:colision() == false)
			or (self:r_col() == false)
			or (self:l_col() == false)) then
				self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
				self.state = 0;
			end
 else
 	if (self.state == 1) then
 	self:set_rotate(x2 + 8, y1, x3 + 8, y3, x3, y3, x3 - 8, y3)
 	 self.state = 2;
 	 if ((self:colision() == false)
				or (self:r_col() == false)
				or (self:l_col() == false)) then
				self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
				self.state = 1;
			end
 	else
 		if (self.state == 2) then
 			self:set_rotate(x2, y2, x3, y3, x3, y3 + 8, x3, y3 + 16) 
 			self.state = 3
 			if ((self:colision() == false)
						or (self:r_col() == false)
						or (self:l_col() == false)) then
						self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
						self.state = 2;
				end
 		else
 			if (self.state == 3) then
 				self:set_rotate(x2 - 8, y2 - 8, x2 - 8, y2, x3, y3 - 8, x3 + 8, y3 - 8)
					self.state = 0;
					if ((self:colision() == false)
						or (self:r_col() == false)
						or (self:l_col() == false)) then
						self:set_rotate(x1, y1, x2, y2, x3, y3, x4, y4)
						self.state = 3;
					end
 			end
 		end
 	end
 end
end
-->8

function clear_line(i)
	for e in all (t_list) do
		if (e.y1 == i and e.mv == 0) then 
			e.y1 = -10
			e.x1 = -10
			e.d += 1
		end
		if (e.y2 == i and e.mv == 0) then 
			e.y2 = -10
			e.x2 = -10
			e.d += 1
		end
		if (e.y3 == i and e.mv == 0) then 
			e.y3 = -10
			e.x3 = -10
			e.d += 1
		end
		if (e.y4 == i and e.mv == 0) then 
			e.y4 = -10
			e.x4 = -10
			e.d += 1
		end
	end
end

function update_line(i)
	for e in all(t_list) do
		if e.y1 < i then e.y1 += 8 end
		if e.y2 < i then e.y2 += 8 end
		if e.y3 < i then e.y3 += 8 end
		if e.y4 < i then e.y4 += 8 end
	end
end

function check_line()
	local i = 0
	local l = 0
	while (i <= 120) do
		for e in all(t_list) do
			if (e.mv == 0) then
				if (e.y1 == i) then l += 1 end
				if (e.y2 == i) then l += 1 end
				if (e.y3 == i) then l += 1 end
				if (e.y4 == i) then l += 1 end
			end
		end
		if (l >= 16) then
			clear_line(i)
			update_line(i)
			line += 1
			c = 1
		end
		i += 8
		l = 0
	end
end

function destroy()
	for e in all(t_list) do
		if (e.d == 4) then
			del(t_list, e)
		end
	end
end
__gfx__
000000007aaaaaa07cccccc072222220788888807bbbbbb0799999907eeeeee000000000ddddddd0888888887777777777777777770000770677777706777777
00000000a77aaaa0c77cccc02772222087788880b77bbbb097799990e77eeee000000000ddddddd0888888887777777770000007770000770677777706777777
00700700a7aaaaa0c7ccccc02722222087888880b7bbbbb097999990e7eeeee000000000ddddddd0888888887777777770000007770077770677777706777777
00077000aaaaaaa0ccccccc02222222088888880bbbbbbb099999990eeeeeee000000000ddddddd0888888887777777777700777770000770677777706777777
00077000aaaaaaa0ccccccc02222222088888880bbbbbbb099999990eeeeeee000000000ddddddd0888888887777777777700777770000770677777706777777
00700700aaaaaaa0ccccccc02222222088888880bbbbbbb099999990eeeeeee000000000ddddddd0888888887777777777700777770077770677777706777777
00000000aaaaaaa0ccccccc02222222088888880bbbbbbb099999990eeeeeee000000000ddddddd0888888887777777777700777770000770677777706666666
00000000000000000000000000000000000000000000000000000000000000000000000000000000888888887777777777700777770000770677777700000000
0000000077777777777777600000000000000000777777607777777777777777ffffffff77760ffffff06777fff0677777760fff000000000000000000000000
0666666677777777777777606666666666666660777777607777777777777777ffffffff77760ffffff06777fff0677777760fff000000000000000000000000
0677777777777777777777607777777777777760777777607777777777777777ffffffff77760ffffff06777fff0677777760fff000000000000000000000000
0677777777777777777777607777777777777760777777607777777777777777ffffffff77760ffffff06777fff0677777760fff000000000000000000000000
0677777777777777777777607777777777777760777777607777777777777777ffffffff77760ffffff06777fff0677777760fff000000000000000000000000
0677777777777777777777607777777777777760777777607777777777777777ffffffff77760ffffff06777fff0677777760fff000000000000000000000000
0677777766666666777777607777777777777760666666606666677777766666ffffffff77760ffffff06777fff0666666660fff000000000000000000000000
0677777700000000777777607777777777777760000000000000677777760000ffffffff77760ffffff06777fff0000000000fff000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7777777777777777777777777777777700000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7777777777777777777777777777777700000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7777777777777777777777777777777700000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7777777777777777777777777777777700000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7777777777777777777777777777777700000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7777777777777777777777777777777700000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7777777777777777777777777777777700000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7777777777777777777777777777777700000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000007777777777777777777777777777777700000000000000000000000000000000
06666666666666666666666666666666666666666666666666666666666666607777777777777777777777777777777700000000000000000000000000000000
06888888888888799999999997aaaaaaaaaaaa73333333333cccc722222222607777777777777777777777777777777700000000000000000000000000000000
06877888888888797799999997a77aaaaaaaaa73773333333c77c727722222607777777777777777777777777777777700000000000000000000000000000000
06878888888888797999999997a7aaaaaaaaaa73733333337c7cc727222222607777777777777777777777777777777700000000000000000000000000000000
06878888888888797999999997a7aaaaaaaaaa73733777337cccc722227772607777777777777777777777777777777700000000000000000000000000000000
06888888888888799999999997aaaaaaaaaaaa733377733377777722277777607777777777777777777777777777777700000000000000000000000000000000
06888888888888799999999997aaaaaaaaaaaa73337773337cccc722277777607777777777777777777777777777777700000000000000000000000000000000
06777888888777799999777777777aaaaaa77773337773377cccc722227777607777777777777777777777777777777700000000000000000000000000000000
06777888888777799999777777777aaaaaa77773337733377cccc722222777607777777777777777777777777777777700000000000000000000000000000000
06777888888777799999777777777aaaaaa77773333333377cccc722222277607777777777777777777777777777777700000000000000000000000000000000
06777888888777799999999997777aaaaaa77773333333377cccc772222227607777777777777777777777777777777700000000000000000000000000000000
06777888888777799999999997777aaaaaa77773337333337cccc777222222607777777777777777777777777777777700000000000000000000000000000000
06777888888777799999999997777aaaaaa77773337733337cccc777722222607777777777777777777777777777777700000000000000000000000000000000
06777888888777799999999997777aaaaaa77773337733337cccc777772222607777777777777777777777777777777700000000000000000000000000000000
06777888888777799999977777777aaaaaa77773337773337cccc777777222607777777777777777777777777777777700000000000000000000000000000000
06777888888777799999977777777aaaaaa77773337773337cccc777777222607777777777777777777777777777777700000000000000000000000000000000
06777888888777799999977777777aaaaaa77773337773333cccc777777222607777777777777777777777777777777700000000000000000000000000000000
06777878888777797999999997777a7aaaa77773337777333cccc727772222607777777777777777777777777777777700000000000000000000000000000000
06777878888777797999999997777a7aaaa777733377773333ccc722222222607777777777777777777777777777777700000000000000000000000000000000
06777877888777797799999997777a77aaa777737377777333ccc727722222607777777777777777777777777777777700000000000000000000000000000000
06777888888777799999999997777aaaaaa7777333777773333cc722222222607777777777777777777777777777777700000000000000000000000000000000
06666666666666666666677777777777777777777776666666666666666666607777777777777777777777777777777700000000000000000000000000000000
00000000000000000000677777777777777777777776000000000000000000007777777777777777777777777777777700000000000000000000000000000000
fffffffffffffffffff06777777777777777777777760fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffff06777777777777777777777760fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffff06777777777777777777777760ffffffffffffffffffff00000fff00000fff00ffffffff00000ffffffffffffffffffffffffffffffff
fffffffffffffffffff06777777777777777777777760fffffffffffffffffff000000ff0000000ff00fffffff0000000fffffffffffffffffffffffffffffff
fffffffffffffffffff06777777777777777777777760fffffffffffffffffff00ffffff0000000ff00fffffff00fff00ffffffffffffffff0fffffff0ffffff
fffffffffffffffffff06777777777777777777777760fffffffffffffffffff00ffffff00fff00ff00fffffff00fff00fffffffffffffffff000ffff000ffff
fffffffffffffffffff06777700777777777700777760fffffffffffffffffff00ffffff00fff00ff00fffffff00fff00fffffffffffffffffff0000000000ff
fffffffffffffffffff067770dd0777777770dd077760fffffffffffffffffff000000ff00fff00ff00fffffff00fff00ffffffffffffffff00fff000000000f
fffffffffffffffffff067770ddd07777770ddd077760fffffffffffffffffff000000ff00fff00ff00fffffff00fff00ffffffffffffffffff00000000000ff
fffffffffffffffffff067770dddd000000dddd077760fffffffffffffffffffffff00ff00fff00ff00fffffff00fff00ffffffffffffffffffffffff000ffff
fffffffffffffffffff067770ddddd5555ddddd077760fffffffffffffffffffffff00ff00fff00ff00fffffff00fff00ffffffffffffffffffffffff0ffffff
fffffffffffffffffff067770dddddddddddddd077760fffffffffffffffffffffff00ff00fff00ff00fffffff0000000fffffffffffffffffffffffffffffff
fffffffffffffffffff067770dddddddddddddd077760fffffffffffffffffff000000ff0000000ff0000000ff0000000fffffffffffffffffffffffffffffff
fffffffffffffffffff06770dddddddddddddddd07760fffffffffffffffffff00000ffff00000fff0000000fff00000ffffffffffffffffffffffffffffffff
fffffffffffffffffff06770000000000000000007760fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffff067700707000d0070700007760fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
fffffffffffffffffff06770d07000ddd007000e07760fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000
fffffffffffffffffff06770de000dddddd000ee07760fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000
fffffffffffffffffff06770deeeddd0dddddeee07760fffffffffffffffffff00ffff00ff00fff00ff00ffff000000ff00fffffffffffff0000000000000000
fffffffffffffffffff067770ddddd000dddddd077760fffffffffffffffffff000ff000ff00fff00ff00ffff000000ff00fffffffffffff0000000000000000
fffffffffffffffffff0677770dddddddddddd0777760fffffffffffffffffff00000000ff00fff00ff00ffffff00fffffffffffffffffff0000000000000000
fffffffffffffffffff06777700000000000000777760fffffffffffffffffff00f00f00ff00fff00ff00ffffff00ffff00fffffffffffff0000000000000000
fffffffffffffffffff06666666666666666666666660fffffffffffffffffff00ffff00ff00fff00ff00ffffff00ffff00fffffffffffff0000000000000000
fffffffffffffffffff00000000000000000000000000fffffffffffffffffff00ffff00ff00fff00ff00ffffff00ffff00fffffffffffff0000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ffff00ff00fff00ff00ffffff00ffff00fffffffffffff0000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ffff00ff00fff00ff00ffffff00ffff00fffffffffffff0000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ffff00ff00fff00ff00ffffff00ffff00fffffffffffff0000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ffff00ff00fff00ff00ffffff00ffff00fffffffffffff0000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ffff00ff0000000ff000000ff00ffff00fffffffffffff0000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ffff00fff00000fff000000ff00ffff00fffffffffffff0000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
__map__
0909090909090909090909090909090918181818404142434445464718181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090918181818505152535455565718181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090918181818606162636465666718181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090918181818707172737475767718181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090918181818808182838485868718181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090918181818909192939495969718181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090918181818a0a1a2a3a4a5a6a718181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090918181818b0b1b2b3b4b5b6b718181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090909090909090909090909090909098e8f88898a8b8c8d8e8fa8a9aaabacad000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090909090909090909090909090909099e9f98999a9b9c9d9e9fb8b9babbbcbd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090918181818181818181818181818181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090918041818181802181818181818181818000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090904040318010102051818181818181804000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090904030303010102050518180707070404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090907020202020602030501010705050406000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090907070706060603030301010505060606000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010100150511605318052190511a051125531b0531c0531c0531c0531c0531c0531c0531c0501b0502355019050180501605015050130501305012050110501105009550110501105011050120501405017050
0010000018550185501855018550185501a5501a5501c5501c5501a5501a5501a5501a55018550185501a5501c5501d5501f5501c5501c5501a550185501a5501a5501c5501d550185501a5501c5501d5501f550
0010000018550185501a550245500f5501f5501e5501b550225501e5501e550225501b550205501955020550205501e5502055019550205501e5502055019550205501e5502055019550205501e5501b5501b550
000f00000f5500f5500f550155500f5500e55016550105501655018550185500f5501c5500f5501f5500f5500e5500e5500f550165501c550165501c5500c5502455024550245501855018550165501c55010550
__music__
04 01424344

