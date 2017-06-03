Message-ID: <1496491036.13303.4.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sat, 03 Jun 2017 07:57:16 -0400
In-Reply-To: <CAGXu5jJp-U2o9JEicyvM=205P7072kN_UCwh7=+UNJ2Z1HWKvg@mail.gmail.com>
References: <20170602152010.2064-1-riel@redhat.com>
	 <20170602152010.2064-3-riel@redhat.com>
	 <CAGXu5jJp-U2o9JEicyvM=205P7072kN_UCwh7=+UNJ2Z1HWKvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 2/6] x86/elf: move 32 bit ELF_ET_DYN_BASE to 256MB
To: Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Larry Woodman <lwoodman@redhat.com>, mhocko@suse.de, Will Deacon <will.deacon@arm.com>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2017-06-02 at 21:22 -0700, Kees Cook wrote:
> On Fri, Jun 2, 2017 at 8:20 AM,  <riel@redhat.com> wrote:
> > From: Rik van Riel <riel@redhat.com>
> > 
> > When setting up mmap_base, we take care to start the mmap base
> > below the maximum extent to which the stack will grow. However,
> > we take no such precautions with PIE binaries, which are placed
> > at 5/6 of TASK_SIZE plus a random offset. As a result, 32 bit PIE
> > binaries can end up smack in the middle of where the stack (which
> > is randomized down) is supposed to go.
> > 
> > That problem can be avoided by putting the 32 bit ELF_ET_DYN_BASE
> > at 256MB, which is a value linux-hardened and grsecurity have used
> > for a long time now without any known (to me) bug reports.
> > 
> > Signed-off-by: Rik van Riel <riel@redhat.com>
> > ---
> >  arch/x86/include/asm/elf.h | 23 ++++++++++++-----------
> >  1 file changed, 12 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
> > index e8ab9a46bc68..dafa098cc05a 100644
> > --- a/arch/x86/include/asm/elf.h
> > +++ b/arch/x86/include/asm/elf.h
> > @@ -245,12 +245,23 @@ extern int force_personality32;
> >  #define CORE_DUMP_USE_REGSET
> >  #define ELF_EXEC_PAGESIZE      4096
> > 
> > +/*
> > + * True on X86_32 or when emulating IA32 on X86_64
> > + */
> > +static inline int mmap_is_ia32(void)
> > +{
> > +       return IS_ENABLED(CONFIG_X86_32) ||
> > +              (IS_ENABLED(CONFIG_COMPAT) &&
> > +               test_thread_flag(TIF_ADDR32));
> > +}
> > +
> >  /* This is the location that an ET_DYN program is loaded if
> > exec'ed.  Typical
> >     use of this is to invoke "./ld.so someprog" to test out a new
> > version of
> >     the loader.  We need to make sure that it is out of the way of
> > the program
> >     that it will "exec", and that there is sufficient room for the
> > brk.  */
> > 
> > -#define ELF_ET_DYN_BASE                (TASK_SIZE / 3 * 2)
> > +#define ELF_ET_DYN_BASE                (mmap_is_ia32() ?
> > 0x10000000UL : \
> > +                               (TASK_SIZE / 3 * 2))
> 
> I like the idea of this change, but I don't like this implementation
> for a few reasons.
> 
> Before that, let me just to state what I think our obvious goal is: we
> want to have the userspace memory layout wasting as little space as
> possible, and have regions separated enough to maximize the amount of
> ASLR entropy we can use, all without allowing them to collide.
> 
> I the previous non-PIE world common execution case, the kernel loaded
> statically located ET_EXEC programs and had brk, stack, and mmap
> randomized. The only ET_DYN program that got directly executed was the
> loader, but that was rare. In normal execution, it would get mapped
> after the ET_EXEC. When testing new loaders and running it directly
> like the comment above hints at (e.g. "/lib64/ld-linux-x86-64.so.2
> /bin/some-et-exec"), the loader would get loaded first, so it might
> collide with the static ET_EXEC if it wasn't moved away from the
> ET_EXEC range, which is why ELF_ET_DYN_BASE exists and a test for
> ET_DYN is done. It would be better to force ET_DYN into mmap base when
> no PT_INTERP is found (see binfmt_elf.c's elf_interpreter).)
> 
> For the PIE case we end up with the ET_DYN at one end of the mmap
> range, and mmap base at the high-address end (growing down toward the
> ET_DYN). As a result, I'd like to see the executable ET_DYN (PIE) case
> use the lowest possible base address. The (TASK_SIZE / 3 * 2) thing
> has always bothered me as being highly wasteful of address space now
> that most userspaces are doing full PIE. It made sense for the rare
> directly loaded loaders, but now it's not great. (My first step toward
> fixing this was getting all the architectures to agree on how
> randomization was happening, and I think the next step is to fix the
> loader collision issue and then bring all the architecture's
> ELF_ET_DYN_BASE way way down (and likely rename the define to be more
> clear).)
> 
> As a result of these things, I'm not sure I like the 256MB change, as
> I'd rather we get the PIE base as low as possible. I *think* this
> should match the ET_EXEC addresses: 32-bit x86 ET_EXEC loads at
> 0x8048000. 64-bit x86 ET_EXEC loads at 0x400000 (though maybe we can
> take 32-bit lower still). However, the kernel needs to notice that
> when running a loader, it should go into the mmap base like a .so,
> which will keep out out of the way no matter what. However, then the
> question becomes "can the brk be placed sanely?" since the brk is
> allocated with whatever is mapped first.
>
> So, specifically:
> 
> I don't believe this is safe in the face of a loader running an
> ET_EXEC. If the loader is mapped at 0x10000000 (or otherwise very low
> value of PIE ASLR), and the ET_EXEC is mapped at 0x8048000, so the
> ET_EXEC had better not be 128MB or larger...
> 
> I think loading an ET_DYN that lacks PT_INTERP should be mapped into
> the mmap base so that we can lower ELF_ET_DYN_BASE as far as possible
> in the address space without concern over ET_EXEC collisions.
> (ELF_ET_DYN_BASE should be named ELF_PIE_BASE maybe, since it
> shouldn't be exclusively used for ET_DYN, it should only be for ET_DYN
> with PT_INTERP. ET_DYN without PT_INTERP should get loaded into mmap
> like the .so it is.)
> 
> I'm not sure what to do yet for set_brk() when an ET_DYN without
> PT_INTERP is loaded into mmap base, but we need make sure we don't
> create collisions or inappropriately small brk space.

Today, allocators either know how to fall back to using mmap if the brk
heap runs out (glibc, musl) or they don't use brk at all (jemalloc i.e.
Android, Firefox, redis, mariadb, etc. and others like OpenBSD malloc).

