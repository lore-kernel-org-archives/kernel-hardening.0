Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4FBE5E3C.9070600@zytor.com>
Date: Thu, 24 May 2012 09:13:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <20120522173942.GJ11775@ZenIV.linux.org.uk> <1337875681-20717-1-git-send-email-wad@chromium.org>
In-Reply-To: <1337875681-20717-1-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC PATCH 0/3] move the secure_computing call
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, mcgrathr@google.com, indan@nul.nu, netdev@parisplace.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, viro@zeniv.linux.org.uk, jmorris@namei.org
List-ID: <kernel-hardening.lists.openwall.com>

On 05/24/2012 09:07 AM, Will Drewry wrote:
> This is an RFC based on the comments from Al Viro and Eric Paris
> regarding ptrace()rs being able to change the system call the kernel
> sees after the seccomp enforcement has occurred (for mode 1 or 2).
> 
> With this series applied, a (p)tracer of a process with seccomp enabled
> will be unable to change the tracee's system call number after the
> secure computing check has been performed.
> 
> The x86 change is tested, as is the seccomp.c change.  For other arches,
> it is not (RFC :).  Given that there are other inconsistencies in this
> code across architectures, I'm not sure if it makes sense to attempt to
> fix them all at once or to roll through as I attempt to add seccomp
> filter support.
> 
> As is, the biggest benefit of this change is just setting consistent
> expectations in what the ptrace/seccomp interactions should be.  The
> current ability for ptrace to "bypass" secure computing (by remapping
> allowed system calls) is not necessarily a problem, but it is not
> necessarily intuitive behavior.
> 
> Thoughts, comments, flames will be appreciated!

I think this really screws with using seccomp for self-interception.  I
wouldn't inherently be opposed to the following flow:

	seccomp -> ptrace -> seccomp

... i.e. if ptrace is enabled and we enable something, run it through
seccomp again, but there are bunch of use cases (mostly involving
SIGSYS) where doing ptrace before seccomp is just bizarre.

	-hpa
