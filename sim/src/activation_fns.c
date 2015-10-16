/*
 * Author: Kais Kudrolli
 *
 * Description: File containing C implementation of activation functions.
 * Formulas from: 
 * https://en.wikibooks.org/wiki/Artificial_Neural_Networks/Activation_Functions
 *
 */

#include <assert.h>
#include "activation_fns.h"

/********************
 * Helper Functions *
 ********************/

/*
 * ipow: Computes the integer exponentiation
 *
 * Parameters:
 *  - base: base val
 *  - exp: exponent val
 *
 * Return value:
 *  - base ^ exp
 */
uint32_t ipow(uint32_t base, uint32_t exp) 
{
  uint32_t ret;
  for (ret = 1; exp; exp >>= 1) {
    if (exp & 1) {
      ret = fmult(ret, base);
    }
    base = fmult(base, base);
  }

  return ret;
}

/********************
 * Libary Functions *
 ********************/

uint32_t fixed_mult(uint32_t a, uint32_t b)
{
    uint64_t a_64 = (uint64_t) a;
    uint64_t b_64 = (uint64_t) b;
    uint64_t c = a_64 * b_64;
    c = c >> 16;
    return (uint32_t) c;
}

uint32_t piecewise_sigmoid(uint32_t in) 
{
    if (in >= FIXED_5) {
        return FIXED_1;
    } else if ((in >= FIXED_2_375) && (in < FIXED_5)) {
        return fixed_mult(FIXED_0_03125, in) + FIXED_0_84375;
    } else if ((in >= FIXED_1) && (in < FIXED_2_375)) {
        return fixed_mult(FIXED_0_125, in) + FIXED_0_625;
    } else {
        return fixed_mult(FIXED_0_25, in) + FIXED_0_5;
    }
}

uint32_t sigmoid_approx_fn(uint32_t in)
{
    uint32_t sign = (in & 0x80000000) >> 31;
    //in = in & ~0x80000000;
    if (sign) {
        return FIXED_1 - piecewise_sigmoid(~in+1);  
    } else {
        return piecewise_sigmoid(in);
    }
}

uint32_t sigmoid_approx_drv(uint32_t in)
{
    return fixed_mult(sigmoid_approx_fn(in), (FIXED_1 - sigmoid_approx_fn(in)));
}

uint32_t step_fn(uint32_t in)
{
  return ((in < STEP_THRESHOLD) ? 0 : 1);
}

uint32_t lin_comb_fn(uint32_t in)
{
  return in + BIAS;
}

uint32_t log_sigmoid_fn(uint32_t in)
{
  // exp = -1 * B * in
  uint32_t exp = fmult(BETA_SLOPE_PARAM, in);
  uint32_t e_pow = ipow(E_NUM, exp);
  uint32_t denom = FIXED_1 + fdiv(FIXED_1, e_pow);
  assert(denom);
  uint32_t out = fdiv(FIXED_1, denom);
  return out;
}

uint32_t tan_sigmoid_fn(uint32_t in)
{
  uint32_t exp = ipow(E_NUM, in);
  uint32_t neg_exp = ipow(E_NUM, (uint32_t) ( (-1) * ((int32_t) in) ));
  uint32_t denom = exp + neg_exp;
  assert(denom);
  return (exp - neg_exp) / denom;
}

uint32_t linear_fn(uint32_t in) {
  if (!in) return 1;
  return (in > FIXED_1 << 5) ? 1 : (in > (16*FIXED_1)) ? (FIXED_1) : in / 16;
}

uint32_t log_sigmoid_drv(uint32_t in)
{
  // dF/dt = B * (F(B,in) * (1-F(B, in)))
  return fmult(fmult(BETA_SLOPE_PARAM, log_sigmoid_fn(in)),
	       (FIXED_1 - log_sigmoid_fn(in)));
}

uint32_t tan_sigmoid_drv(uint32_t in)
{
  return 1 - ipow(tan_sigmoid_fn(in), 2);
}

uint32_t linear_drv(uint32_t in) {
  if (!in) return 1;
  uint32_t out = ((int32_t)in < 0) ? 1 : (in > (16*FIXED_1)) ? 1 : FIXED_1 / 16;
  return out;
}
/*
int main (void) 
{
    assert(sigmoid_approx_fn(FIXED_1) == 0xc000);
    assert(sigmoid_approx_fn(FIXED_5) == 1<<16);
    assert(sigmoid_approx_fn(100 << 16) == 1<<16);
    assert(sigmoid_approx_fn(0) == FIXED_0_5);
    assert(sigmoid_approx_fn(0x2c000) == 0xee00); // x = 2.75
    assert(sigmoid_approx_fn(0x6000) == 0x9800); // x = 0.375
    assert(sigmoid_approx_fn(0x6000000) == 1<<16);
    assert(sigmoid_approx_fn(0x18000) == 0xd000); // x = 1.5
    assert(sigmoid_approx_fn(0xfffe8000) == 0x3000); // x = -1.5
    assert(sigmoid_approx_fn(0xffff0000) == 0x4000); // x = -1.0
    assert(sigmoid_approx_fn(0xffffe000) == 0x7800); // x = -0.125
    assert(sigmoid_approx_fn(0xfffd4000) == 0x1200); // x = -2.75
    assert(sigmoid_approx_fn(0xfffa0000) == 0x0000); // x = -6.0
    printf("Finished tests!\n");
    return 0;
}
int main (void) 
  {
  assert(ipow(1, 2) == 1);
  assert(ipow(0, 2) == 0);
  assert(ipow(145, 3) == 3048625);
  assert(ipow(2, 10) == 1024);
  assert(ipow(17, 2) == 289);
  printf("Finished tests!\n");
  return 0;
  }*/


