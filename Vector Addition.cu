#include <stdio.h>

__global__ void add(int *a, int *b, int *c) {
    int index = threadIdx.x;
    c[index] = a[index] + b[index];
}

int main() {
    int size = 5;
    int h_a[size] = {1, 2, 3, 4, 5};
    int h_b[size] = {10, 20, 30, 40, 50};
    int h_c[size]; // Host array to store result

    int *d_a, *d_b, *d_c; // Device pointers

    // Allocate memory on the device
    cudaMalloc((void **)&d_a, size * sizeof(int));
    cudaMalloc((void **)&d_b, size * sizeof(int));
    cudaMalloc((void **)&d_c, size * sizeof(int));

    // Copy data from host to device
    cudaMemcpy(d_a, h_a, size * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, size * sizeof(int), cudaMemcpyHostToDevice);

    // Launch kernel with one block of size threads
    add<<<1, size>>>(d_a, d_b, d_c);

    // Copy result back from device to host
    cudaMemcpy(h_c, d_c, size * sizeof(int), cudaMemcpyDeviceToHost);

    // Print the result
    for (int i = 0; i < size; i++) {
        printf("%d + %d = %d\n", h_a[i], h_b[i], h_c[i]);
    }

    // Free device memory
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    
    cudaDeviceSynchronize();

    return 0;
}