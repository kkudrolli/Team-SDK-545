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
            ret *= base;
        }
        base *= base;
    }

    return ret;
}

/********************
 * Libary Functions *
 ********************/

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
    uint32_t exp = (uint32_t) ( (-1) * BETA_SLOPE_PARAM * ((int32_t) in) );
    uint32_t denom = 1 + ipow(E_NUM, exp);
    assert(denom);
    return 1 / denom;
}

uint32_t tan_sigmoid_fn(uint32_t in)
{
    uint32_t exp = ipow(E_NUM, in);
    uint32_t neg_exp = ipow(E_NUM, (uint32_t) ( (-1) * ((int32_t) in) ));
    uint32_t denom = exp + neg_exp;
    assert(denom);
    return (exp - neg_exp) / denom;
    
}

uint32_t log_sigmoid_drv(uint32_t in)
{
    // dF/dt = B * (F(B,in) * (1-F(B, in)))
    return BETA_SLOPE_PARAM * (log_sigmoid_fn(in) *
                               (1 - log_sigmoid_fn(in)));
}

uint32_t tan_sigmoid_drv(uint32_t in)
{
    return 1 - ipow(tan_sigmoid_fn(in), 2);
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
}


