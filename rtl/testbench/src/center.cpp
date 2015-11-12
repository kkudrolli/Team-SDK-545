#include "center.h"

vector_t center(vector_t image) {
  assert(image->length == 784);

  vector_t result = Vector(784);

  float xweight = 0, yweight = 0;
  float total_weight = 0;

  for (int i = 0; i < 28; i++) {
    for (int j = 0; j < 28; j++) {
      total_weight += ((float)(image->data[28*i+j]) / 256.0);
      xweight += ((float)(image->data[28*i+j]) / 256.0) * (13-i);
      yweight += ((float)(image->data[28*i+j]) / 256.0) * (13-j);
    }
  }

  xweight = xweight / total_weight;
  yweight = yweight / total_weight;
  
  int dx = round(xweight);
  int dy = round(yweight);
  
  for (int i = 0; i < 28; i++) {
    for (int j = 0; j < 28; j++) {
      if (i-dx < 28 && j-dy < 28 && i-dx > 0 && j-dy > 0)
	result->data[28*i+j] = image->data[28*(i-dx) + (j-dy)];
    }
  }
  
  vector_destroy(image);
  return result;
}
