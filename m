MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1507676974-1298-1-git-send-email-me@tobin.cc>
References: <1507676974-1298-1-git-send-email-me@tobin.cc>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Oct 2017 16:16:55 -0700
Message-ID: <CA+55aFyH5X2nx0kf_hPeOjMQYF-UX6r3ov61=VqTOLLZLE3-vQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 0/3] add %pX specifier
To: "Tobin C. Harding" <me@tobin.cc>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, KVM list <kvm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 10, 2017 at 4:09 PM, Tobin C. Harding <me@tobin.cc> wrote:
>
> This patch is a softer version of Linus' suggestion because it does not change the behaviour of the
> %p specifier. I don't see the benefit in making such a breaking change without addressing the issue
> of %x (and I don't the balls to right now).

The thing is, this continues to have the exact same issue that %pK has
- because it is opt-in, effectively nobody will actually use it.

That's why I would suggest that if we do this way, we really change %p
and %pa to use the hashed value, to convert *everybody*. And then
people who have a good reason to actually expose the pointer have to
do the extra work and opt out.

                  Linus
