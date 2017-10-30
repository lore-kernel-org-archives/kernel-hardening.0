Date: Tue, 31 Oct 2017 09:45:44 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171030224544.GZ12341@eros>
References: <1509317956-28041-1-git-send-email-me@tobin.cc>
 <CAGXu5j+NG3N9_q_Gpcq2a6tyewtuxwOnCm34xmYd369W9eP_BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+NG3N9_q_Gpcq2a6tyewtuxwOnCm34xmYd369W9eP_BA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH V9] printk: hash addresses printed with %p
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 30, 2017 at 03:31:41PM -0700, Kees Cook wrote:
> On Sun, Oct 29, 2017 at 3:59 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > Currently there are many places in the kernel where addresses are being
> > printed using an unadorned %p. Kernel pointers should be printed using
> > %pK allowing some control via the kptr_restrict sysctl. Exposing addresses
> > gives attackers sensitive information about the kernel layout in memory.
> >
> > We can reduce the attack surface by hashing all addresses printed with
> > %p. This will of course break some users, forcing code printing needed
> > addresses to be updated.
> >
> > For what it's worth, usage of unadorned %p can be broken down as
> > follows (thanks to Joe Perches).
> >
> > $ git grep -E '%p[^A-Za-z0-9]' | cut -f1 -d"/" | sort | uniq -c
> >    1084 arch
> >      20 block
> >      10 crypto
> >      32 Documentation
> >    8121 drivers
> >    1221 fs
> >     143 include
> >     101 kernel
> >      69 lib
> >     100 mm
> >    1510 net
> >      40 samples
> >       7 scripts
> >      11 security
> >     166 sound
> >     152 tools
> >       2 virt
> >
> > Add function ptr_to_id() to map an address to a 32 bit unique
> > identifier. Hash any unadorned usage of specifier %p and any malformed
> > specifiers.
> >
> > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> >
> > ---
> >
> > It seems we don't have consensus on a couple of things
> >
> > 1. The size of the hashed address on 64 bit architectures.
> > 2. The use of '0x' pre-fix for hashed addresses.
> >
> > In regards to (1), we are agreed that we only need 32 bits of
> > information. There is some questions however that outputting _only_ 32
> > bits may break userland.
> >
> > In regards to (2), irrespective of the arguments for and against, if
> > point 1 is correct and changing the format will break userland then we
> > can't add the '0x' suffix for the same reason.
> >
> > Therefore this patch masks off the first 32 bits, retaining
> > only 32 bits of information. We do not add a '0x' suffix. All in all,
> > that results in _no_ change to the format of output only the content of
> > the output.
> >
> > The leading 0's also make explicit that we have messed with the address,
> > maybe this will save some debugging time by doing so. Although this
> > would probably already be obvious since there is no leading 'ffff'.
> >
> > We hash malformed specifiers also. Malformed specifiers include
> > incomplete (e.g %pi) and also non-existent specifiers. checkpatch should
> > warn for non-existent specifiers but AFAICT won't warn for incomplete
> > specifiers.
> >
> > Here is the behaviour that this patch implements.
> >
> > For kpt_restrict==0
> >
> > Randomness not ready:
> >   printed with %p:              (pointer value)     # NOTE: with padding
> > Valid pointer:
> >   printed with %pK:             deadbeefdeadbeef
> >   printed with %p:              00000000deadbeef
> >   malformed specifier (eg %i):  00000000deadbeef
> > NULL pointer:
> >   printed with %pK:             0000000000000000
> >   printed with %p:                       (null)     # NOTE: with padding
> >   malformed specifier (eg %i):           (null)
> >
> > For kpt_restrict==2
> >
> > Valid pointer:
> >   printed with %pK:             0000000000000000
> >
> > All other output as for kptr_restrict==0
> >
> > V9:
> >  - Drop the initial patch from V8, leaving null pointer handling as is.
> >  - Print the hashed ID _without_ a '0x' suffix.
> >  - Mask the first 32 bits of the hashed ID to all zeros on 64 bit
> >    architectures.
> 
> Oops, I had missed v9. This addresses my concerns. I think the leading
> zeros are a good way to identify the "this is clearly not a kernel
> address" issue (though the 32-bit folks may remain confused, but we
> can fix that later, IMO).

Awesome. Yeah this patch (coupled with the leaking_addresses.pl script)
is turning out to be a bit 64-bit centric. However, as we plug more
leaks in 64-bit kernels hopefully they will be plugged in 32-bit ones
too.

I can't think of any way to have leaking_addresses.pl grep for 32-bit
addresses, especially once/if this patch gets merged. We will not be
able to differentiate between hashed addresses and real addresses on
32-bit machines.

thanks,
Tobin.
