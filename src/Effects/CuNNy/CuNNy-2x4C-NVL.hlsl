// CuNNy 2x4C BILINEAR RGB NVL - https://github.com/funnyplanter/CuNNy

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// 
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

//!MAGPIE EFFECT
//!VERSION 4
//!SORT_NAME CuNNy-D04N02
//!USE FP16, MulAdd

#include "..\StubDefs.hlsli"

//!TEXTURE
Texture2D INPUT;

//!TEXTURE
//!WIDTH INPUT_WIDTH * 2
//!HEIGHT INPUT_HEIGHT * 2
Texture2D OUTPUT;

//!SAMPLER
//!FILTER POINT
SamplerState SP;

//!SAMPLER
//!FILTER LINEAR
SamplerState SL;

//!COMMON
#define O(t, p) t.SampleLevel(SP, pos + p * pt, 0)
#define V4 MF4
#define M4 MF4x4

//!TEXTURE
//!WIDTH INPUT_WIDTH
//!HEIGHT INPUT_HEIGHT
//!FORMAT R8G8B8A8_SNORM
Texture2D t0;

//!TEXTURE
//!WIDTH INPUT_WIDTH
//!HEIGHT INPUT_HEIGHT
//!FORMAT R8G8B8A8_SNORM
Texture2D t1;

//!PASS 1
//!DESC in
//!BLOCK_SIZE 8
//!NUM_THREADS 64
//!IN INPUT
//!OUT t0

#define l0(x, y) (dot(MF3(-6.049e-01, -1.145e+00, -2.540e-01), O(INPUT, float2(x, y)).rgb) + MF(1.794e+00))

V4 f0(MF s0_0, MF s0_1, MF s0_2, MF s0_3, MF s0_4, MF s0_5, MF s0_6, MF s0_7, MF s0_8) {
	V4 r = { 4.440e-03, -1.956e-04, 1.215e-03, 1.790e-03 };
	r = mad(s0_0, V4(1.411e-01, -9.763e-03, -1.361e-01, -9.610e-04), r);
	r = mad(s0_1, V4(6.068e-02, 7.238e-03, -1.182e-01, -1.535e-02), r);
	r = mad(s0_2, V4(-8.549e-02, -2.876e-03, -8.740e-03, 1.652e-02), r);
	r = mad(s0_3, V4(-3.249e-01, 5.392e-02, -8.518e-02, -7.437e-03), r);
	r = mad(s0_4, V4(2.435e-02, -6.191e-01, 7.147e-01, 5.862e-01), r);
	r = mad(s0_5, V4(1.968e-01, 1.868e-02, -1.723e-01, -5.801e-01), r);
	r = mad(s0_6, V4(1.528e-01, -4.489e-02, 5.871e-03, 4.528e-03), r);
	r = mad(s0_7, V4(-4.619e-01, 6.152e-01, -1.313e-01, -5.326e-02), r);
	r = mad(s0_8, V4(2.902e-01, -1.801e-02, -6.907e-02, 5.105e-02), r);
	return r;
}

void Pass1(uint2 blockStart, uint3 tid) {
	float2 pt = float2(GetInputPt());
	uint2 gxy = Rmp8x8(tid.x) + blockStart;
	uint2 size = GetInputSize();
	if (gxy.x >= size.x || gxy.y >= size.y) {
		return;
	}
	float2 pos = (gxy + 0.5) * pt;

	MF s0_0 = l0(-1.0, -1.0);
	MF s0_1 = l0(0.0, -1.0);
	MF s0_2 = l0(1.0, -1.0);
	MF s0_3 = l0(-1.0, 0.0);
	MF s0_4 = l0(0.0, 0.0);
	MF s0_5 = l0(1.0, 0.0);
	MF s0_6 = l0(-1.0, 1.0);
	MF s0_7 = l0(0.0, 1.0);
	MF s0_8 = l0(1.0, 1.0);

	t0[gxy] = f0(s0_0, s0_1, s0_2, s0_3, s0_4, s0_5, s0_6, s0_7, s0_8);
}

//!PASS 2
//!DESC conv1
//!BLOCK_SIZE 8
//!NUM_THREADS 64
//!IN t0
//!OUT t1

#define l0(x, y) V4(O(t0, float2(x, y)))

