#include "activation_fns.h"

#define IMPORT
#define IMPORT_FILE "networks/blank.deep"

#define MODE_MNIST
#define INPUT_SIZE 28

#define TEST_PICS_DIR "test/"
#define NUM_IMAGES 1

#define MNIST_TRAIN_IMAGES 3
#define MNIST_TEST_IMAGES 3

#define OUTER_ITER 70
#define INNER_ITER 1
#define NUM_LAYERS 2
#define NEURONS_PER_TILE 128
#define LEARNING_RATE (1 << 13)

//#define ENABLE_TARGET_BIAS
#define TARGET_BIAS_OFFSET 5

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

