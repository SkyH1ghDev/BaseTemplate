#include <gtest/gtest.h>

int main(int argc, char **argv) 
{
#ifdef WIN64
	_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF);
#endif
	::testing::InitGoogleTest(&argc, argv);
	return RUN_ALL_TESTS();
}