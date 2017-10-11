MIME-Version: 1.0
In-Reply-To: <CA+55aFx56_4ERvNfdvQUk4yFF5UXWPkwg5g=QwS820nxAK0Bcg@mail.gmail.com>
References: <1507676974-1298-1-git-send-email-me@tobin.cc> <CA+55aFx56_4ERvNfdvQUk4yFF5UXWPkwg5g=QwS820nxAK0Bcg@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 11 Oct 2017 22:11:40 +0200
Message-ID: <CAHmME9q01Yb_hhDpfOz0v8Tg-AQE9Ov3hdN5S-FoMsTsh=kvWw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 0/3] add %pX specifier
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, KVM list <kvm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Linus,

On Wed, Oct 11, 2017 at 1:15 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> (NOTE! Using jhash here is not acceptable, since it's not
> cryptographically safe, but think of it as an example of a hash that
> takes 32-bit input).

Ahh, yes, I should have continued to read the thread before replying
my first reply.

Indeed the correct functions to use would be siphash_1u32 or
siphash_1u64, depending. Depending on the popularity of that, we might
even consider making a siphash_1ulong helper, I suppose.

Jason
