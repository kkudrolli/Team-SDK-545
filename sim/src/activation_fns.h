/*
 * Author: Kais Kudrolli
 *
 * Description: Header file for activation_fns.h. Contains definitions of various
 * actiavtion functions.
 *
 */

#ifndef _ACT_FNS_H_
#define _ACT_FNS_H_

#include "vector.h"

#define STEP_THRESHOLD   1      // For step function
#define BETA_SLOPE_PARAM 1      // For sigmoid
#define E_NUM            271828 // Fixed point, so no decimal point
#define BIAS             1      // For linear combination

/* Actiavtion functions */
uint32_t step_fn(uint32_t in);
uint32_t lin_comb_fn(uint32_t in);
uint32_t log_sigmoid_fn(uint32_t in);
uint32_t tan_sigmoid_fn(uint32_t in);
uint32_t linear_fn(uint32_t input);

/* Their derivatives */
uint32_t log_sigmoid_drv(uint32_t in);
uint32_t tan_sigmoid_drv(uint32_t in);




#endif
