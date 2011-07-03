Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110703103925.GA2283@albatros>
References: <20110703103925.GA2283@albatros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 3 Jul 2011 12:24:39 -0700
Message-ID: <CA+55aFwfr-oAa-2L9O_rd9iZDyVr0b+gFQS=_R5PUxmhh3JEsg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH] proc: fix a race in do_io_accounting()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, security@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jul 3, 2011 at 3:39 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>
> The order of locking is similar to the one inside of
> ptrace_attach(): first goes cred_guard_mutex, then lock_task_sighand().

Hmm. mm_for_maps() uses mutex_lock_killable(), as does lock_trace.

And neither proc_pid_wchan() nor the fd following ones
(proc_pid_follow_link etc) use anything at all.

So I'm not sure. And do we really even care about the theoretical
race? Even if we do hit the race window and happen to get it just as a
process turns setuid, it would seem to be totally harmless (we're not
going to see any of the sensitive IO anyway).

So considering the lack of consistency in this area, I can't really
find it in myself to care very deeply.

That said, the lack of consistency itself is a bit annoying and
worrisome. Maybe some kind of helper like we do have for
"mm_for_maps()" would be a good idea - not because the potential races
are all that worrisome, but because inconsistencies in the kernel are
always signs of confusion, and confusion is always bad and a breeding
ground for potential bugs.

                           Linus