V4 f0(V4 s0_0, V4 s0_1, V4 s0_2, V4 s0_3, V4 s0_4, V4 s0_5, V4 s0_6, V4 s0_7, V4 s0_8, V4 s1_0, V4 s1_1, V4 s1_2, V4 s1_3, V4 s1_4, V4 s1_5, V4 s1_6, V4 s1_7, V4 s1_8) {
	V4 r = { 3.566e-03, 2.403e-03, -1.451e-03, 4.304e-03 };
	r = MulAdd(s0_0, M4(1.120e-01, 8.150e-03, 7.146e-02, -4.942e-02, 3.623e-01, -1.678e-01, 1.189e-01, 1.372e-01, 1.225e-01, -2.568e-02, 6.959e-02, 1.788e-02, 1.962e-01, -1.870e-01, -6.548e-03, -4.334e-02), r);
	r = MulAdd(s0_1, M4(1.805e-01, 4.881e-02, -2.342e-03, 2.035e-02, -2.427e-01, -2.197e-02, -2.036e-02, 3.919e-01, -3.037e-01, 7.047e-02, 3.426e-02, -8.694e-02, 2.144e-01, 1.431e-01, -7.851e-02, 2.247e-01), r);
	r = MulAdd(s0_2, M4(6.328e-02, -4.140e-02, 3.362e-02, 5.204e-02, -1.052e-01, 1.698e-01, -2.727e-03, 1.110e-01, 7.156e-02, -1.108e-02, -2.717e-02, 5.680e-02, -6.118e-02, 2.435e-02, 1.743e-02, 8.179e-02), r);
	r = MulAdd(s0_3, M4(1.557e-01, 1.189e-01, 8.836e-02, 2.178e-02, -3.954e-01, 2.466e-01, -2.166e-01, -7.051e-02, -2.857e-01, -1.611e-02, -8.667e-02, 1.895e-04, 2.744e-01, 1.499e-01, 8.228e-02, 2.938e-02), r);
	r = MulAdd(s0_4, M4(2.441e-01, -3.694e-01, 1.751e-01, 6.833e-01, -1.087e-01, -2.065e-01, -1.557e-01, -6.945e-02, -1.403e-02, 2.171e-02, 3.748e-02, 2.646e-01, -3.718e-01, -1.188e-01, 1.569e-01, 8.554e-02), r);
	r = MulAdd(s0_5, M4(-5.069e-02, 2.646e-01, -5.754e-02, -3.545e-01, 1.404e-01, 1.123e-01, 4.577e-02, -1.465e-01, -2.119e-02, -1.115e-02, 1.661e-01, -4.029e-01, -2.123e-01, 2.774e-01, -1.905e-02, -1.093e-02), r);
	r = MulAdd(s0_6, M4(2.593e-02, -1.801e-02, 9.053e-02, -2.721e-02, 6.658e-03, 3.802e-02, -3.282e-02, -1.116e-01, 1.201e-01, 2.095e-02, -2.061e-02, 2.498e-03, -1.831e-01, -1.743e-01, 1.062e-01, -6.113e-01), r);
	r = MulAdd(s0_7, M4(-1.172e-01, -1.130e-02, -6.727e-02, 7.753e-02, -3.958e-03, -9.790e-02, -1.635e-01, 1.049e-01, 2.862e-01, -2.733e-02, -1.566e-01, -2.900e-01, -1.050e-01, -3.441e-01, -8.690e-02, 8.659e-02), r);
	r = MulAdd(s0_8, M4(2.145e-01, 4.613e-02, 1.590e-02, -4.749e-02, 3.291e-01, 1.012e-01, 8.647e-03, -2.282e-01, 2.215e-01, 1.713e-01, 1.414e-01, -3.916e-01, -2.488e-01, 1.458e-01, 2.518e-02, -9.979e-02), r);
	r = MulAdd(s1_0, M4(-2.127e-02, 3.575e-02, 9.372e-02, -2.662e-02, 4.467e-02, 1.304e-02, 3.849e-02, 5.186e-02, 7.417e-02, 3.647e-02, 4.960e-02, -3.988e-02, -3.998e-02, 1.173e-01, 7.752e-03, -2.263e-02), r);
	r = MulAdd(s1_1, M4(-1.283e-01, -1.460e-01, 1.963e-02, -1.108e-01, -4.171e-01, 2.397e-01, -5.886e-02, 7.788e-02, -2.820e-02, -1.719e-01, 9.334e-03, -1.255e-01, 1.392e-01, 9.532e-03, -5.163e-02, 8.641e-02), r);
	r = MulAdd(s1_2, M4(-1.889e-01, 1.933e-01, 5.574e-02, 6.723e-02, -1.015e-01, -3.316e-01, -1.460e-02, -1.606e-01, 1.052e-01, 1.027e-02, -4.626e-02, 5.368e-02, -9.160e-03, -9.514e-02, 2.577e-02, 7.122e-02), r);
	r = MulAdd(s1_3, M4(-1.958e-01, 1.276e-01, 7.303e-02, -1.135e-01, -2.277e-01, 2.017e-01, -5.223e-02, 1.379e-01, -1.737e-01, 4.871e-02, -8.142e-02, 1.392e-01, 8.113e-02, 4.415e-01, -1.174e-01, 1.910e-02), r);
	r = MulAdd(s1_4, M4(-3.233e-01, -4.158e-01, 8.391e-02, 2.017e-01, 9.790e-02, -4.865e-02, -2.172e-01, 2.607e-01, -2.458e-01, -4.931e-01, 3.016e-01, 2.198e-01, -7.173e-02, -5.683e-01, -7.447e-02, -1.264e-01), r);
	r = MulAdd(s1_5, M4(-4.189e-01, 3.271e-01, 8.844e-02, -5.295e-01, 6.365e-02, -1.513e-01, 1.246e-02, -2.005e-01, 1.764e-01, 5.796e-01, 7.286e-02, -1.428e-01, -1.130e-01, -6.883e-02, -1.303e-02, -1.091e-01), r);
	r = MulAdd(s1_6, M4(-6.621e-02, 9.901e-03, 9.472e-02, -3.568e-02, 1.067e-01, -3.318e-02, 3.152e-01, -5.261e-02, 1.108e-01, 7.081e-02, -1.289e-01, 6.477e-03, 1.036e-01, -1.477e-03, 1.035e+00, -9.204e-02), r);
	r = MulAdd(s1_7, M4(-2.721e-01, -5.458e-02, -1.707e-01, -1.096e-02, -1.302e-01, -9.074e-02, 1.694e-01, 6.307e-02, 4.233e-01, -5.112e-02, -3.545e-01, -2.589e-01, 8.276e-02, -3.975e-01, 7.705e-02, 4.482e-01), r);
	r = MulAdd(s1_8, M4(1.175e-01, 2.212e-03, 5.751e-02, -8.666e-02, 2.532e-01, 1.303e-01, 7.291e-02, -2.126e-01, 4.815e-01, 1.649e-01, -4.748e-02, -3.330e-01, -1.252e-01, -8.987e-03, -4.285e-03, -1.106e-01), r);
	return r;
}

