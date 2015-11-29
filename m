Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 29 Nov 2015 09:05:05 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20151129080505.GA23721@gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
 <CA+rthh-euk2hGGWjsDqXogWSmzmJNV1aiUVfnTfrzyQhndgbOQ@mail.gmail.com>
 <565595F5.32536.DB9FE75@pageexec.freemail.hu>
 <20151126085425.GA29848@gmail.com>
 <CALCETrXrvAY+mXx+JULw7W+xokcSPFgWm5-McJf9EKhYehPhbA@mail.gmail.com>
 <20151127075959.GA24991@gmail.com>
 <CA+55aFxH+Gy4U8WbGWXh+ybrvng8tw1=2CrjPnJSju3+c5XpbA@mail.gmail.com>
 <CAGXu5j+mvknX69Kk1S8u54LR4T+KED8zZdkqQWA9KMrOvtVQtQ@mail.gmail.com>
 <CALCETrVVYMUgxABoEVfJgLtE+nB44aijqG5saq8dTQSTVWxbMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVVYMUgxABoEVfJgLtE+nB44aijqG5saq8dTQSTVWxbMA@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only
 memory
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, PaX Team <pageexec@freemail.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mathias Krause <minipli@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch <linux-arch@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Andy Lutomirski <luto@amacapital.net> wrote:

> >>  - print a warning and a backtrace, and just mark the page read-write
> >> so that the machine survives, but we get notified and can fix whatever
> >> broken code
> >
> > This seems very easy to add. Should I basically reverse the effects of 
> > mark_rodata_ro(), or should I only make the new ro-after-init section as RW? 
> > (I think the former would be easier.)
> 
> I'd suggest verifying that the page in question is .data..ro_after_init and, if 
> so, marking that one page RW.

Yes, this was PaX's suggestion as well, and I agree: doing that turns a quite 
possibly unrecoverable boot/shutdown time or suspend/resume time (suspend is 
really a special category of 'bootup') crasher oops into a more informative stack 
dump.

These ro related faults tend to trigger when init/deinit is running, and oopsing 
in those sequences is typically a lot less survivable than say oopsing in a high 
level system call while not holding locks.

Thanks,

	Ingo
