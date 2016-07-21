Reply-To: kernel-hardening@lists.openwall.com
From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <1468619065-3222-3-git-send-email-keescook@chromium.org>
References: <1468619065-3222-1-git-send-email-keescook@chromium.org> <1468619065-3222-3-git-send-email-keescook@chromium.org>
Date: Thu, 21 Jul 2016 16:52:09 +1000
Message-ID: <87poq78ova.fsf@@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v3 02/11] mm: Hardened usercopy
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Balbir Singh <bsingharora@gmail.com>, Daniel Micay <danielmicay@gmail.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Rik van Riel <riel@redhat.com>, Casey Schaufler <casey@schaufler-ca.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "David S. Miller" <davem@davemloft.net>, x86@kernel.org, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Mathias Krause <minipli@googlemail.com>, Jan Kara <jack@suse.cz>, Vitaly Wool <vitalywool@gmail.com>, Andrea Arcangeli <aarcange@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Laura Abbott <labbott@fedoraproject.org>, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> diff --git a/mm/usercopy.c b/mm/usercopy.c
> new file mode 100644
> index 000000000000..e4bf4e7ccdf6
> --- /dev/null
> +++ b/mm/usercopy.c
> @@ -0,0 +1,234 @@
...
> +
> +/*
> + * Checks if a given pointer and length is contained by the current
> + * stack frame (if possible).
> + *
> + *	0: not at all on the stack
> + *	1: fully within a valid stack frame
> + *	2: fully on the stack (when can't do frame-checking)
> + *	-1: error condition (invalid stack position or bad stack frame)
> + */
> +static noinline int check_stack_object(const void *obj, unsigned long len)
> +{
> +	const void * const stack = task_stack_page(current);
> +	const void * const stackend = stack + THREAD_SIZE;

That allows access to the entire stack, including the struct thread_info,
is that what we want - it seems dangerous? Or did I miss a check
somewhere else?

We have end_of_stack() which computes the end of the stack taking
thread_info into account (end being the opposite of your end above).

cheers
