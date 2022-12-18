#include "iterate_grid.h"

long manhatten_dist(long x1, long y1, long x2, long y2) {
    return abs(x1 - x2) + (y1 - y2);
}

long* possible_beacon(long upper_limit, int n_sensors, long* sensors_with_dist) {
    for(long y = 0; y <= upper_limit; y++) {
        for(long x = 0; x <= upper_limit; x++) {
            bool covered = false;
            for(int i = 0; i < n_sensors; i ++) {
                long* sensor_with_dist = sensors_with_dist[i];
                long x = sensor_with_dist[0];
                long y = sensor_with_dist[1];
                long dist = sensor_with_dist[2];
                if dist > 
            }
        }
    }
}
