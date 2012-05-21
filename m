Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <5d6179f59222155b72d9aa9f171e883c.squirrel@webmail.greenhost.nl>
In-Reply-To: 
 <CAB=4xho2b5fZV_jC15XW3mhOD9Z0QUMnV_UHy-P5EmQWfX59dA@mail.gmail.com>
References: 
    <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com>
    <CAB=4xho2b5fZV_jC15XW3mhOD9Z0QUMnV_UHy-P5EmQWfX59dA@mail.gmail.com>
Date: Mon, 21 May 2012 21:20:49 +0200
From: "Indan Zupancic" <indan@nul.nu>
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: seccomp and ptrace. what is the correct order?
To: Roland McGrath <mcgrathr@google.com>
Cc: Eric Paris <netdev@parisplace.org>, Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 21, 2012 20:25, Roland McGrath wrote:
> From a security perspective I think the natural expectation would be that
> the seccomp check is on the values that will actually be used, without an
> intervening opportunity to change anything.

Actually, considering a tracer has full control over a traced process,
it would make most sense from a security perspective to check both the
traced task's seccomp filter, as well as the one for the ptracer for
modified system calls (calls where any register poking at all was done).
Otherwise a task could bypass its own seccomp filter by ptracing a hapless
victim.

I mentioned this before, but I forgot why this option was dismissed.
Probably because ptrace shouldn't have been allowed by the filter in
the first place.

The current patch does the seccomp check first and ignores any changes
made via ptrace, just like the old seccomp did. So in that sense nothing
changed.

Originally the seccomp filter check was in the fast path, so doing it
after ptrace was tricky. But now it has been moved to the slow tracehook
path it can easily be checked after the ptrace notification. That would
change the behaviour SECCOMP_MODE=1 though, but probably nobody cares,
as it can be argued that that was a security hole anyway (except if
ptracing a seccomped task was disallowed, in which case moving it to
the end doesn't change anything anyway).

Another argument for moving it to the end is that it makes debugging
seccomped tasks a lot easier, because the debugger sees the denied
system call. With the current patch the tasks would silently die.

Greetings,

Indan
