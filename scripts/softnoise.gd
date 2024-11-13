#SOFTNOISE
#MIT License
#
#Copyright (c) 2017 PerduGames
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
#softnoise.gd by perdugames
#Based on the studies on this page:
#http://www.angelcode.com/dev/perlin/perlin.html
#I recommend reading, to understand more about perlin noise.
#Original implementation opensimplex in java:
#https://gist.github.com/KdotJPG/b1270127455a94ac5d19
#Example of how to use:
#https://github.com/PerduGames/SoftNoise-GDScript-

class SoftNoise:

	#Permutation table
	var perm = []
	#Gradient x table
	var gx = []
	#Gradient y table
	var gy = []

	func _init(_seed: int = 0):
		generateTable(_seed)


	func simple_noise1d(x: int) -> float:
		x = (int(x) >> 13) ^ int(x)
		var _x = int((x * (x * x * 60493 + 19990303) + 1376312589) & 0x7fffffff)
		return 1.0 - (float(_x) / 1073741824.0)


	func generateTable(_seed: int) -> void:
		var source = []
		if _seed == 0:
			randomize()
			_seed = randi() % 256
		else:
			_seed = int(simple_noise1d(_seed) * 32767) % 256
		#Start the permutation table
		for i in range(256):
			source.append(i)
			perm.append(0)
		_seed = _seed * 6364136223846793005 + 1442695040888963407
		_seed = _seed * 6364136223846793005 + 1442695040888963407
		_seed = _seed * 6364136223846793005 + 1442695040888963407
		var i = 255
		var r = 0
		while (i >= 0):
			_seed = _seed * 6364136223846793005 + 1442695040888963407
			r = (_seed + 31) % (i + 1)
			if (r < 0):
				r += (i + 1)
			perm[i] = source[r]
			source[r] = source[i]
			i -= 1
		for j in range(256):
			gx.append(2.0 - simple_noise1d(_seed * j) - 1.0)
			gy.append(2.0 - simple_noise1d(_seed * j) - 1.0)
			

	func perlin_noise2d(x: float, y: float) -> float:
		#Compute the integer positions of the four surrounding points
		var qx0 = int(floor(x))
		var qx1 = qx0 + 1
		var qy0 = int(floor(y))
		var qy1 = qy0 + 1
		#Permutate values to get indices to use with the gradient look-up tables
		var q00 = int(perm[(qy0 + perm[qx0 % 256]) % 256])
		var q01 = int(perm[(qy0 + perm[qx1 % 256]) % 256])
		var q10 = int(perm[(qy1 + perm[qx0 % 256]) % 256])
		var q11 = int(perm[(qy1 + perm[qx1 % 256]) % 256])
		#Vectors from the four points to the input point
		var tx0 = x - floor(x)
		var tx1 = tx0 - 1
		var ty0 = y - floor(y)
		var ty1 = ty0 - 1
		#Dot-product between the vectors and the gradients
		var v00 = gx[q00] * tx0 + gy[q00] * ty0
		var v01 = gx[q01] * tx1 + gy[q01] * ty0
		var v10 = gx[q10] * tx0 + gy[q10] * ty1
		var v11 = gx[q11] * tx1 + gy[q11] * ty1
		#Bi-cubic interpolation
		var wx = (3 - 2 * tx0) * tx0 * tx0
		var v0 = v00 - wx * (v00 - v01)
		var v1 = v10 - wx * (v10 - v11)

		var wy = (3 - 2 * ty0) * ty0 * ty0
		var v = v0 - wy * (v0 - v1)
		return v