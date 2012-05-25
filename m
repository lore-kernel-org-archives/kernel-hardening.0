Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4FBED482.4050800@zytor.com>
Date: Thu, 24 May 2012 17:38:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <20120522173942.GJ11775@ZenIV.linux.org.uk> <1337875681-20717-1-git-send-email-wad@chromium.org> <alpine.LRH.2.02.1205250932270.26644@tundra.namei.org> <CAObL_7GHEdoyzVPjhR5U0RvQhRP50e6YM83CkXifzUKOFb+KHQ@mail.gmail.com> <4FBECAC2.6050303@zytor.com> <CAObL_7GSNbgceHQpNx3fbiCbV5u-_vJJO5cptwVCK34W7wFH5Q@mail.gmail.com>
In-Reply-To: <CAObL_7GSNbgceHQpNx3fbiCbV5u-_vJJO5cptwVCK34W7wFH5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC PATCH 0/3] move the secure_computing call
To: Andrew Lutomirski <luto@mit.edu>
Cc: James Morris <jmorris@namei.org>, Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, mcgrathr@google.com, indan@nul.nu, netdev@parisplace.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, viro@zeniv.linux.org.uk
List-ID: <kernel-hardening.lists.openwall.com>

On 05/24/2012 05:26 PM, Andrew Lutomirski wrote:
> 
> Just to clarify: are you suggesting that, for now, the traced behavior
> should be:
> 
> process -> seccomp -> ptrace -> kernel?
> 
> If so, I think the man page or something should have a big fat warning
> that seccomp filters should *never* allow ptrace (even PTRACE_TRACEME)
> unless they fully understand the issue.
> 

Yes, and yes.

> In any case, I think that the UML interaction is missing the point.
> UML will *emulate* the seccomp filter.  If it chooses to use host
> seccomp filters for some business, that's its business.

I don't see why UML should have to emulate the seccomp filter.  With the
proposed order, then it can simply use the seccomp filter provided by
the host.  Furthermore, with this sequencing UML can actually *use*
seccomp to provide the simulation.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
