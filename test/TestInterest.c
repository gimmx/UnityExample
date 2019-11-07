#include "unity.h"
#include "interest.h"

void setUp(void){
}

void tearDown(void){
}

void test_GiveDoubleValue(void){
	TEST_ASSERT_EQUAL_INT(10, doubleMe(5));
}

int main(void){
	UNITY_BEGIN();
	RUN_TEST(test_GiveDoubleValue);
	return UNITY_END();
}