void Pass2(uint2 blockStart, uint3 tid) {
	float2 pt = float2(GetInputPt());
	uint2 gxy = Rmp8x8(tid.x) + blockStart;
	uint2 size = GetInputSize();
	if (gxy.x >= size.x || gxy.y >= size.y) {
		return;
	}
	float2 pos = (gxy + 0.5) * pt;

	V4 s0_0 = l0(-1.0, -1.0);
	V4 s0_1 = l0(0.0, -1.0);
	V4 s0_2 = l0(1.0, -1.0);
	V4 s0_3 = l0(-1.0, 0.0);
	V4 s0_4 = l0(0.0, 0.0);
	V4 s0_5 = l0(1.0, 0.0);
	V4 s0_6 = l0(-1.0, 1.0);
	V4 s0_7 = l0(0.0, 1.0);
	V4 s0_8 = l0(1.0, 1.0);
	V4 s1_0 = -max(-s0_0, 0.0);
	V4 s1_1 = -max(-s0_1, 0.0);
	V4 s1_2 = -max(-s0_2, 0.0);
	V4 s1_3 = -max(-s0_3, 0.0);
	V4 s1_4 = -max(-s0_4, 0.0);
	V4 s1_5 = -max(-s0_5, 0.0);
	V4 s1_6 = -max(-s0_6, 0.0);
	V4 s1_7 = -max(-s0_7, 0.0);
	V4 s1_8 = -max(-s0_8, 0.0);
	s0_0 = max(s0_0, 0.0);
	s0_1 = max(s0_1, 0.0);
	s0_2 = max(s0_2, 0.0);
	s0_3 = max(s0_3, 0.0);
	s0_4 = max(s0_4, 0.0);
	s0_5 = max(s0_5, 0.0);
	s0_6 = max(s0_6, 0.0);
	s0_7 = max(s0_7, 0.0);
	s0_8 = max(s0_8, 0.0);

	t1[gxy] = f0(s0_0, s0_1, s0_2, s0_3, s0_4, s0_5, s0_6, s0_7, s0_8, s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8);
}

