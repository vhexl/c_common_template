/**
 * @file test.c
 * @author vhexl (visualHex@outlook.com)
 * @brief
 * @version 0.1
 * @date 2024-12-29
 *
 * SPDX-FileCopyrightText: Copyright (c) 2024
 * SPDX-License-Identifier: Apache-2.0
 *
 */

#include <unity.h>
#include <unity_memory.h>

#include <stdio.h>

// Is run before every test, put unit init calls here.
void setUp(void)
{
    UnityMalloc_StartTest();
}

// Is run after every test, put unit clean-up calls here.
void tearDown(void)
{
    UnityMalloc_EndTest();
}

void test_case_template(void)
{
    void *p = malloc(1);
    printf("test_case_template\n");
    free(p);
}

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_case_template);
    return UNITY_END();
}
