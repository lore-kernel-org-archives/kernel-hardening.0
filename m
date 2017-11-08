MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFwiaQezaPi2nzmyuFZNgR3PFcsWjjBTHJYBesKrh-Q_pQ@mail.gmail.com>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
 <ec5a3690-a8c2-0329-66c0-ed7dda5db958@redhat.com> <CA+55aFwiaQezaPi2nzmyuFZNgR3PFcsWjjBTHJYBesKrh-Q_pQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Nov 2017 12:39:41 -0800
Message-ID: <CA+55aFz6XYtthCgLVJY=985pedeKTwsqPLyL4VVyNpP2TjpPPg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: Laura Abbott <labbott@redhat.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 7, 2017 at 4:59 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> For example, maybe /proc/kallsyms could just default to not showing
> values to non-root users.
>
> Something like the attached TOTALLY UNTESTED patch. It's meant more as
> an RFC, not for application, but it's also meant to show how we can
> tailor the behavior for specific workflow issues.

It seems to work, except I got the condition wrong for
sysctl_perf_event_paranoid.

It should if

        if (sysctl_perf_event_paranoid <= 1)
                return 1;

rather than "<= 0", because '1' still means "allow kernel profiling"
(and the default value is "2").

But I don't know if there is anything else than the profiling code
that _really_ wants access to /proc/kallsyms in user space as a
regular user.

That said, that patch also fixes the /proc/kallsyms root check, in
that now you can do:

    sudo head < /proc/kallsyms

and it still shows all zeroes - because the file was *opened* as a
normal user. That's how UNIX file access security works, and how it is
fundamentally supposed to work (ie passing a file descriptor to a sui
program doesn't magically make it gain privileges).

Anyway, I'm obviously not going to commit that patch now, but I'd be
happy to try it for the 4.15 merge window, to see if we can close
/proc/kallsyms without people screaming..

            Linus
