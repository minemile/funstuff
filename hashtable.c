#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <math.h>

#define p 2000000011

typedef struct _bucket {
    long long a, b;
    int m;
    int *buf;
    int *mas;
} bucket;

typedef struct _hash_table {
    long long a, b;
    int m;
    bucket **bk;
} hash_table;

unsigned int hash(long long a, long long b, int m, int k) {
    unsigned int h = (unsigned) ((a * k + b) % p) % m;
    return h;
}

long long random() {
    long long nowRand;
    do {
        nowRand = (rand()%10000) + (rand()%10000)*1000*1ll + (rand()%4245)*10000*1ll*10000;
    } while (nowRand > p);
    return nowRand;
}

void find_h1(hash_table *hashtable, int *x) {
    int h, size = hashtable->m;
    int sum;
    long long a, b;
    int *collisions = malloc(size * sizeof(int));
    do {
        a = random(), b = random();
        sum = 0;
        for (int i = 0; i < size; i++) {
            collisions[i] = 0;
        }
        for (int i = 0; i < size; i++) {
            h = hash(a, b, size, x[i]);
            collisions[h] += 1;
        }
        for (int i = 0; i < size; i++) {
            sum += collisions[i] * collisions[i];
        }
    } while (sum >= 3 * size);
    hashtable->a = a;
    hashtable->b = b;
    for (int i = 0; i < size; i++) {
        if (collisions[i] > 0) {
            int Mi = collisions[i] * collisions[i];
            hashtable->bk[i] = malloc(sizeof(bucket));
            hashtable->bk[i]->buf = malloc(collisions[i] * sizeof(int));
            hashtable->bk[i]->m = Mi;
            hashtable->bk[i]->mas = malloc(Mi * sizeof(int));
        }
    }

    int *index = calloc((size_t) size, sizeof(int));

    for (int i = 0; i < size; i++) {
        h = hash(hashtable->a, hashtable->b, size, x[i]);
        hashtable->bk[h]->buf[index[h]] = x[i];
        index[h] += 1;
    }

    free(collisions);
    free(index);
}

void find_h2(hash_table *hashtable) {
    int h2, size_bk, sum, size = hashtable->m;
    long long a, b;
    for (int i = 0; i < size; i++) {
        if (hashtable->bk[i] == NULL)
            continue;
        size_bk = hashtable->bk[i]->m;
        if (hashtable->bk[i]->m == 1) {
            a = 0ll;
            b = 0ll;
        } else {
            int *cols = malloc(size_bk * sizeof(int));
            do {
                sum = 0;
                a = random(), b = random();
                for (int j = 0; j < size_bk; j++) {
                    cols[j] = 0;
                }
                for (int j = 0; j < sqrt(size_bk); j++) {
                    h2 = hash(a, b, size_bk, hashtable->bk[i]->buf[j]);
                    cols[h2] += 1;
                }
                for (int j = 0; j < size_bk; j++) {
                    sum += cols[j] * cols[j];
                }
            } while (sum != sqrt(size_bk));
            free(cols);
        }
        hashtable->bk[i]->a = a;
        hashtable->bk[i]->b = b;
        for (int j = 0; j < sqrt(size_bk); j++) {
            h2 = hash(hashtable->bk[i]->a, hashtable->bk[i]->b, size_bk, hashtable->bk[i]->buf[j]);
            hashtable->bk[i]->mas[h2] = hashtable->bk[i]->buf[j];
        }
        free(hashtable->bk[i]->buf);
    }
}

void delete_hashtable(hash_table *hashtable) {
    for (int i = 0; i < hashtable->m; i++) {
        if (hashtable->bk[i] != NULL) {
            free(hashtable->bk[i]->mas);
            free(hashtable->bk[i]);
        }
    }
    free(hashtable->bk);
    free(hashtable);
}

int Contains(hash_table *hashtable, int value) {
    int h1 = hash(hashtable->a, hashtable->b, hashtable->m, value);
    if (hashtable->bk[h1] == NULL) return 0;
    int h2 = hash(hashtable->bk[h1]->a, hashtable->bk[h1]->b, hashtable->bk[h1]->m, value);
    return (hashtable->bk[h1]->mas[h2] == value) ? 1 : 0;
}

hash_table *initialize(int *x, int size) {
    hash_table *hashtable = malloc(sizeof(hash_table));
    hashtable->bk = malloc(sizeof(bucket *) * size);
    hashtable->m = size;
    for (int i = 0; i < size; i++) {
        hashtable->bk[i] = NULL;
    }
    find_h1(hashtable, x);
    find_h2(hashtable);
    return hashtable;
}

int main(void) {
    srand(73);
    int *x = NULL, *y = NULL;
    int n = 0, q = 0, i = 0;
    scanf("%d", &n);
    x = (int *) malloc(n * sizeof(int));
    while (scanf("%d", &x[i++]) == 1 && i < n);

    scanf("%d", &q);
    y = (int *) malloc(q * sizeof(int));
    i = 0;
    while (scanf("%d", &y[i++]) == 1 && i < q);

    hash_table *hashtable = initialize(x, n);

    for (int j = 0; j < q; j++) {
        if (Contains(hashtable, y[j]) == 1)
            printf("Yes\n");
        else printf("No\n");
    }
    delete_hashtable(hashtable);
    free(x);
    free(y);
    return 0;
}