//!PASS 3
//!DESC conv2
//!BLOCK_SIZE 8
//!NUM_THREADS 64
//!IN t1
//!OUT t0

#define l0(x, y) V4(O(t1, float2(x, y)))

V4 f0(V4 s0_0, V4 s0_1, V4 s0_2, V4 s0_3, V4 s0_4, V4 s0_5, V4 s0_6, V4 s0_7, V4 s0_8, V4 s1_0, V4 s1_1, V4 s1_2, V4 s1_3, V4 s1_4, V4 s1_5, V4 s1_6, V4 s1_7, V4 s1_8) {
	V4 r = { 5.508e-03, 4.690e-03, -5.708e-04, -7.674e-03 };
	r = MulAdd(s0_0, M4(-1.173e-02, 2.762e-03, -2.225e-03, -6.814e-03, 8.328e-02, -1.275e-02, 6.091e-02, -6.470e-02, -6.067e-02, -1.086e-01, 7.501e-02, 1.227e-01, -1.551e-02, -1.728e-02, -2.694e-02, 7.490e-02), r);
	r = MulAdd(s0_1, M4(5.326e-02, 1.003e-02, 3.989e-02, -1.908e-03, -4.580e-02, -4.303e-03, 4.333e-02, 8.324e-02, 8.170e-01, 8.040e-01, -3.975e-01, -1.034e+00, 1.362e-01, 3.776e-04, -1.102e-02, -5.030e-02), r);
	r = MulAdd(s0_2, M4(-6.068e-02, 6.212e-02, -4.979e-02, 9.626e-03, 1.301e-02, -2.045e-02, 1.798e-02, 2.091e-02, -2.290e-01, 3.612e-01, -7.014e-02, 1.669e-01, -5.191e-03, 1.304e-02, 9.444e-05, -2.137e-02), r);
	r = MulAdd(s0_3, M4(-3.235e-02, -6.238e-02, 3.894e-02, 5.893e-02, -3.530e-02, -1.063e-01, 8.668e-02, 1.232e-02, -3.851e-02, 2.952e-02, 6.132e-02, -5.755e-02, 8.317e-02, 8.340e-02, -8.227e-02, 6.481e-03), r);
	r = MulAdd(s0_4, M4(2.118e-02, 2.725e-01, -1.393e-01, -2.377e-01, 4.872e-01, 2.235e-01, -1.746e-02, -3.662e-01, -3.945e-01, -1.862e-01, -9.132e-02, 8.777e-02, -5.084e-01, -3.300e-01, -3.443e-02, 4.203e-01), r);
	r = MulAdd(s0_5, M4(1.165e-01, -1.743e-01, 4.169e-03, -1.518e-01, 1.174e-01, -3.314e-02, 2.295e-02, -9.160e-02, -1.854e-01, -6.999e-02, -6.985e-02, 4.875e-04, -1.147e-01, 1.722e-01, -2.588e-02, 1.185e-01), r);
	r = MulAdd(s0_6, M4(-8.881e-03, 1.907e-03, 9.002e-03, 8.085e-03, -8.728e-03, -1.074e-01, 7.035e-02, 6.519e-02, 4.323e-02, -4.675e-02, 4.382e-02, 1.091e-02, 3.357e-02, 4.384e-02, -8.031e-03, -1.945e-02), r);
	r = MulAdd(s0_7, M4(-7.981e-02, 1.492e-02, -9.399e-02, -3.750e-02, -1.274e-01, -3.235e-02, -3.169e-02, 6.420e-02, 4.304e-02, 9.302e-02, 1.250e-02, 3.906e-03, 1.752e-01, -1.211e-02, 9.058e-02, -6.273e-02), r);
	r = MulAdd(s0_8, M4(-1.290e-02, -4.309e-02, 3.384e-02, 3.819e-02, -3.309e-02, 3.986e-02, 3.783e-03, 5.361e-02, 5.473e-02, 1.574e-02, -2.385e-02, -7.630e-02, -1.778e-02, 1.375e-02, -2.936e-02, -1.778e-02), r);
	r = MulAdd(s1_0, M4(1.219e-01, 1.166e-02, -5.932e-02, 1.191e-02, -2.487e-03, -5.945e-02, 6.637e-02, 5.775e-02, -1.705e-02, 5.538e-02, -5.130e-02, -3.602e-02, 5.461e-02, -1.253e-01, 6.953e-02, 1.066e-01), r);
	r = MulAdd(s1_1, M4(6.504e-01, -9.638e-01, 1.371e+00, 5.682e-02, 1.583e-02, -2.371e-02, 5.201e-02, 3.845e-02, 3.478e-02, -1.477e-01, 1.763e-01, 5.129e-02, 2.992e-01, -3.335e-01, 2.490e-02, 4.873e-01), r);
	r = MulAdd(s1_2, M4(2.415e-02, 8.838e-02, -1.519e-01, 9.012e-02, -6.676e-02, 3.422e-02, -2.380e-02, 5.608e-02, -1.744e-01, -9.595e-02, -7.627e-02, -5.823e-02, -9.466e-02, 5.554e-02, -1.024e-01, -1.763e-01), r);
	r = MulAdd(s1_3, M4(8.380e-02, -7.972e-02, 8.813e-02, 3.371e-02, 5.392e-03, 4.385e-02, 1.207e-02, -5.728e-02, -3.427e-03, -2.027e-03, 1.211e-03, -7.897e-03, 3.360e-02, 4.603e-02, -1.240e-02, -2.219e-02), r);
	r = MulAdd(s1_4, M4(-6.699e-01, -3.512e-01, -2.153e-01, 3.218e-01, -5.100e-01, 4.324e-03, 2.713e-01, -2.073e-01, 1.547e-01, -2.123e-03, 7.928e-02, -5.698e-02, 2.450e-02, -4.866e-02, 9.436e-02, 7.900e-02), r);
	r = MulAdd(s1_5, M4(1.609e-01, -7.910e-02, 1.112e-01, -2.959e-02, -3.877e-01, -2.803e-01, -1.071e-01, -6.881e-03, 1.922e-02, 2.433e-02, -3.581e-02, -5.264e-02, -3.287e-01, -1.037e-02, -6.159e-02, 8.219e-02), r);
	r = MulAdd(s1_6, M4(-4.263e-02, -6.372e-02, 2.607e-02, 5.285e-02, -6.156e-02, -7.837e-02, 7.299e-03, 8.959e-02, -8.706e-03, -1.642e-02, 1.825e-02, 1.850e-02, 2.735e-02, 2.413e-02, -3.236e-02, -9.612e-03), r);
	r = MulAdd(s1_7, M4(-5.849e-02, 1.530e-01, -6.767e-02, -1.392e-02, -3.430e-01, -1.851e-01, -1.013e-01, 2.465e-01, -1.715e-02, 4.970e-03, -1.850e-02, -4.214e-03, 1.889e-02, -5.787e-02, 7.154e-02, 9.237e-02), r);
	r = MulAdd(s1_8, M4(-2.084e-02, -2.484e-01, 5.767e-02, -2.550e-02, -9.126e-02, 4.292e-01, 1.983e-02, 2.979e-01, -3.807e-03, -3.367e-03, 1.835e-03, 8.694e-03, -9.074e-02, 4.820e-02, -2.886e-02, 5.975e-02), r);
	return r;
}

