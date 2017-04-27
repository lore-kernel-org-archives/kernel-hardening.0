MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <201704270938.I52YmjxT%fengguang.wu@intel.com>
References: <1493160997-126108-3-git-send-email-keescook@chromium.org> <201704270938.I52YmjxT%fengguang.wu@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 27 Apr 2017 13:22:05 -0700
Message-ID: <CAGXu5jKyZ954aRHg_7xhXP0CJBiJ8TV7y-dH5viwzfEj8+D6_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 2/2] x86, refcount: Implement fast refcount overflow protection
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 26, 2017 at 6:31 PM, kbuild test robot <lkp@intel.com> wrote:
> Hi Kees,
>
> [auto build test WARNING on next-20170424]
> [cannot apply to tip/x86/core linus/master linux/master v4.9-rc8 v4.9-rc7 v4.9-rc6 v4.11-rc8]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Kees-Cook/x86-refcount-Implement-fast-refcount-overflow/20170426-210530
> config: x86_64-allmodconfig (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> All warnings (new ones prefixed by >>):
>
>>> drivers//scsi/scsi_scan.o: warning: objtool: .text.refcount_overflow+0x5: special: can't find orig instruction

Hi Josh,

I'm seeing this error being generated on areas that are using a
cross-section exception handler. I can't quite see why the .o checker
is unhappy, so I figured I'd ask you first. :)

The code is generated with calls to __REFCOUNT_CHECK() which is
defined like this:

+#define __REFCOUNT_EXCEPTION(size)                     \
+       ".if "__stringify(size)" == 4\n\t"              \
+       ".pushsection .text.refcount_overflow\n"        \
+       ".elseif "__stringify(size)" == -4\n\t"         \
+       ".pushsection .text.refcount_underflow\n"       \
+       ".else\n"                                       \
+       ".error \"invalid size\"\n"                     \
+       ".endif\n"                                      \
+       "111:\tlea %[counter],%%"_ASM_CX"\n\t"          \
+       "int $"__stringify(X86_REFCOUNT_VECTOR)"\n"     \
+       "222:\n\t"                                      \
+       ".popsection\n"                                 \
+       "333:\n"                                        \
+       _ASM_EXTABLE(222b, 333b)
+
+#define __REFCOUNT_CHECK(size)                         \
+       "js 111f\n"                                     \
+       __REFCOUNT_EXCEPTION(size)
+
+#define __REFCOUNT_ERROR(size)                         \
+       "jmp 111f\n"                                    \
+       __REFCOUNT_EXCEPTION(size)

I assume it doesn't like seeing an exception split across .text and
.text.refcount_overflow, but I haven't been able to figure out how
that distinction would be made by the checker. :P

Thanks!

-Kees

> --
>    /kbuild/src/consumer/include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>>> drivers/scsi/qla2xxx/qla_target.o: warning: objtool: .text.refcount_overflow+0x23: special: can't find orig instruction
> --
>    /kbuild/src/consumer/include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>>> drivers/nvme/target/core.o: warning: objtool: .text.refcount_overflow+0x19: special: can't find orig instruction
> --
>    /kbuild/src/consumer/include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>>> drivers/nvme/target/rdma.o: warning: objtool: .text.refcount_overflow+0x5: special: can't find orig instruction
> --
>    /kbuild/src/consumer/include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>>> drivers/nvme/target/fcloop.o: warning: objtool: .text.refcount_overflow+0x6: special: can't find orig instruction
> --
>    /kbuild/src/consumer/include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>>> net/batman-adv/bat_v.o: warning: objtool: .text.refcount_underflow+0xc: special: can't find orig instruction
> --
>    /kbuild/src/consumer/include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>>> net/batman-adv/bat_v_elp.o: warning: objtool: .text.refcount_overflow+0xa: special: can't find orig instruction
> --
>    /kbuild/src/consumer/include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>>> net/batman-adv/fragmentation.o: warning: objtool: .text.refcount_overflow+0xa: special: can't find orig instruction
> --
>    /kbuild/src/consumer/include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>>> net/batman-adv/icmp_socket.o: warning: objtool: .text.refcount_overflow+0xb: special: can't find orig instruction
> --
>    /kbuild/src/consumer/include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>>> net/batman-adv/main.o: warning: objtool: .text.refcount_overflow+0xb: special: can't find orig instruction
> --
>    /kbuild/src/consumer/include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>>> net/batman-adv/multicast.o: warning: objtool: .text.refcount_overflow+0xf: special: can't find orig instruction
> ..
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation



-- 
Kees Cook
Pixel Security
