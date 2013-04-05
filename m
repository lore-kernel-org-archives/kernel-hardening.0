Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 5 Apr 2013 09:05:30 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20130405070530.GA26889@gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-4-git-send-email-keescook@chromium.org>
 <515DDEC0.9000109@zytor.com>
 <CAKyRK=iZeYv8MPa2tLfRRTmNX2WQsT+t3UAu_wy3uT9TiZokgA@mail.gmail.com>
 <CAKyRK=ic3QHOLKen=jxgeEN5mVVj_Gyt-1wXOniKNgO75f80Qw@mail.gmail.com>
 <515DE24D.3080507@zytor.com>
 <CAKyRK=gmUBaHvFtPyzEGN697gB1AhhcrguCWBGQvLZS7x-YFvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKyRK=gmUBaHvFtPyzEGN697gB1AhhcrguCWBGQvLZS7x-YFvQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: Julien Tinnes <jln@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Will Drewry <wad@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Julien Tinnes <jln@google.com> wrote:

> On Thu, Apr 4, 2013 at 1:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 04/04/2013 01:23 PM, Julien Tinnes wrote:
> >> On Thu, Apr 4, 2013 at 1:19 PM, Julien Tinnes <jln@google.com> wrote:
> >>> On Thu, Apr 4, 2013 at 1:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >>>> On 04/04/2013 01:07 PM, Kees Cook wrote:
> >>>>> However, the benefits of
> >>>>> this feature in certain environments exceed the perceived weaknesses[2].
> >>>>
> >>>> Could you clarify?
> >>>
> >>> I think privilege reduction in general, and sandboxing in particular,
> >>> can make KASLR even more useful. A lot of the information leaks can be
> >>> mitigated in the same way as attack surface and vulnerabilities can be
> >>> mitigated.
> >>
> >> Case in point:
> >> - leaks of 64 bits kernel values to userland in compatibility
> >> sub-mode. Sandboxing by using seccomp-bpf can restrict a process to
> >> the 64-bit mode API.
> >> - restricting access to the syslog() system call
> >>
> >
> > That doesn't really speak to the value proposition.  My concern is that
> > we're going to spend a lot of time chasing/plugging infoleaks instead of
> > tackling bigger problems.
> 
> Certain leaks are already an issue, even without kernel base 
> randomization.

Definitely. Stealth infiltration needs a high reliability expoit, 
especially if the attack vector used is a zero day kernel vulnerability.

Injecting uncertainty gives us a chance to get a crash logged and the 
vulnerability exposed.

> But yeah, this would give an incentive to plug more infoleaks. I'm not 
> sure what cost this would incur on kernel development.

I consider it a plus on kernel development - the more incentives to plug 
infoleaks, the better.

> There are by-design ones (printk) and bugs. I think we would want to
> correct bugs regardless?

Definitely.

> For by-design ones, privilege-reduction can often be an appropriate answer.

Correct, that's the motivation behind kptr_restrict and dmsg_restrict.

> I really see KASLR as the next natural step:
>
> 1. Enforce different privilege levels via the kernel
> 2. Attackers attack the kernel directly
> 3a. Allow user-land to restrict the kernel's attack surface and
>     develop sandboxes (seccomp-bpf, kvm..)
> 3b. Add more exploitation defenses to the kernel, leveraging (3a) and (1).
> 
> > 8 bits of entropy is not a lot.
> 
> It would certainly be nice to have more, but it's a good first start. 
> Unlike user-land segfaults, many kernel-mode panics aren't recoverable 
> for an attacker.

The other aspect of even just a couple of bits of extra entropy is that it 
changes the economics of worms and other remote attacks: there's a 
significant difference between being able to infect one machine per packet 
and only 1 out of 256 machines while the other 255 get crashed.

The downside is debuggability - so things like 'debug' on the kernel boot 
command line should probably disable this feature automatically.

Thanks,

	Ingo
