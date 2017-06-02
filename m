MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.LRH.2.20.1706020830520.16910@namei.org>
References: <20170529213800.29438-1-matt@nmatt.com> <20170529213800.29438-3-matt@nmatt.com>
 <20170529232640.16211960@alans-desktop> <CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
 <3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com> <0e078ce7-5b62-f27c-3920-efc2ffdf342b@nmatt.com>
 <b0a29f23-4154-8f2f-98e7-0942612f0cdc@schaufler-ca.com> <e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
 <20170530132427.016053da@alans-desktop> <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
 <20170530235106.11aab25c@alans-desktop> <3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com>
 <20170531005633.484a2e14@alans-desktop> <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
 <6e713105-02db-12e1-68a9-f167fe11d0a9@gmail.com> <CAGXu5jKLnn_eqerFYdsygjHM=WngUW=o2e65wgw1fjTM=pxO=Q@mail.gmail.com>
 <alpine.LRH.2.20.1706020830520.16910@namei.org>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 2 Jun 2017 11:46:22 -0700
Message-ID: <CAGXu5jJUYh_+kyfwyaJMUjyNSC+p=xbgGkirOqu89TVRY_bYSg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: James Morris <jmorris@namei.org>
Cc: lazytyped <lazytyped@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 1, 2017 at 3:56 PM, James Morris <jmorris@namei.org> wrote:
> On Thu, 1 Jun 2017, Kees Cook wrote:
>
>> All of the reasoning here seems to match the link restrictions from 5
>> years ago: a crappy API (sticky bit) is not handled by userspace (open
>> /tmp/$$!) and people get attacked. The solution was a sysctl to enable
>> the link restrictions that killed the entire class of the common
>> attack (though it didn't solve especially egregious bad uses, much
>
> This is the problem -- it doesn't really eliminate the underlying issue.
>
> A better solution (in this case) was to implement a new API which
> addresses the issue at an architectural level, i.e. namespace-based
> private /tmp views, and encourage its adoption.

I think this is a frequent mistake in evaluating how to kill bug
classes: there doesn't have to be only one solution, especially when
there are downsides to be dealt with. In the link restriction case,
the VFS solution immediately solved the vast majority of issues
without breaking any applications. The private /tmp takes time to roll
out, and breaks the shared /tmp way of doing things that some tools
use to share files, etc. So the private /tmp solves more of the
problem (eliminates link attacks in subdirectories of /tmp), but
breaks real use-cases. And ultimately, there is nothing incompatible
about the solutions, so both could (and were) pursued.

>> like the TIOCSTI fix). Every distro enabled the sysctl, and, while the
>> data is noisy, looking a CVEs matching "/tmp symlink", the numbers
>> drop from 2013 and later (with none yet for 2017).
>
> I wonder how much of this is due to the sysctl vs. adoption of private
> /tmp, and what may be lurking in the "egregious bad uses" category for
> future CVEs.  And obviously we don't know what various folk may have up
> their sleeves, if anything.

Private /tmp is still somewhat less common, the VFS changes were
rolled out almost universally, so, if the numbers can be trusted at
all, I would assume it's the VFS changes. That said, CVE numbers tend
to fluctuate based on researcher interest, rather than being a true
measure of real-world problems. The anecdata I have while at Ubuntu
was having people complain about getting owned by /tmp symlink ToCToU
from time to time on the Ubuntu security IRC channel, and after Ubuntu
rolled out the VFS changes, that dropped to zero in all the years
since.

So, I guess, my point is that there are always multiple solutions that
come with various benefits and downsides, and when there isn't a
perfect solution, imperfect solutions that make real-world changes on
attack surface are worth pursuing, even in parallel. Perfection
shouldn't be the enemy of the good. (Perfection is preferred, but it's
not usuallyt pragmatically possible.)

-Kees

-- 
Kees Cook
Pixel Security
