MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170602152010.2064-3-riel@redhat.com>
References: <20170602152010.2064-1-riel@redhat.com> <20170602152010.2064-3-riel@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 2 Jun 2017 21:22:14 -0700
Message-ID: <CAGXu5jJp-U2o9JEicyvM=205P7072kN_UCwh7=+UNJ2Z1HWKvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 2/6] x86/elf: move 32 bit ELF_ET_DYN_BASE to 256MB
To: Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Larry Woodman <lwoodman@redhat.com>, mhocko@suse.de, Daniel Micay <danielmicay@gmail.com>, Will Deacon <will.deacon@arm.com>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 2, 2017 at 8:20 AM,  <riel@redhat.com> wrote:
> From: Rik van Riel <riel@redhat.com>
>
> When setting up mmap_base, we take care to start the mmap base
> below the maximum extent to which the stack will grow. However,
> we take no such precautions with PIE binaries, which are placed
> at 5/6 of TASK_SIZE plus a random offset. As a result, 32 bit PIE
> binaries can end up smack in the middle of where the stack (which
> is randomized down) is supposed to go.
>
> That problem can be avoided by putting the 32 bit ELF_ET_DYN_BASE
> at 256MB, which is a value linux-hardened and grsecurity have used
> for a long time now without any known (to me) bug reports.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  arch/x86/include/asm/elf.h | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
> index e8ab9a46bc68..dafa098cc05a 100644
> --- a/arch/x86/include/asm/elf.h
> +++ b/arch/x86/include/asm/elf.h
> @@ -245,12 +245,23 @@ extern int force_personality32;
>  #define CORE_DUMP_USE_REGSET
>  #define ELF_EXEC_PAGESIZE      4096
>
> +/*
> + * True on X86_32 or when emulating IA32 on X86_64
> + */
> +static inline int mmap_is_ia32(void)
> +{
> +       return IS_ENABLED(CONFIG_X86_32) ||
> +              (IS_ENABLED(CONFIG_COMPAT) &&
> +               test_thread_flag(TIF_ADDR32));
> +}
> +
>  /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
>     use of this is to invoke "./ld.so someprog" to test out a new version of
>     the loader.  We need to make sure that it is out of the way of the program
>     that it will "exec", and that there is sufficient room for the brk.  */
>
> -#define ELF_ET_DYN_BASE                (TASK_SIZE / 3 * 2)
> +#define ELF_ET_DYN_BASE                (mmap_is_ia32() ? 0x10000000UL : \
> +                               (TASK_SIZE / 3 * 2))

I like the idea of this change, but I don't like this implementation
for a few reasons.

Before that, let me just to state what I think our obvious goal is: we
want to have the userspace memory layout wasting as little space as
possible, and have regions separated enough to maximize the amount of
ASLR entropy we can use, all without allowing them to collide.

I the previous non-PIE world common execution case, the kernel loaded
statically located ET_EXEC programs and had brk, stack, and mmap
randomized. The only ET_DYN program that got directly executed was the
loader, but that was rare. In normal execution, it would get mapped
after the ET_EXEC. When testing new loaders and running it directly
like the comment above hints at (e.g. "/lib64/ld-linux-x86-64.so.2
/bin/some-et-exec"), the loader would get loaded first, so it might
collide with the static ET_EXEC if it wasn't moved away from the
ET_EXEC range, which is why ELF_ET_DYN_BASE exists and a test for
ET_DYN is done. It would be better to force ET_DYN into mmap base when
no PT_INTERP is found (see binfmt_elf.c's elf_interpreter).)

For the PIE case we end up with the ET_DYN at one end of the mmap
range, and mmap base at the high-address end (growing down toward the
ET_DYN). As a result, I'd like to see the executable ET_DYN (PIE) case
use the lowest possible base address. The (TASK_SIZE / 3 * 2) thing
has always bothered me as being highly wasteful of address space now
that most userspaces are doing full PIE. It made sense for the rare
directly loaded loaders, but now it's not great. (My first step toward
fixing this was getting all the architectures to agree on how
randomization was happening, and I think the next step is to fix the
loader collision issue and then bring all the architecture's
ELF_ET_DYN_BASE way way down (and likely rename the define to be more
clear).)

As a result of these things, I'm not sure I like the 256MB change, as
I'd rather we get the PIE base as low as possible. I *think* this
should match the ET_EXEC addresses: 32-bit x86 ET_EXEC loads at
0x8048000. 64-bit x86 ET_EXEC loads at 0x400000 (though maybe we can
take 32-bit lower still). However, the kernel needs to notice that
when running a loader, it should go into the mmap base like a .so,
which will keep out out of the way no matter what. However, then the
question becomes "can the brk be placed sanely?" since the brk is
allocated with whatever is mapped first.

So, specifically:

I don't believe this is safe in the face of a loader running an
ET_EXEC. If the loader is mapped at 0x10000000 (or otherwise very low
value of PIE ASLR), and the ET_EXEC is mapped at 0x8048000, so the
ET_EXEC had better not be 128MB or larger...

I think loading an ET_DYN that lacks PT_INTERP should be mapped into
the mmap base so that we can lower ELF_ET_DYN_BASE as far as possible
in the address space without concern over ET_EXEC collisions.
(ELF_ET_DYN_BASE should be named ELF_PIE_BASE maybe, since it
shouldn't be exclusively used for ET_DYN, it should only be for ET_DYN
with PT_INTERP. ET_DYN without PT_INTERP should get loaded into mmap
like the .so it is.)

I'm not sure what to do yet for set_brk() when an ET_DYN without
PT_INTERP is loaded into mmap base, but we need make sure we don't
create collisions or inappropriately small brk space.

Additionally, I think we need some runtime checking of the address
space layout min/max positionns to make sure we can't collide
anything. (And maybe some pretty ASCII-art to help visualize the
possible layouts, since we have several sets of variables to take into
account, including: execution style (ET_EXEC, direct loader, and PIE),
sysctl entropy sizing of the regions, and stack rlimit.)

-Kees

-- 
Kees Cook
Pixel Security
