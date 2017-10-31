Date: Tue, 31 Oct 2017 16:39:44 +0100
From: Petr Mladek <pmladek@suse.com>
Message-ID: <20171031153944.GA32091@pathway.suse.cz>
References: <1509317956-28041-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1509317956-28041-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] Re: [PATCH V9] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon 2017-10-30 09:59:16, Tobin C. Harding wrote:
> Currently there are many places in the kernel where addresses are being
> printed using an unadorned %p. Kernel pointers should be printed using
> %pK allowing some control via the kptr_restrict sysctl. Exposing addresses
> gives attackers sensitive information about the kernel layout in memory.
> 
> We can reduce the attack surface by hashing all addresses printed with
> %p. This will of course break some users, forcing code printing needed
> addresses to be updated.

I am sorry for my ignorance but what is the right update, please?
I expect that there are several possibilities:

  + remove the pointer at all

  + replace it with %pK so that it honors kptr_restrict setting

  + any other option?

Is kptr_restrict considered a safe mechanism?

Also kptr_restrict seems to be primary for the messages that are available
via /proc and /sys. Is it good enough for the messages logged by
printk()?

Will there be a debug option that would allow to see the original
pointers? Or what is the preferred way for debug messages?


> For what it's worth, usage of unadorned %p can be broken down as
> follows (thanks to Joe Perches).
> 
> $ git grep -E '%p[^A-Za-z0-9]' | cut -f1 -d"/" | sort | uniq -c
>    1084 arch
>      20 block
>      10 crypto
>      32 Documentation
>    8121 drivers
>    1221 fs
>     143 include
>     101 kernel
>      69 lib
>     100 mm
>    1510 net
>      40 samples
>       7 scripts
>      11 security
>     166 sound
>     152 tools
>       2 virt

It is evident that it will hit many people. I guess that they will
be suprised and might have similar questions. It might make sense
to decribe this in Documentation/printk-formats.txt.

Best Regards,
Petr
