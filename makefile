test_assign1_1: test_assign1_1.c storage_mgr.c dberror.c
	gcc -o test_assign1_1.o test_assign1_1.c storage_mgr.c dberror.c

test_assign1_2: test_assign1_2.c storage_mgr.c dberror.c
	gcc -o test_assign1_2.o test_assign1_2.c storage_mgr.c dberror.c

.PHONY: clean
clean:
	rm -f test_assign1_1.o
	rm -f test_assign1_2.o