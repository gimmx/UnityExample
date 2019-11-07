#include "unity.h"
#include "money.h"

void setUp(void){
}

void tearDown(void){
}

void test_AddTwoIntegers(void){
	TEST_ASSERT_EQUAL_INT(5, add(2,3));
}

void test_SubtractTwoIntegers(void){
	TEST_ASSERT_EQUAL_INT(6, sub(11,5));
}

void test_SubtractAgain(void){
	TEST_ASSERT_EQUAL_INT(-6, sub(5,11));
}

int main(void){
	UNITY_BEGIN();
	RUN_TEST(test_AddTwoIntegers);
	RUN_TEST(test_SubtractTwoIntegers);
	RUN_TEST(test_SubtractAgain);
	return UNITY_END();
}

