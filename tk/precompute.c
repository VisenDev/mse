#include <stdio.h>

int main(void) {
    int min = 8;
    int max = 256 * 256;  // This equals 65536

    // Loop from i = min to i < max
    #pragma omp parallel for
    for (int i = min; i < max; i++) {
        // Nested loop from j = min to j < max
        #pragma omp parallel for
        for (int j = min; j < max; j++) {
            // Calculate the division as a double
            double result = (double)i / j;
            // Print the result in the same format as the Tcl code
            printf("%d / %d = %f\n", i, j, result);
        }
    }

    return 0;
}
