Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160916233249.GB18931@jhogan-linux.le.imgtec.org>
References: <20160916203819.GA29767@roeck-us.net> <20160916212720.GA18931@jhogan-linux.le.imgtec.org>
 <20160916213718.GA32384@roeck-us.net> <20160916233249.GB18931@jhogan-linux.le.imgtec.org>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 16 Sep 2016 19:58:12 -0700
Message-ID: <CAGXu5jLYGcSq0Sdm4Mmd12dAJUbiyrkU-+4RwbHoo=OpWfvNFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: qemu:metag image runtime failure in -next due to 'kthread: allow
 to cancel kthread work'
To: James Hogan <james.hogan@imgtec.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-metag@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 16, 2016 at 4:32 PM, James Hogan <james.hogan@imgtec.com> wrote:
> On Fri, Sep 16, 2016 at 02:37:18PM -0700, Guenter Roeck wrote:
>> On Fri, Sep 16, 2016 at 10:27:20PM +0100, James Hogan wrote:
>> > On Fri, Sep 16, 2016 at 01:38:19PM -0700, Guenter Roeck wrote:
>> > > Hi,
>> > >
>> > > I see the following runtime error in -next when running a metag qemu emulation.
>> > >
>> > > [ ... ]
>> > > workingset: timestamp_bits=30 max_order=16 bucket_order=0
>> > > io scheduler noop registered (default)
>> > > brd: module loaded
>> > > Warning: unable to open an initial console.
>> > > List of all partitions:
>> > > 0100           16384 ram0  (driver?)
>> > > No filesystem could mount root, tried:
>> > > Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(1,0)
>> > >
>> > > An example for a complete log is at:
>> > > http://kerneltests.org/builders/qemu-metag-next/builds/489/steps/qemubuildcommand/logs/stdio
>> > >
>> > > bisect points to commit ef98de028afde ("kthread: allow to cancel kthread work").
>> > > I don't know (yet) if other architectures are affected. bisect log is attached.
>> > >
>> > > The scripts to run this test are available at
>> > > https://github.com/groeck/linux-build-test/tree/master/rootfs/metag.
>> > >
>> > > Guenter
>> >
>> > Thanks Guenter,
>> >
>> > It appears to be related to the command line. After that commit the
>> > command line is shown as empty (rather than your "rdinit=/sbin/init
>> > doreboot"), but it can still be overridden in the config and then it
>> > continues to work.
>> >
>> Weird.
>
> Previously the Elf had a single load program header:
>
> Program Headers:
>   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
>   LOAD           0x004000 0x40000000 0x40000000 0x34b304 0x376230 RWE 0x4000
>   NOTE           0x1ecc08 0x401e8c08 0x401e8c08 0x00000 0x00000 R   0x4
>
> QEMU puts the args at 40376230, straight after the load region (unlike a
> real Meta Linux bootloader).
>
> After the above commit the ELF gets two load program headers, with a
> small alignment gap in the middle:
>
> Program Headers:
>   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
>   LOAD           0x004000 0x40000000 0x40000000 0x18f118 0x18f118 R E 0x4000
>   LOAD           0x194000 0x40190000 0x40190000 0x1bd304 0x1e8230 RWE 0x4000
>   NOTE           0x1eec08 0x401eac08 0x401eac08 0x00000 0x00000 R   0x4
>
> Here this version of QEMU puts the args at where it thinks the end of
> the loaded image is, which is based on the number of bytes copied from
> the ELF, i.e. the total MemSiz's, not taking into account the alignment
> gap in between, so it puts them at 0x40377348.
>
> But of course:
> 40378230 B ___bss_stop
>
> so it wipes them out while clearing bss during early init.
>
> Previously:
> 4018ebd0 T __sdata
> 4018f000 R ___start_rodata
>
> now:
> 4018ed98 T __sdata
> 40190000 R ___start_rodata
>
> So I'm thinking this may have been triggered by c74ba8b3480d ("arch:
> Introduce post-init read-only memory").
>
> The hack below does indeed reduce it to a single load section and this
> version of QEMU then succeeds:
>
> Program Headers:
>   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
>   LOAD           0x004000 0x40000000 0x40000000 0x34d304 0x378230 RWE 0x4000
>   NOTE           0x1eec88 0x401eac88 0x401eac88 0x00000 0x00000 R   0x4
>
> diff --git a/arch/metag/include/asm/cache.h b/arch/metag/include/asm/cache.h
> index a43b650cfdc0..b5c7364a94da 100644
> --- a/arch/metag/include/asm/cache.h
> +++ b/arch/metag/include/asm/cache.h
> @@ -20,4 +20,6 @@
>
>  #define __read_mostly __attribute__((__section__(".data..read_mostly")))
>
> +#define __ro_after_init        __read_mostly
> +
>  #endif
>
> Kees: Is it expected to get multiple load headers like this since your
> patch c74ba8b3480d ("arch: Introduce post-init read-only memory"),
> depending on alignment of the read only section?

I'm not expecting that, and I'm especially not expecting any LOAD to
have "RWE" flags. It looks like metag's vmlinux.lds.S is using the
common RO_DATA_SECTION, so that doesn't jump out at me as a reason for
RO_AFTER_INIT_DATA to end up in the wrong place. Also the second LOAD
in the ELF is really huge, so it's not just the RO_AFTER_INIT_DATA
section (which is currently very small).

Could the metag linker be failing to override the section flags when
putting RO_AFTER_INIT_DATA into RO_DATA_SECTION and this cuts the LOAD
in half? This smells like a linker glitch.

However, since metag doesn't support CONFIG_DEBUG_RODATA, your above
patch is likely correct. If metag marks memory read-only at kernel
load time, it's doing it early enough that __ro_after_init will fail
to work. If it never marks memory read-only, then __ro_after_init will
have no effect. (i.e. Both situations need the proposed patch).

Probably the best solution for all architectures is to invent a new
CONFIG_ARCH_HAS... to identify the style of kernel memory protection a
given architecture has so that the default for __ro_after_init can be
more sensible (and the warnings about mark_rodata_ro() can better
reflect reality).

-Kees

-- 
Kees Cook
Nexus Security