However, they didn't all do that in the past, so there are static
executables / old C libraries that may fail if loaded in a way where
they don't end up getting a usable area for brk. This was actually the
case until fairly recently for musl and some other lesser used C
libraries may not deal with it sanely yet. Isn't that already the case
since the interpreter simply goes in the mmap region with the brk heap
on top? Both ASLR and compatibility are broken right now, rather than
just compatibility for the loader edge for massive non-position
independent executables.

You could detect the interpreter case and map that into the middle of
the address space, but the current choice is too high to work properly
and that problem gets worse if stack entropy is fixed (not included in
this set). vm.mmap_rnd_bits allows up to 16 bits on 32-bit, which is
256M, so there's already up to 512M used at the top of the address space
for mmap base ASLR + stack base ASLR if it's fixed to follow the sysctl.
  It seems the stack rlimit can consume 5/6 of the address space at the
moment... The executable base already has up to a 256M shift already.

On 64-bit, I think 4G is a sensible base because it avoids causing
compatibility issues with users of the low 4G address space. An example
is the Android Runtime which still uses 32-bit pointers on 64-bit, so it
 needs to put the garbage collected heap and application code in the
lower 4G which makes lower 4G memory into a scarce resource. I think
it's likely add real 64-bit support in the near future but it still
wouldn't be normal to use it in practice since it'd be less efficient.

x86_64 has 128TiB address space for 32-bit so a 4G offset doesn't really
matter. arm64 address space is as large with 4 level page tables which
isn't typical so it's really usually 256G for userspace. 4G offset is
still okay there.

> Additionally, I think we need some runtime checking of the address
> space layout min/max positionns to make sure we can't collide
> anything. (And maybe some pretty ASCII-art to help visualize the
> possible layouts, since we have several sets of variables to take into
> account, including: execution style (ET_EXEC, direct loader, and PIE),
> sysctl entropy sizing of the regions, and stack rlimit.)
> 
> -Kees
> 
