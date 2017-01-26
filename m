MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CACi5LpOkWV2t1MyYLjDckbkoBSx6QxOw7OVayx-GqWjhVHV1tQ@mail.gmail.com>
References: <CACi5LpOkWV2t1MyYLjDckbkoBSx6QxOw7OVayx-GqWjhVHV1tQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 25 Jan 2017 17:38:44 -0800
Message-ID: <CAGXu5j+4_XGHAhdmfmpESguEe8iqh8MpWHvtgnSUu149rcxs=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: Query regarding randomization bits for a ASLR elf on PPC64
To: Bhupesh Sharma <bhsharma@redhat.com>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, Daniel Cashman <dcashman@google.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 22, 2017 at 9:34 PM, Bhupesh Sharma <bhsharma@redhat.com> wrote:
> I was recently looking at ways to extend the randomization range for a
> ASLR elf on a PPC64LE system.
>
> I basically have been using 28-bits of randomization on x86_64 for an
> ASLR elf using appropriate ARCH_MMAP_RND_BITS_MIN and
> ARCH_MMAP_RND_BITS_MAX values:
>
> http://lxr.free-electrons.com/source/arch/x86/Kconfig#L192
>
> And I understand from looking at the PPC64 code base that both
> ARCH_MMAP_RND_BITS_MIN and ARCH_MMAP_RND_BITS_MAX are not used in the
> current upstream code.

Yeah, looks like PPC could use it. If you've got hardware to test
with, please add it. :)

> I am looking at ways to randomize the mmap, stack and brk ranges for a
> ALSR elf on PPC64LE. Currently I am using a PAGE SIZE of 64K in my
> config file and hence the randomization usually translates to
> something like this for me:

Just to be clear: 64K pages will lose you 4 bits of entropy when
compared to 4K on x86_64. (Assuming I'm doing the math right...)

> mmap:
> -------
> http://lxr.free-electrons.com/source/arch/powerpc/mm/mmap.c#L67
>
> rnd = get_random_long() % (1UL<<(30-PAGE_SHIFT));
>
> Since PAGE_SHIFT is 16 for 64K page size, this computation reduces to:
> rnd = get_random_long() % (1UL<<(14));
>
> If I compare this to x86_64, I see there:
>
> http://lxr.free-electrons.com/source/arch/x86/mm/mmap.c#L79
>
> rnd = get_random_long() & ((1UL << mmap_rnd_bits) - 1);
>
> So, if mmap_rnd_bits = 28, this equates to:
> rnd = get_random_long() & ((1UL << 28) - 1);
>
> Observations and Queries:
> --------------------------------------
>
> - So, x86_64 gives approx twice number of random bits for a ASLR elf
> running on it as compared to PPC64 although both use a 48-bit VA.
>
> - I also see this comment for PPC at various places, regarding 1GB
> randomness spread for PPC64. Is this restricted by the hardware or the
> kernel usage?:
>
> /* 8MB for 32bit, 1GB for 64bit */
>  64         if (is_32bit_task())
>  65                 rnd = get_random_long() % (1<<(23-PAGE_SHIFT));
>  66         else
>  67                 rnd = get_random_long() % (1UL<<(30-PAGE_SHIFT));

Yeah, I'm not sure about this. The comments above the MIN_GAP* macros
seem to talk about making sure there is the 1GB stack gap, but that
shouldn't limit mmap.

Stack base is randomized in fs/binfmt_elf.c randomize_stack_top()
which uses STACK_RND_MASK (and PAGE_SHIFT).

x86:
/* 1GB for 64bit, 8MB for 32bit */
#define STACK_RND_MASK (test_thread_flag(TIF_ADDR32) ? 0x7ff : 0x3fffff)

powerpc:
/* 1GB for 64bit, 8MB for 32bit */
#define STACK_RND_MASK (is_32bit_task() ? \
        (0x7ff >> (PAGE_SHIFT - 12)) : \
        (0x3ffff >> (PAGE_SHIFT - 12)))

So, in the 64k page case, stack randomization entropy is reduced, but
otherwise identical to x86.

x86 and powerpc both use arch_mmap_rnd() for both mmap and ET_DYN
(with different bases).

x86 uses ELF_ET_DYN_BASE as TASK_SIZE / 3 * 2 (which the ELF loader
pushes back up the nearest PAGE_SIZE alignment: 0x555555555000),
though powerpc uses 0x20000000, so it should have significantly more
space for mmap and ET_DYN ASLR than x86.

> - I tried to increase the randomness to 28 bits for PPC as well by
> making the PPC mmap, brk code equivalent to x86_64 and it works fine
> for my use case.

The PPC brk randomization on powerpc doesn't use the more common
randomize_page() way other archs do it...

        /* 8MB for 32bit, 1GB for 64bit */
        if (is_32bit_task())
                rnd = (get_random_long() % (1UL<<(23-PAGE_SHIFT)));
        else
                rnd = (get_random_long() % (1UL<<(30-PAGE_SHIFT)));

        return rnd << PAGE_SHIFT;

x86 uses 0x02000000 (via randomize_page()), which, if I'm doing the
math right is 14 bits, regardless of 32/64-bit. arm64 uses 0x40000000
(20 bits) on 64-bit processes and the same as x86 (14) for 32-bit
processes. Looks like powerpc uses either 13 or 20 for 4k pages, which
is close to the same.

> - But, I am not sure this is the right thing to do and whether the
> PPC64 also supports the MIN and MAX ranges for randomization.

It can support it once you implement the Kconfigs for it. :)

> - If it does I would like to understand, test and push a patch to
> implement the same for PPC64 in upstream.
>
> Sorry for the long mail, but would really appreciate if someone can
> help me understand the details here.

Hopefully this helped a bit. I would literally draw out the memory
map, and double-check nothing can collide at your max values.

-Kees

-- 
Kees Cook
Nexus Security
