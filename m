MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <6e713105-02db-12e1-68a9-f167fe11d0a9@gmail.com>
References: <20170529213800.29438-1-matt@nmatt.com> <20170529213800.29438-3-matt@nmatt.com>
 <20170529232640.16211960@alans-desktop> <CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
 <3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com> <0e078ce7-5b62-f27c-3920-efc2ffdf342b@nmatt.com>
 <b0a29f23-4154-8f2f-98e7-0942612f0cdc@schaufler-ca.com> <e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
 <20170530132427.016053da@alans-desktop> <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
 <20170530235106.11aab25c@alans-desktop> <3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com>
 <20170531005633.484a2e14@alans-desktop> <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
 <6e713105-02db-12e1-68a9-f167fe11d0a9@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 1 Jun 2017 11:46:51 -0700
Message-ID: <CAGXu5jKLnn_eqerFYdsygjHM=WngUW=o2e65wgw1fjTM=pxO=Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: lazytyped <lazytyped@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 1, 2017 at 12:12 AM, lazytyped <lazytyped@gmail.com> wrote:
>
>
> On 6/1/17 4:35 AM, Kees Cook wrote:
>>
>> I still cannot wrap my head around why providing users with a
>> protection is a bad thing. Yes, the other tty games are bad, but this
>> fixes a specific and especially bad case that is easy to kill. It's
>> got a Kconfig and a sysctl. It's not on by default. This protects the
>> common case of privileged ttys that aren't attached to consoles, etc,
>> so while the framebuffer thing is an issue, it's not always an issue,
>> etc.
>
> There are a couple of reasons for that:
>
> First of all, a protection is extra cost, in terms of maintenance, knowledge
> (a new knob) and compatibility. That extra cost may sound minimal, but adds
> up pretty quickly. If the protection is "easily" bypassable (that is, today
> we use TIOCSTI, tomorrow we use something else in the same path), then that
> extra cost/complexity stays for no good reason. Feature creep is a real
> issue, in security, IMHO - it's not a 'number of features' game.

Yes, absolutely. But the trouble tends to be around "poor initial
design" userspace APIs that need work-arounds to make them safe. These
cases are relatively rare, luckily, so there's not much actual
"slippery slope" for adding those kinds of protections. As for
bypassing, besides Alan's physical-console-specific issues, I haven't
seen anyone point out things with privileged TTYs that are still an
escalation path when TIOCSTI is unavailable.

So, the way I see it, this is a fix for a bad API that keeps being
coded poorly in userspace that, while it doesn't fix all physical
console attacks, does block the specific issue introduced by TIOCSTI.
And since there are legit users of TIOCSTI we can't just remove it,
since some people want the functionality over the risk. Hence, a
sysctl.

All of the reasoning here seems to match the link restrictions from 5
years ago: a crappy API (sticky bit) is not handled by userspace (open
/tmp/$$!) and people get attacked. The solution was a sysctl to enable
the link restrictions that killed the entire class of the common
attack (though it didn't solve especially egregious bad uses, much
like the TIOCSTI fix). Every distro enabled the sysctl, and, while the
data is noisy, looking a CVEs matching "/tmp symlink", the numbers
drop from 2013 and later (with none yet for 2017).

> Second, stuff that is delivered off by default tends to rot. I don't work on
> Linux, but generally try really hard to not add something that is not ON by
> default at least for a small number of things. Stuff inevitably breaks, and
> it's extra cost.
> To me, a protection that needs to be off by default, raises a red flag. I
> know Linux has a somewhat different philosophy (centered around the kernel
> config that each distribution pieces together and ships), so mileage
> probably varies there.

Totally agreed in general about the default-off, but the Linux
ecosystem is a weird one: Linus has mandated that the kernel can never
break userspace by default, effectively freeing upstream developers
from the responsibility of dealing with such breakage. However,
distros can have their own set of defaults. In many of the
security-sensitive areas, distros turn things on by default. As
mentioned above, link restrictions were enabled by default on distros
(some even before it was upstream), as well as things like
CONFIG_DEBUG_RODATA (before it was finally made mandatory, a decade
later), CONFIG_HARDENED_USERCOPY, etc.

This is the evolution of Linux security defenses: first it has to
exist (but default-off), then everyone gets comfortable with it being
enabled because distros turn it on, then everyone gets frustrated that
it's not default-on in the kernel and changes it there too, either by
identifying improvements to allow it on-by-default or just having a
flag-day. An example of the former might be the ancient progression of
/proc/self/maps protections (on-show sysctl in 2.6.22, on-open mm
check in 2.6.24, drop sysctl in 2.6.27). For the latter, noted above,
CONFIG_DEBUG_RODATA (now CONFIG_STRICT_KERNEL_RWX) is a good example
where it was just decided, finally, to make it mandatory (on x86 and
arm64 so far).

> I don't have enough skills to comment about all the possible TTY attacks and
> quirks, but I think I understand where Alan comes from.

Yeah, agreed. I certainly don't claim it solves all the TTY risks, but
it closes the door on a big one. That kind of change has real-world
benefits, and we have decades of evidence to show that just saying
"fix it in userspace" is not going to protect anyone.

-Kees

-- 
Kees Cook
Pixel Security
