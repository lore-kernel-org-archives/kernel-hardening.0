MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
References: <1509945567-11801-1-git-send-email-me@tobin.cc> <CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 7 Nov 2017 13:22:13 -0800
Message-ID: <CAGXu5j+o6cf0PrnxD+W+09F7UY6JL+h7Bn5_4T2C0Z_fTZAx-w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3] scripts: add leaking_addresses.pl
To: Linus Torvalds <torvalds@linux-foundation.org>, "Tobin C. Harding" <me@tobin.cc>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Joe Perches <joe@perches.com>
Cc: Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 6, 2017 at 9:27 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Nov 5, 2017 at 9:19 PM, Tobin C. Harding <me@tobin.cc> wrote:
>> Currently we are leaking addresses from the kernel to user space. This
>> script is an attempt to find some of those leakages. Script parses
>> `dmesg` output and /proc and /sys files for hex strings that look like
>> kernel addresses.
>
> Lovely. This is great. It shows just how much totally pointless stuff
> we leak, and to normal users that really shouldn't need it.
>
> I had planned to wait for 4.15 to look at the printk hashing stuff
> etc, but this part I think I could/should merge early just because I
> think a lot of kernel developers will go "Why the f*ck would we expose
> that kernel address there?"
>
> The module sections stuff etc should likely be obviously root-only,
> although maybe I'm missing some tool that ends up using it and is
> useful to normal developers.
>
> And I'm thinking we could make kallsyms smarter too, and instead of
> depending on kptr_restrict that screws over things with much too big a
> hammer, we could make it take 'perf_event_paranoid' into account. I
> suspect that's the main user of kallsyms that would still be relevant
> to non-root.

Linus, what do you have in mind for the root-only "yes we really need
the actual address output" exceptions?

For example, right now /sys/kernel/debug/kernel_page_tables
(CONFIG_X86_PTDUMP=y) needs actual address and currently uses %x.

Looking other places that stand out, it seems like
/proc/lockdep_chains and /proc/lockdep (CONFIG_LOCKDEP=y) has a ton of
%p usage. It's unclear to me if a hash is sufficient for meaningful
debugging there?

Seems like these three from dmesg could be removed?

[    0.000000] Base memory trampoline at [ffffa3fc40099000] 99000 size 24576
arch/x86/realmode/init.c

[    0.000000] percpu: Embedded 38 pages/cpu @ffffa4007fc00000 s116944
r8192 d30512 u524288
mm/percpu.c

[    0.456395] software IO TLB [mem 0xbbfdf000-0xbffdf000] (64MB)
mapped at [ffffa3fcfbfdf000-ffffa3fcfffdefff]
lib/swiotlb.c

Tobin, some other feedback on v4...

I find the output hard to parse. Instead of:

[27527 lockdep_chains] [ffffffffb226c628] cgroup_mutex

Could we have:

27527 /proc/lockdep_chains: [ffffffffb226c628] cgroup_mutex

At the very least, getting the full file path is needed or might not
be clear where something lives.

And for my kernels, I needed to exclude usbmon or the script would
hang (perhaps add a read timeout to the script to detect stalling
files?)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 282c0cc2bdea..a9b729c0a052 100644
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -70,6 +70,7 @@ my @skip_walk_dirs_any = ('self',
                          'thread-self',
                          'cwd',
                          'fd',
+                         'usbmon',
                          'stderr',
                          'stdin',
                          'stdout');


-Kees

-- 
Kees Cook
Pixel Security
