MIME-Version: 1.0
In-Reply-To: <CAGXu5jLXB4J_ZGCKF0WD2SNTGyam8-tP5K1iYChW8wZEtAVM2A@mail.gmail.com>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <1490811363-93944-5-git-send-email-keescook@chromium.org> <CALCETrWkrpuJkcgiwMdc61Vv5U2u39FiWgzWfA_85nziK0pZsg@mail.gmail.com>
 <CAGXu5jKif5UUMBbQBpB7Ha7w0L+su8dSXDU3nbccO3EBnv7bTw@mail.gmail.com>
 <CALCETrW7nN8Ja=r9k4ANpekKovC_wsYrGrge1WNoGsAjZZvqHQ@mail.gmail.com>
 <CAGXu5jLENkemQiL6bcL5=qsesi-2M=1jYhS7SGBpBG64ER2CsA@mail.gmail.com>
 <CALCETrVErxE5P=V4LD=kFCBtnp2YYEGRsbxhTG0SXJjrw6Yk1A@mail.gmail.com>
 <CA+rthh95rW95woiWvyeCcoJT-qRM18KCDGHGtH=bDHZdExmVmg@mail.gmail.com>
 <alpine.DEB.2.20.1704071048360.1716@nanos> <CA+rthh9-EJBBO6nYYY6noP0ybcvk+xJ+S5h6BCNPtidjMCv8VQ@mail.gmail.com>
 <alpine.DEB.2.20.1704071426300.1716@nanos> <CA+rthh8TbqU-4tY4Y8trnyMDBe6dRLhVrAnk-COJCZCOyHqSog@mail.gmail.com>
 <CALCETrWuZPDjAuE1jnhJNKiZOOEdbus-O6GY8++0UO56Q84PZw@mail.gmail.com>
 <alpine.DEB.2.20.1704072125460.1958@nanos> <CAGXu5jLXB4J_ZGCKF0WD2SNTGyam8-tP5K1iYChW8wZEtAVM2A@mail.gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sat, 8 Apr 2017 00:12:53 -0400
Message-ID: <CA+DvKQKTHBdyQ0_Kn0dpZzAo1g3yBt-OGK309K+UN6upq-5FAQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Mathias Krause <minipli@googlemail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

> I probably chose the wrong name for this feature (write rarely).
> That's _usually_ true, but "sensitive_write()" was getting rather
> long. The things that we need to protect with this are certainly stuff
> that doesn't get much writing, but some things are just plain
> sensitive (like page tables) and we should still try to be as fast as
> possible with them.

Not too late to rename it. Scoped write? I think it makes change to
use a different API than PaX for portability too, but not a different
x86 implementation. It's quite important to limit the writes to the
calling thread and it needs to perform well to be introduced widely.

> I'm all for a general case for the infrastructure (as Andy and Mark
> has mentioned), but I don't want to get into the situation where
> people start refusing to use it because it's "too slow" (for example,
> see refcount_t vs net-dev right now).

Meanwhile, the PaX implementation has improved to avoid the issues
that were brought up while only introducing a single always-predicted
(due to code placement) branch on the overflow flag. That seems to
have gone unnoticed upstream, where there's now a much slower
implementation that's not more secure, and is blocked from
introduction in areas where it's most needed based on the performance.
Not to mention that it's opt-in... which is never going to work.
