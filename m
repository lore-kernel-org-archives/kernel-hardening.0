Message-Id: <1508119775.3619640.1139764440.2F1A81C9@webmail.messagingengine.com>
From: Tobin Harding <me@tobin.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <1507676974-1298-1-git-send-email-me@tobin.cc>
 <CA+55aFyH5X2nx0kf_hPeOjMQYF-UX6r3ov61=VqTOLLZLE3-vQ@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563F4AF591@ORSMSX115.amr.corp.intel.com>
Date: Mon, 16 Oct 2017 13:09:35 +1100
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC563F4AF591@ORSMSX115.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH 0/3] add %pX specifier
To: "Roberts, William C" <william.c.roberts@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, KVM list <kvm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Oct 14, 2017, at 04:54, Roberts, William C wrote:
> 
> 
> > -----Original Message-----
> > From: linus971@gmail.com [mailto:linus971@gmail.com] On Behalf Of Linus
> > Torvalds
> > Sent: Tuesday, October 10, 2017 4:17 PM
> > To: Tobin C. Harding <me@tobin.cc>
> > Cc: kernel-hardening@lists.openwall.com; KVM list <kvm@vger.kernel.org>;
> > Linux Kernel Mailing List <linux-kernel@vger.kernel.org>; Kees Cook
> > <keescook@chromium.org>; Paolo Bonzini <pbonzini@redhat.com>; Tycho
> > Andersen <tycho@docker.com>; Roberts, William C
> > <william.c.roberts@intel.com>; Tejun Heo <tj@kernel.org>; Jordan Glover
> > <Golden_Miller83@protonmail.ch>; Greg KH <gregkh@linuxfoundation.org>;
> > Petr Mladek <pmladek@suse.com>; Joe Perches <joe@perches.com>; Ian
> > Campbell <ijc@hellion.org.uk>; Sergey Senozhatsky
> > <sergey.senozhatsky@gmail.com>; Catalin Marinas <catalin.marinas@arm.com>;
> > Will Deacon <will.deacon@arm.com>; Steven Rostedt <rostedt@goodmis.org>;
> > Chris Fries <cfries@google.com>; Dave Weinstein <olorin@google.com>; Daniel
> > Micay <danielmicay@gmail.com>; Djalal Harouni <tixxdz@gmail.com>
> > Subject: Re: [PATCH 0/3] add %pX specifier
> > 
> > On Tue, Oct 10, 2017 at 4:09 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > >
> > > This patch is a softer version of Linus' suggestion because it does
> > > not change the behaviour of the %p specifier. I don't see the benefit
> > > in making such a breaking change without addressing the issue of %x (and I
> > don't the balls to right now).
> > 
> > The thing is, this continues to have the exact same issue that %pK has
> > - because it is opt-in, effectively nobody will actually use it.
> > 
> > That's why I would suggest that if we do this way, we really change %p and %pa
> > to use the hashed value, to convert *everybody*. And then people who have a
> > good reason to actually expose the pointer have to do the extra work and opt
> > out.
> 
> Yes we cannot make this opt in or there is really no point in doing it.
> %pK and mistakes
> got us here to this point. I see there is multiple threads, this getting
> really fun to follow.

The threading split is my fault. I have never worked on a patch series
with this many comments. How could I have gone about things differently
to prevent the thread separation? Should I have posted the second patch
set as a reply to the first (I did not because it was not a version 2). 
Further splitting occurred because I botched the `git send-email` and
sent only a cover-letter, this got some replies that lead to another
single patch (again it was quite different and seemed not to be a
version 2)? So we are left with three threads all discussing the same
changes. Is there anything one can do to rectify this position now?

thanks,
Tobin.
