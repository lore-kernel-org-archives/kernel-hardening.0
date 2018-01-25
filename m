MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAPcyv4hrkX-1rAJNU+Kzm2KLjgVNdCHs4no8dYQ=qnTZDDcyTw@mail.gmail.com>
References: <503224b776b9513885453756e44bab235221124e.1516644136.git.luto@kernel.org>
 <CA+55aFwcU_hHz+S9ZDphBDRQLw6pMsd+6Yp_=mQA8kTcmTzWcQ@mail.gmail.com>
 <CA+55aFyONQeyHit6LcQz_JM5+C9pr61fcWFSpdn=7K_2mZN+oA@mail.gmail.com>
 <CALCETrVUY9p9jMNhuBgM3mWATsr1Fc_ZWc=bjidBkLw7bq5Vdg@mail.gmail.com>
 <CA+55aFwUn7+WiHxL7PBWxNrGB0--HETqUjdRwxi+DkMvCP_CaA@mail.gmail.com>
 <CALCETrV1JHK1ovjjD1vbs08K1an6tq6nbRoAj9uyrY2GUYJJBA@mail.gmail.com>
 <CA+55aFzTXVRPo7OBPMo2OB26GisY8-dg6NaC8ackVJgS9M0+4w@mail.gmail.com>
 <CALCETrU42C1S3nvSuLuamXtp2-s1xBG3q5cSNVOfGThncHxBZA@mail.gmail.com> <CAPcyv4hrkX-1rAJNU+Kzm2KLjgVNdCHs4no8dYQ=qnTZDDcyTw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Jan 2018 13:53:53 -0800
Message-ID: <CA+55aFwgWqNAyZ3hVYhn_s2JgdVDeyMSRKFxaU=R3jq7GRs6Bg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] x86/retpoline/entry: Disable the entire SYSCALL64 fast
 path with retpolines on
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Cox <alan@linux.intel.com>, Jann Horn <jannh@google.com>, Samuel Neves <samuel.c.p.neves@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 25, 2018 at 1:39 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>
> If you're rejiggering, can we also put in a mechanism for detecting
> which registers to clear so that userspace can't inject useful values
> into speculation paths?

That actually becomes trivial with just the "no fastpath" patch I sent
out. You can just clear all of them.

Sure, then do_syscall_64() will reload the six first ones, but since
those are the argument registers anyway, and since they are
caller-clobbered, they have very short lifetimes. So it would
effectively not really be an issue.

But yes, SYSCALL_DEFINEx() rejiggery would close even that tiny hole.

                   Linus
