Date: Mon, 1 May 2017 17:45:42 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20170501224542.bbfhs7c4x2wibomz@treble>
References: <1493160997-126108-1-git-send-email-keescook@chromium.org>
 <1493160997-126108-3-git-send-email-keescook@chromium.org>
 <20170501163009.kbemdhpsabdrsfex@treble>
 <CAGXu5jKoeB7tbxfcLC03tFnjYKYt+ZHtk_jruQJ887dPHJ-Gag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5jKoeB7tbxfcLC03tFnjYKYt+ZHtk_jruQJ887dPHJ-Gag@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 2/2] x86, refcount: Implement fast refcount overflow
 protection
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 01, 2017 at 10:36:59AM -0700, Kees Cook wrote:
> >> +#ifdef CONFIG_FAST_REFCOUNT
> >> +static DEFINE_RATELIMIT_STATE(refcount_ratelimit, 15 * HZ, 3);
> >> +
> >> +void refcount_error_report(struct pt_regs *regs, const char *kind)
> >> +{
> >> +     do_send_sig_info(SIGKILL, SEND_SIG_FORCED, current, true);
> >> +
> >> +     if (!__ratelimit(&refcount_ratelimit))
> >> +             return;
> >> +
> >> +     pr_emerg("%s detected in: %s:%d, uid/euid: %u/%u\n",
> >> +             kind ? kind : "refcount error",
> >> +             current->comm, task_pid_nr(current),
> >> +             from_kuid_munged(&init_user_ns, current_uid()),
> >> +             from_kuid_munged(&init_user_ns, current_euid()));
> >> +     print_symbol(KERN_EMERG "refcount error occurred at: %s\n",
> >> +             instruction_pointer(regs));
> >> +     preempt_disable();
> >> +     show_regs(regs);
> >> +     preempt_enable();
> >> +}
> >
> > Why is preemption disabled before calling show_regs()?
> 
> I thought it was to avoid interleaving show_regs() output (I can't
> think of a way regs would be externally modified).

This code is running from interrupt context, so preemption shouldn't be
an issue unless I'm missing something.

-- 
Josh