void Pass3(uint2 blockStart, uint3 tid) {
	float2 pt = float2(GetInputPt());
	uint2 gxy = Rmp8x8(tid.x) + blockStart;
	uint2 size = GetInputSize();
	if (gxy.x >= size.x || gxy.y >= size.y) {
		return;
	}
	float2 pos = (gxy + 0.5) * pt;

	V4 s0_0 = l0(-1.0, -1.0);
	V4 s0_1 = l0(0.0, -1.0);
	V4 s0_2 = l0(1.0, -1.0);
	V4 s0_3 = l0(-1.0, 0.0);
	V4 s0_4 = l0(0.0, 0.0);
	V4 s0_5 = l0(1.0, 0.0);
	V4 s0_6 = l0(-1.0, 1.0);
	V4 s0_7 = l0(0.0, 1.0);
	V4 s0_8 = l0(1.0, 1.0);
	V4 s1_0 = -max(-s0_0, 0.0);
	V4 s1_1 = -max(-s0_1, 0.0);
	V4 s1_2 = -max(-s0_2, 0.0);
	V4 s1_3 = -max(-s0_3, 0.0);
	V4 s1_4 = -max(-s0_4, 0.0);
	V4 s1_5 = -max(-s0_5, 0.0);
	V4 s1_6 = -max(-s0_6, 0.0);
	V4 s1_7 = -max(-s0_7, 0.0);
	V4 s1_8 = -max(-s0_8, 0.0);
	s0_0 = max(s0_0, 0.0);
	s0_1 = max(s0_1, 0.0);
	s0_2 = max(s0_2, 0.0);
	s0_3 = max(s0_3, 0.0);
	s0_4 = max(s0_4, 0.0);
	s0_5 = max(s0_5, 0.0);
	s0_6 = max(s0_6, 0.0);
	s0_7 = max(s0_7, 0.0);
	s0_8 = max(s0_8, 0.0);

	t0[gxy] = f0(s0_0, s0_1, s0_2, s0_3, s0_4, s0_5, s0_6, s0_7, s0_8, s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8);
}

