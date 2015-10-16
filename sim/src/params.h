#include "activation_fns.h"

#define TEST_PICS_DIR "digits_subset/"
#define NUM_IMAGES 3
#define OUTER_ITER 4000000
#define INNER_ITER 1
#define NUM_LAYERS 2
#define NEURONS_PER_TILE 64
#define LEARNING_RATE (1 << 13)
#define ACTIVATION_FN sigmoid_approx_fn
#define ACTIVATION_DRV sigmoid_approx_drv
//#define ACTIVATION_FN linear_fn
//#define ACTIVATION_DRV linear_drv



#define NORMAL    "\033[0m"
#define RED       "\033[31m"
#define GREEN     "\033[32m"
#define YELLOW    "\033[33m"
#define BLUE      "\033[34m"
#define MAGENTA   "\033[35m"
#define CYAN      "\033[36m"

#define BOLD      "\033[1m"
#define UNDERLINE "\033[4m"

#define KILL_LINE      "\033[K"
#define SAVE_CURSOR    "\033[s"
#define RESTORE_CURSOR "\033[u"

