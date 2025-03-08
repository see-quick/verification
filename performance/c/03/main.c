#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>

#define N 10000000  // 10M elements

typedef struct Node {
    int key;
    struct Node* next;
} Node;

typedef struct {
    Node** buckets;
    int size;
} HashMap;

unsigned int hash(int key, int size) {
    return key % size;
}

void hashmap_insert(HashMap* map, int key) {
    unsigned int idx = hash(key, map->size);
    Node* new_node = malloc(sizeof(Node));
    new_node->key = key;
    new_node->next = map->buckets[idx];
    map->buckets[idx] = new_node;
}

bool hashmap_search(HashMap* map, int key) {
    unsigned int idx = hash(key, map->size);
    Node* curr = map->buckets[idx];
    while (curr) {
        if (curr->key == key) return true;
        curr = curr->next;
    }
    return false;
}

void hashmap_remove(HashMap* map, int key) {
    unsigned int idx = hash(key, map->size);
    Node* curr = map->buckets[idx];
    Node* prev = NULL;
    while (curr) {
        if (curr->key == key) {
            if (prev) prev->next = curr->next;
            else map->buckets[idx] = curr->next;
            free(curr);
            return;
        }
        prev = curr;
        curr = curr->next;
    }
}

void benchmark_array() {
    clock_t start, end;
    int* arr = malloc(N * sizeof(int));

    start = clock();
    for (int i = 0; i < N; i++) arr[i] = i;
    end = clock();
    printf("Array Insert: %.3f ms\n", 1000.0 * (end - start) / CLOCKS_PER_SEC);

    start = clock();
    for (int i = N - 1; i >= 0; i--) arr[i] = 0;
    end = clock();
    printf("Array Remove: %.3f ms\n", 1000.0 * (end - start) / CLOCKS_PER_SEC);

    free(arr);
}

void benchmark_hashmap() {
    clock_t start, end;
    HashMap map;
    map.size = N / 10;
    map.buckets = calloc(map.size, sizeof(Node*));

    start = clock();
    for (int i = 0; i < N; i++) hashmap_insert(&map, i);
    end = clock();
    printf("HashMap Insert: %.3f ms\n", 1000.0 * (end - start) / CLOCKS_PER_SEC);

    start = clock();
    for (int i = 0; i < N; i++) hashmap_remove(&map, i);
    end = clock();
    printf("HashMap Remove: %.3f ms\n", 1000.0 * (end - start) / CLOCKS_PER_SEC);

    free(map.buckets);
}

int main() {
    printf("Benchmarking C Data Structures with %d elements:\n", N);
    benchmark_array();
    benchmark_hashmap();
    return 0;
}