//!PASS 4
//!DESC out-shuffle
//!BLOCK_SIZE 16
//!NUM_THREADS 64
//!IN INPUT, t0
//!OUT OUTPUT

#define l0(x, y) V4(O(t0, float2(x, y)))

V4 f0(V4 s0_0, V4 s0_1, V4 s0_2, V4 s0_3, V4 s0_4, V4 s0_5, V4 s0_6, V4 s0_7, V4 s0_8, V4 s1_0, V4 s1_1, V4 s1_2, V4 s1_3, V4 s1_4, V4 s1_5, V4 s1_6, V4 s1_7, V4 s1_8) {
	V4 r = { -1.734e-03, -1.825e-03, -1.635e-03, -1.665e-03 };
	r = MulAdd(s0_0, M4(-1.841e-04, -5.677e-02, 9.249e-03, -8.726e-03, 4.041e-02, -1.295e-01, 1.154e-01, 2.765e-02, 1.833e-01, -8.427e-02, 1.078e-01, -1.432e-01, 1.068e-01, -1.222e-01, 2.535e-02, 5.316e-02), r);
	r = MulAdd(s0_1, M4(-3.609e-03, 5.812e-02, -4.650e-02, -2.093e-02, -3.442e-02, 7.643e-02, 1.424e-02, 7.195e-02, 1.552e-01, -8.291e-01, 1.547e-01, 4.354e-01, -2.851e-02, 1.023e-01, -8.481e-03, -6.567e-02), r);
	r = MulAdd(s0_2, M4(1.724e-02, -1.165e-02, 1.007e-02, -3.008e-02, -9.814e-04, -2.007e-02, -5.905e-03, 6.714e-03, -1.736e-01, 2.035e-01, -1.333e-01, 1.250e-01, -9.118e-03, -4.989e-02, 2.142e-02, -4.038e-03), r);
	r = MulAdd(s0_3, M4(7.885e-02, -8.350e-02, -6.025e-03, -1.139e-01, -8.380e-02, -6.836e-02, -5.589e-01, -4.614e-01, -6.742e-01, 2.118e-01, -4.442e-01, 2.197e-01, -5.873e-02, 1.902e-01, -4.687e-01, -4.712e-01), r);
	r = MulAdd(s0_4, M4(-4.506e-01, 2.396e-01, -1.350e-02, 4.072e-01, 3.249e-01, 9.930e-02, 1.576e-02, -2.456e-01, 1.506e+00, 6.047e-02, 8.841e-01, -1.927e+00, -4.337e-01, -5.801e-01, 3.334e-01, 8.276e-02), r);
	r = MulAdd(s0_5, M4(5.049e-02, -1.870e-01, 7.413e-02, -2.569e-02, -2.152e-02, 1.139e-01, -3.874e-02, 1.634e-02, -1.325e-01, 4.002e-02, -1.874e-01, 1.204e-01, 2.267e-02, 1.380e-02, -1.055e-02, 5.504e-02), r);
	r = MulAdd(s0_6, M4(-2.855e-02, 1.255e-02, 3.941e-02, 4.466e-03, 4.814e-05, -9.003e-03, 1.231e-01, 5.676e-02, 5.020e-02, -5.407e-02, -1.951e-01, 4.240e-02, 3.525e-02, -1.021e-01, 4.517e-01, 2.399e-01), r);
	r = MulAdd(s0_7, M4(-5.781e-02, -4.964e-02, -3.981e-01, -1.716e-01, 3.430e-02, -1.644e-02, 2.352e-01, 1.938e-01, 1.266e-01, -1.061e-01, 7.754e-01, 5.337e-01, 2.664e-01, 3.669e-01, -1.113e+00, -1.742e-01), r);
	r = MulAdd(s0_8, M4(2.948e-02, 3.723e-02, 2.739e-02, -5.215e-02, -1.542e-02, -2.173e-02, -1.944e-02, 1.856e-02, -4.535e-02, 1.163e-02, -5.014e-02, 8.660e-02, 1.421e-01, 2.314e-01, 1.171e-02, -4.975e-01), r);
	r = MulAdd(s1_0, M4(-4.408e-02, -3.573e-02, 3.842e-02, 2.571e-02, 2.872e-01, -4.960e-01, 2.569e-01, -6.254e-02, 2.158e-02, -6.452e-02, 7.495e-02, 1.997e-02, 4.094e-02, -9.741e-02, 3.542e-02, -8.115e-03), r);
	r = MulAdd(s1_1, M4(3.480e-02, 1.949e-04, 1.780e-02, 4.483e-02, -2.814e-01, 4.229e-01, -5.482e-02, 1.512e-02, -3.120e-02, 3.945e-02, 4.626e-02, 7.013e-02, -6.686e-03, 5.832e-02, -4.408e-02, -1.262e-02), r);
	r = MulAdd(s1_2, M4(-9.847e-03, 1.973e-03, 1.457e-02, 2.290e-02, 4.741e-02, 2.270e-02, 8.902e-04, 1.152e-02, -2.473e-02, -1.948e-02, -3.475e-03, 4.431e-02, 2.044e-02, 1.571e-04, 9.470e-03, -2.825e-02), r);
	r = MulAdd(s1_3, M4(5.918e-02, -1.939e-02, -4.628e-02, -7.774e-02, -3.040e-01, 8.634e-02, -5.254e-01, -6.906e-01, -1.218e-01, -6.178e-02, -3.115e-01, -2.697e-01, -2.402e-02, -2.149e-02, -3.878e-01, -3.453e-01), r);
	r = MulAdd(s1_4, M4(2.920e-01, 3.711e-01, -2.753e-01, -4.654e-02, 1.379e-01, 3.908e-01, -4.798e-01, 6.668e-01, 4.870e-01, -1.634e-01, -7.790e-02, -2.683e-01, -4.834e-01, -1.822e-02, -8.492e-03, 7.620e-02), r);
	r = MulAdd(s1_5, M4(-4.786e-02, 2.412e-02, 4.992e-02, -1.913e-01, 9.058e-02, -4.485e-02, 8.249e-02, -9.418e-02, 3.555e-02, 3.543e-01, -1.140e-01, -1.358e-01, 5.079e-02, -2.007e-01, 6.132e-02, -2.373e-03), r);
	r = MulAdd(s1_6, M4(6.553e-03, -7.804e-03, 8.569e-02, 4.875e-02, 5.085e-02, 1.728e-02, 6.949e-02, 1.313e-01, 1.825e-02, -5.557e-02, -7.548e-03, -5.534e-02, 7.059e-02, 4.382e-02, 2.807e-01, 1.919e-01), r);
	r = MulAdd(s1_7, M4(-1.071e-01, -3.709e-02, -4.757e-01, -1.943e-01, 8.182e-02, -3.334e-02, 4.170e-01, 6.716e-02, 1.563e-01, 1.382e-01, 7.441e-01, 4.082e-01, -9.101e-02, -3.943e-02, -5.142e-01, -1.910e-01), r);
	r = MulAdd(s1_8, M4(4.255e-03, 4.204e-02, 5.834e-02, -6.508e-02, -3.675e-02, 1.165e-02, -2.694e-02, -2.212e-02, -3.036e-02, -4.393e-02, 1.855e-03, 1.909e-01, 3.812e-02, 3.309e-02, 3.942e-02, -7.422e-02), r);
	return tanh(r);
}

