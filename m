Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 11 Jul 2016 17:31:11 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160711163110.GD7691@leverpostej>
References: <cover.1466974736.git.luto@kernel.org>
 <aeea9c1c41e889065b2c9ecd6d0694e4dfb529c8.1466974736.git.luto@kernel.org>
 <20160711100808.GB31221@leverpostej>
 <CALCETrWnw0WjionuGAT1F8r5y_t5CbYh+TmDL4s2d=ZbiinspA@mail.gmail.com>
 <CA+55aFy2Sno+bS0A2k0cMWpEJy-bpXufSAw3+ufrfQYbp9rcMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy2Sno+bS0A2k0cMWpEJy-bpXufSAw3+ufrfQYbp9rcMQ@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH v4 26/29] sched: Allow putting
 thread_info into task_struct
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-arch@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@redhat.com>, X86 ML <x86@kernel.org>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 11, 2016 at 09:06:58AM -0700, Linus Torvalds wrote:
> On Jul 11, 2016 7:55 AM, "Andy Lutomirski" <[1]luto@amacapital.net> wrote:
> >
> > How do you intend to find 'current' to get to the preempt count
> > without first disabling preemption?
>
> Actually, that is the classic case of "not a problem".
>
> The thing is, it doesn't matter if you schedule away while looking up
> current or the preempt count - because both values are idempotent wet
> scheduling.
>
> So until you do the wire that actually disables preemption you can
> schedule away as much as you want, and after that write you no longer
> will.

I was assuming a percpu pointer to current (or preempt count).

The percpu offset might be stale at the point you try to dereference
that, even though current itself hasn't changed, and you may access the
wrong CPU's value.

> This is different wrt a per-cpu area - which is clearly not idempotent wrt
> scheduling.
>
> The reason per-cpu works on x86 is that we have an atomic rmw operation
> that is *also* atomic wrt the CPU lookup (thanks to the segment base)

Sure, understood.

Mark.
