MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170203132737.263327330@infradead.org>
References: <20170203132558.474916683@infradead.org> <20170203132737.263327330@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 3 Feb 2017 10:09:18 -0800
Message-ID: <CAGXu5jL3fW+8_NMMw--Q2v3ZT_nXX=RyKVQ=9_HnBadkL+HNfw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 1/5] refcount_t: A special purpose refcount type
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, David Windsor <dwindsor@gmail.com>, David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 3, 2017 at 5:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Provide refcount_t, an atomic_t like primitive built just for
> refcounting.
>
> It provides saturation semantics such that overflow becomes impossible
> and thereby 'spurious' use-after-free is avoided.

Wheee :) Thanks for working on this

>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
> [...]
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -716,6 +716,19 @@ source "lib/Kconfig.kmemcheck"
>
>  source "lib/Kconfig.kasan"
>
> +config DEBUG_REFCOUNT
> +       bool "Verbose refcount checks"
> +       --help--

Quick feedback as I start playing with this: this isn't valid Kconfig
syntax (build breaks). It should either be "---help---" or just
"help", latter preferred.

> +         Say Y here if you want reference counters (refcount_t and kref) to
> +         generate WARNs on dubious usage. Without this refcount_t will still
> +         be a saturating counter and avoid Use-After-Free by turning it into
> +         a resource leak Denial-Of-Service.
> +
> +         Use of this option will increase kernel text size but will alert the
> +         admin of potential abuse.
> +
> +         If in doubt, say "N".
> +
>  endmenu # "Memory Debugging"
>
>  config ARCH_HAS_KCOV
>
>

-Kees

-- 
Kees Cook
Pixel Security
