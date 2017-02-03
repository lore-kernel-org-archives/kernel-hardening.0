MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170203132737.263327330@infradead.org>
References: <20170203132558.474916683@infradead.org> <20170203132737.263327330@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 3 Feb 2017 15:37:35 -0800
Message-ID: <CAGXu5jKuhQE7wX9cMt0ZkUdswCGhJc9sm-6CiXg+ysx=aebV8A@mail.gmail.com>
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
>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  include/linux/refcount.h |  294 +++++++++++++++++++++++++++++++++++++++++++++++
>  lib/Kconfig.debug        |   13 ++
>  2 files changed, 307 insertions(+)
>
> --- /dev/null
> +++ b/include/linux/refcount.h
> @@ -0,0 +1,294 @@
> [...]
> +#if CONFIG_DEBUG_REFCOUNT

Oh, and I just hit this too, it should be "#ifdef" ... I didn't notice
until after I sent my improvement series. Whoops. :P Yay Friday.

-Kees

-- 
Kees Cook
Pixel Security
