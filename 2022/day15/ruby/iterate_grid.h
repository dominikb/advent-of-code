#ifndef iterate_grid_h
#define iterate_grid_h

#include <stdbool.h>

long manhatten_dist(long x1, long y1, long x2, long y2);

long* possible_beacon(long upper_limit, long* sensors_with_dist);

#endif