From: Alexander Popov <alex.popov@linux.com>
Subject: Re: [PATCH 1/2] gcc-plugins: structleak: Generalize to all variable
 types
References: <20190212180441.15340-1-keescook@chromium.org>
 <20190212180441.15340-2-keescook@chromium.org>
Message-ID: <fe87367b-f196-e8b0-6028-6378b65e5240@linux.com>
Date: Tue, 12 Mar 2019 02:05:27 +0300
MIME-Version: 1.0
In-Reply-To: <20190212180441.15340-2-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Alexander Potapenko <glider@google.com>, kernel-hardening@lists.openwall.comArd Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Kees, hello everyone,

On 12.02.2019 21:04, Kees Cook wrote:
> Building with CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL should give the
> kernel complete initialization coverage of all stack variables passed
> by reference, including padding (see lib/test_stackinit.c).

I would like to note that new STRUCTLEAK_BYREF_ALL initializes *less* stack
variables than STACKINIT, that was introduced earlier:
https://www.openwall.com/lists/kernel-hardening/2019/01/23/3

Citing the patches:
- the STACKINIT plugin "attempts to perform unconditional initialization of all
stack variables";
- the STRUCTLEAK_BYREF_ALL feature "gives the kernel complete initialization
coverage of all stack variables passed by reference".

I.e. stack variables not passed by reference are not initialized by
STRUCTLEAK_BYREF_ALL.

Kees, what do you think about adding such cases to your lib/test_stackinit.c?
This simple example demonstrates the idea:


diff --git a/lib/test_stackinit.c b/lib/test_stackinit.c
index 13115b6..f9ef313 100644
--- a/lib/test_stackinit.c
+++ b/lib/test_stackinit.c
@@ -320,9 +320,18 @@ static noinline __init int leaf_switch_2_none(unsigned long sp, bool fill,
 DEFINE_TEST_DRIVER(switch_1_none, uint64_t, SCALAR);
 DEFINE_TEST_DRIVER(switch_2_none, uint64_t, SCALAR);

+struct x {
+       int x1;
+       int x2;
+       int x3;
+};
+
 static int __init test_stackinit_init(void)
 {
        unsigned int failures = 0;
+       struct x _x;
+
+       printk("uninitialized struct fields sum: %d\n", _x.x1 + _x.x2 + _x.x3);

 #define test_scalars(init)     do {                            \
                failures += test_u8_ ## init ();                \


Kernel output:
  root@vm:~# insmod /lib/modules/5.0.0+/kernel/lib/test_stackinit.ko
  [   40.534622] uninitialized struct fields sum: -727800841

Best regards,
Alexander
