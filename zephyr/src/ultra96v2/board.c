/*
 * Copyright (c) 2020, Antmicro
 *
 * SPDX-License-Identifier: Apache-2.0
 */
#include <zephyr/init.h>
#define MIO_PIN_0	0xff180000
#define MIO_PIN_1	0xff180004

#define MIO_DEFAULT	0x0
#define MIO_UART0	0xc0

static int mercury_xu_init(const struct device *port)
{
	/* pinmux settings for uart */
	sys_write32(MIO_UART0, MIO_PIN_0);
	sys_write32(MIO_UART0, MIO_PIN_1);

	ARG_UNUSED(port);
	return 0;
}

SYS_INIT(mercury_xu_init, PRE_KERNEL_2,
		CONFIG_KERNEL_INIT_PRIORITY_DEFAULT);
