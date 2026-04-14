#include <stdio.h>
#include <dlfcn.h>
int main()
{  char op[10];
int a,b;
while(1)
{
    if(scanf("%s %d %d", op,&a,&b) == 3)
    {
        char library[20];
        snprintf(library,sizeof(library),"./lib%s.so",op);
        void* handle = dlopen(library, RTLD_LAZY);
        if(handle == NULL)
        {
            printf("Error\n");
            continue;
        }
        int (*func)(int, int);
        func = dlsym(handle, op);
        if (func == NULL) {
            dlclose(handle);
            printf("Error\n");
            continue;
        }
        int result = func(a, b);
        printf("%d\n", result);
        dlclose(handle);

    }
    else break;
}
return 0;
}