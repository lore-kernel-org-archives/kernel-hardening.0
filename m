Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160615002033.a318fa0dd807751a596185da@gmail.com>
References: <20160615001754.f9e986cf961d1466f5e086dc@gmail.com> <20160615002033.a318fa0dd807751a596185da@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 15 Jun 2016 11:07:08 -0700
Message-ID: <CAGXu5jLiPbAdjYhtyGxc7iZRLqa7d2Pks58utFCiD3ePtusLhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 2/4] Add the latent_entropy gcc plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, bart.vanassche@sandisk.com, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 14, 2016 at 3:20 PM, Emese Revfy <re.emese@gmail.com> wrote:
> This plugin mitigates the problem of the kernel having too little entropy during
> and after boot for generating crypto keys.
>
> It creates a local variable in every marked function. The value of this variable is
> modified by randomly chosen operations (add, xor and rol) and
> random values (gcc generates them at compile time and the stack pointer at runtime).
> It depends on the control flow (e.g., loops, conditions).
>
> Before the function returns the plugin writes this local variable
> into the latent_entropy global variable. The value of this global variable is
> added to the kernel entropy pool in do_one_initcall() and _do_fork().
>
> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> [...]
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index 2da380f..6c7e448 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -16,10 +16,10 @@ endif
>
>  ifdef CONFIG_FUNCTION_TRACER
>  # Do not trace early boot code
> -CFLAGS_REMOVE_cputable.o = -mno-sched-epilog $(CC_FLAGS_FTRACE)
> -CFLAGS_REMOVE_prom_init.o = -mno-sched-epilog $(CC_FLAGS_FTRACE)
> -CFLAGS_REMOVE_btext.o = -mno-sched-epilog $(CC_FLAGS_FTRACE)
> -CFLAGS_REMOVE_prom.o = -mno-sched-epilog $(CC_FLAGS_FTRACE)
> +CFLAGS_REMOVE_cputable.o = -mno-sched-epilog $(CC_FLAGS_FTRACE) $(DISABLE_LATENT_ENTROPY_PLUGIN)
> +CFLAGS_REMOVE_prom_init.o = -mno-sched-epilog $(CC_FLAGS_FTRACE) $(DISABLE_LATENT_ENTROPY_PLUGIN)
> +CFLAGS_REMOVE_btext.o = -mno-sched-epilog $(CC_FLAGS_FTRACE) $(DISABLE_LATENT_ENTROPY_PLUGIN)
> +CFLAGS_REMOVE_prom.o = -mno-sched-epilog $(CC_FLAGS_FTRACE) $(DISABLE_LATENT_ENTROPY_PLUGIN)

This doesn't look right to me: these are CFLAGS_REMOVE_* entries, and
I think you want to _add_ the DISABLE_LATENT_ENTROPY_PLUGIN to the
CFLAGS here.

from scripts/Makefile.lib:
_c_flags       = $(filter-out $(CFLAGS_REMOVE_$(basetarget).o), $(orig_c_flags))

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
