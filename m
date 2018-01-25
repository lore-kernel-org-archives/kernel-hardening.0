MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CALCETrVUY9p9jMNhuBgM3mWATsr1Fc_ZWc=bjidBkLw7bq5Vdg@mail.gmail.com>
References: <503224b776b9513885453756e44bab235221124e.1516644136.git.luto@kernel.org>
 <CA+55aFwcU_hHz+S9ZDphBDRQLw6pMsd+6Yp_=mQA8kTcmTzWcQ@mail.gmail.com>
 <CA+55aFyONQeyHit6LcQz_JM5+C9pr61fcWFSpdn=7K_2mZN+oA@mail.gmail.com> <CALCETrVUY9p9jMNhuBgM3mWATsr1Fc_ZWc=bjidBkLw7bq5Vdg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Jan 2018 13:06:45 -0800
Message-ID: <CA+55aFwUn7+WiHxL7PBWxNrGB0--HETqUjdRwxi+DkMvCP_CaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: Andy Lutomirski <luto@kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Cox <alan@linux.intel.com>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 25, 2018 at 1:02 PM, Andy Lutomirski <luto@kernel.org> wrote:
>
> Feel free to Acked-by: Andy Lutomirski <luto@kernel.org> that patch.
>
> Or I can grab it and send it to -tip.

I'm not going to apply it for 4.15, I just wanted to see how it
looked, and do some minimal profiling.

>From the profiles, as mentioned, moving 'status' from thread_struct to
thread_info is probably worth doing. But I didn't look at the impact
of that at all.

So it should go through all the normal channels in -tip for 4.16.

I'll happily sign off on the patch, but it was really pretty mindless,
so I'm not sure I need the authorship either.

> Re: the trampoline not showing up: if I find some time, I'll try to
> wire it up correctly in kallsyms.

That would be lovely. Right now the system call exit shows up pretty
clearly in profiles, and most of it is (obviously) the cr3 write. So
the missing entry trampoline is not insignificant.

             Linus