void Pass4(uint2 blockStart, uint3 tid) {
	float2 pt = float2(GetInputPt());
	uint2 gxy = (Rmp8x8(tid.x) << 1) + blockStart;
	uint2 size = GetOutputSize();
	if (gxy.x >= size.x || gxy.y >= size.y) {
		return;
	}
	float2 pos = ((gxy >> 1) + 0.5) * pt;

	V4 s0_0 = l0(-1.0, -1.0);
	V4 s0_1 = l0(0.0, -1.0);
	V4 s0_2 = l0(1.0, -1.0);
	V4 s0_3 = l0(-1.0, 0.0);
	V4 s0_4 = l0(0.0, 0.0);
	V4 s0_5 = l0(1.0, 0.0);
	V4 s0_6 = l0(-1.0, 1.0);
	V4 s0_7 = l0(0.0, 1.0);
	V4 s0_8 = l0(1.0, 1.0);
	V4 s1_0 = -max(-s0_0, 0.0);
	V4 s1_1 = -max(-s0_1, 0.0);
	V4 s1_2 = -max(-s0_2, 0.0);
	V4 s1_3 = -max(-s0_3, 0.0);
	V4 s1_4 = -max(-s0_4, 0.0);
	V4 s1_5 = -max(-s0_5, 0.0);
	V4 s1_6 = -max(-s0_6, 0.0);
	V4 s1_7 = -max(-s0_7, 0.0);
	V4 s1_8 = -max(-s0_8, 0.0);
	s0_0 = max(s0_0, 0.0);
	s0_1 = max(s0_1, 0.0);
	s0_2 = max(s0_2, 0.0);
	s0_3 = max(s0_3, 0.0);
	s0_4 = max(s0_4, 0.0);
	s0_5 = max(s0_5, 0.0);
	s0_6 = max(s0_6, 0.0);
	s0_7 = max(s0_7, 0.0);
	s0_8 = max(s0_8, 0.0);

	V4 r = f0(s0_0, s0_1, s0_2, s0_3, s0_4, s0_5, s0_6, s0_7, s0_8, s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s1_8);

	static const MF3x3 rgb2yuv = { 0.299, 0.587, 0.114, -0.169, -0.331, 0.5, 0.5, -0.419, -0.081 };
	static const MF3x3 yuv2rgb = { 1, -0.00093, 1.401687, 1, -0.3437, -0.71417, 1, 1.77216, 0.00099 };
	float2 opt = float2(GetOutputPt());

	pos -= 0.5f * opt;
	MF3 yuv = mul(rgb2yuv, INPUT.SampleLevel(SL, pos, 0).rgb);
	OUTPUT[gxy] = MF4(mul(yuv2rgb, MF3(saturate(yuv.r + r.x), yuv.yz)), 1);

	++gxy.x;
	pos.x += opt.x;
	yuv = mul(rgb2yuv, INPUT.SampleLevel(SL, pos, 0).rgb);
	OUTPUT[gxy] = MF4(mul(yuv2rgb, MF3(saturate(yuv.r + r.y), yuv.yz)), 1);

	++gxy.y;
	pos.y += opt.y;
	yuv = mul(rgb2yuv, INPUT.SampleLevel(SL, pos, 0).rgb);
	OUTPUT[gxy] = MF4(mul(yuv2rgb, MF3(saturate(yuv.r + r.w), yuv.yz)), 1);

	--gxy.x;
	pos.x -= opt.x;
	yuv = mul(rgb2yuv, INPUT.SampleLevel(SL, pos, 0).rgb);
	OUTPUT[gxy] = MF4(mul(yuv2rgb, MF3(saturate(yuv.r + r.z), yuv.yz)), 1);
}
