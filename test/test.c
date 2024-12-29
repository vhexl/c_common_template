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

#include <stdio.h>

// Is run before every test, put unit init calls here.
void setUp(void)
{
}

// Is run after every test, put unit clean-up calls here.
void tearDown(void)
{
}

void test_case_template(void)
{
    printf("test_case_template\n");
}

int main(void)
{
    UNITY_BEGIN();
    RUN_TEST(test_case_template);
    return UNITY_END();
}
