From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 01 Feb 2017 14:52:41 +0100
Message-ID: <1993222.Sl7urNjWky@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] initify plugin crashes on arm allmodconfig
To: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, pageexec@freemail.hu, yamada.masahiro@socionext.com, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, sam@ravnborg.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On my ARM test builds (using a recent gcc-7 snapshot), allmodconfig failed with a compiler
crash, I have managed to minimize the test case to this:

/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-7.0.1 -O2 -Wall -fplugin=/home/arnd/arm-soc/build/tmp/scripts/gcc-plugins/initify_plugin.so -DINITIFY_PLUGIN -fplugin-arg-initify_plugin-search_init_exit_functions  -fno-inline-functions-called-once -S atmel_lcdfb.i
arm-linux-gnueabi-gcc-7.0.1: internal compiler error: Segmentation fault (program cc1)

struct {
  void *par;
} * c, g;
struct atmel_lcdfb_pdata {
  void (*atmel_lcdfb_power_control)();
};
int a, f;
void *d, *e;
int fn1();
inline void fn2(int *p1) {
  struct atmel_lcdfb_pdata *b = b;
  if (b)
    b->atmel_lcdfb_power_control();
  a = fn1();
}
int __attribute__((__section__(".init.text"))) fn3() {
  if (c)
    goto out;
  if (f)
    goto free_info;
  if (0)
    goto put_bus_clk;
  if (0)
    goto release_intmem;
  if (0)
    goto stop_clk;
  if (0)
    goto free_fb;
  if (e)
    goto release_mem;
  if (f)
    goto unmap_mmio;
  if (0)
    goto unregister_irqs;
  if (0)
    goto reset_drvdata;
  fn2(d);
reset_drvdata:
unregister_irqs:
unmap_mmio:
release_mem:
free_fb:
release_intmem:
stop_clk:
put_bus_clk:
free_info:
out:
  return 0;
}
int __attribute__((__section__(".exit.text"))) __attribute__((__cold__)) fn4() {
  fn2(g.par);
  return 0;
}


While trying to reproduce it, one time I ended up killing the gcc task when it
used more than 80 gigabytes (!) of memory after around six minutes of compiling
the same file (drivers/video/fbdev/atmel_lcdfb.c), but other times it just crashed
as above using various ARM cross compilers (4.9.3, 5.3, 6.1.1).

	Arnd
