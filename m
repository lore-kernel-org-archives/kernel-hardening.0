Date: Tue, 17 Oct 2017 09:31:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171017093119.6dd98919@gandalf.local.home>
In-Reply-To: <1508215972-7769-1-git-send-email-me@tobin.cc>
References: <1508215972-7769-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 17 Oct 2017 15:52:51 +1100
"Tobin C. Harding" <me@tobin.cc> wrote:

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

Does %p[FfSs] leak addresses? Well, I guess it does if they are not
found in kallsyms, but otherwise you have:

  function+0x<offset>

-- Steve


> 
> arch: 2512
> block: 20
> crypto: 12
> fs: 1221
> include: 147
> kernel: 109
> lib: 77
> mm: 120
> net: 1516
> security: 11
> sound: 168
> virt: 2
> drivers: 8420
> 
> Add helper function siphash_1ulong(). Add function ptr_to_id() to map an
> address to a 32 bit unique identifier.
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>
