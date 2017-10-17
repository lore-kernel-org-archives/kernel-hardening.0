Message-ID: <1508217608.6530.20.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Mon, 16 Oct 2017 22:20:08 -0700
In-Reply-To: <1508215972-7769-1-git-send-email-me@tobin.cc>
References: <1508215972-7769-1-git-send-email-me@tobin.cc>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v2] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-10-17 at 15:52 +1100, Tobin C. Harding wrote:
> Currently there are many places in the kernel where addresses are being
> printed using an unadorned %p. Kernel pointers should be printed using
> %pK allowing some control via the kptr_restrict sysctl. Exposing addresses
> gives attackers sensitive information about the kernel layout in memory.
> 
> We can reduce the attack surface by hashing all addresses printed with
> %p. This will of course break some users, forcing code printing needed
> addresses to be updated.
> 
> For what it's worth, usage of unadorned %p can be broken down as follows
> 
>     git grep '%p[^KFfSsBRrbMmIiEUVKNhdDgCGO]' | wc -l

Not really.
There are many asm uses included there

I think a better grep is:

$ git grep -E '%p[^A-Za-z0-9]' | cut -f1 -d"/" | sort | uniq -c
   1084 arch
     20 block
     10 crypto
     32 Documentation
   8121 drivers
   1221 fs
    143 include
    101 kernel
     69 lib
    100 mm
   1510 net
     40 samples
      7 scripts
     11 security
    166 sound
    152 tools
      2 virt

> arch: 2512

arch is especially overestimated.
