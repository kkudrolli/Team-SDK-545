/*
 * Author: Kais Kudrolli
 *
 * Description: Header file for activation_fns.h. Contains definitions of various
 * actiavtion functions.
 *
 */

#ifndef _ACT_FNS_H_
#define _ACT_FNS_H_

#include <assert.h>
#include "vector.h"

#define STEP_THRESHOLD   1      // For step function
#define BETA_SLOPE_PARAM (1<<16)      // For sigmoid
#define E_NUM            0x2b7e1 // Fixed point, so no decimal point
#define BIAS             (1<<16)      // For linear combination
#define FIXED_1          (1<<16)

#define FIXED_5       (5<<16)
#define FIXED_1       (1<<16)
#define FIXED_2_375   0x26000
#define FIXED_0_84375 0x0D800
#define FIXED_0_03125 0x00800
#define FIXED_0_125   0x02000
#define FIXED_0_625   0x0A000
#define FIXED_0_25    0x04000
#define FIXED_0_5     0x08000

/* Actiavtion functions */
uint32_t sigmoid_approx_fn(uint32_t in);
uint32_t step_fn(uint32_t in);
uint32_t lin_comb_fn(uint32_t in);
uint32_t log_sigmoid_fn(uint32_t in);
uint32_t tan_sigmoid_fn(uint32_t in);
uint32_t linear_fn(uint32_t in);

/* Their derivatives */
uint32_t sigmoid_approx_drv(uint32_t in);
uint32_t log_sigmoid_drv(uint32_t in);
uint32_t tan_sigmoid_drv(uint32_t in);
uint32_t linear_drv(uint32_t in);

#endif
