Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160919213741.GN18931@jhogan-linux.le.imgtec.org>
References: <20160916203819.GA29767@roeck-us.net> <20160916212720.GA18931@jhogan-linux.le.imgtec.org>
 <20160916213718.GA32384@roeck-us.net> <20160916233249.GB18931@jhogan-linux.le.imgtec.org>
 <CAGXu5jLYGcSq0Sdm4Mmd12dAJUbiyrkU-+4RwbHoo=OpWfvNFg@mail.gmail.com>
 <20160919135954.GJ18931@jhogan-linux.le.imgtec.org> <CAGXu5jKxULh3+bUPa4vjqSW52xSEHWon9aLgKQ03Vv_DdZs3TA@mail.gmail.com>
 <20160919213741.GN18931@jhogan-linux.le.imgtec.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Sep 2016 14:51:54 -0700
Message-ID: <CAGXu5jL6J3PNkxMi7UXj7jPVr6AQuHeMb2mygL4Y9thyi5M2TA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: qemu:metag image runtime failure in -next due to 'kthread: allow
 to cancel kthread work'
To: James Hogan <james.hogan@imgtec.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-metag@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 19, 2016 at 2:37 PM, James Hogan <james.hogan@imgtec.com> wrote:
> On Mon, Sep 19, 2016 at 12:53:49PM -0700, Kees Cook wrote:
>> On Mon, Sep 19, 2016 at 6:59 AM, James Hogan <james.hogan@imgtec.com> wrote:
>> > On Fri, Sep 16, 2016 at 07:58:12PM -0700, Kees Cook wrote:
>> >> On Fri, Sep 16, 2016 at 4:32 PM, James Hogan <james.hogan@imgtec.com> wrote:
>> >> > On Fri, Sep 16, 2016 at 02:37:18PM -0700, Guenter Roeck wrote:
>> >> >> On Fri, Sep 16, 2016 at 10:27:20PM +0100, James Hogan wrote:
>> >> >> > On Fri, Sep 16, 2016 at 01:38:19PM -0700, Guenter Roeck wrote:
>> >> >> > > Hi,
>> >> >> > >
>> >> >> > > I see the following runtime error in -next when running a metag qemu emulation.
>> >> >> > >
>> >> >> > > [ ... ]
>> >> >> > > workingset: timestamp_bits=30 max_order=16 bucket_order=0
>> >> >> > > io scheduler noop registered (default)
>> >> >> > > brd: module loaded
>> >> >> > > Warning: unable to open an initial console.
>> >> >> > > List of all partitions:
>> >> >> > > 0100           16384 ram0  (driver?)
>> >> >> > > No filesystem could mount root, tried:
>> >> >> > > Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(1,0)
>> >> >> > >
>> >> >> > > An example for a complete log is at:
>> >> >> > > http://kerneltests.org/builders/qemu-metag-next/builds/489/steps/qemubuildcommand/logs/stdio
>> >> >> > >
>> >> >> > > bisect points to commit ef98de028afde ("kthread: allow to cancel kthread work").
>> >> >> > > I don't know (yet) if other architectures are affected. bisect log is attached.
>> >> >> > >
>> >> >> > > The scripts to run this test are available at
>> >> >> > > https://github.com/groeck/linux-build-test/tree/master/rootfs/metag.
>> >> >> > >
>> >> >> > > Guenter
>> >> >> >
>> >> >> > Thanks Guenter,
>> >> >> >
>> >> >> > It appears to be related to the command line. After that commit the
>> >> >> > command line is shown as empty (rather than your "rdinit=/sbin/init
>> >> >> > doreboot"), but it can still be overridden in the config and then it
>> >> >> > continues to work.
>> >> >> >
>> >> >> Weird.
>> >> >
>> >> > Previously the Elf had a single load program header:
>> >> >
>> >> > Program Headers:
>> >> >   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
>> >> >   LOAD           0x004000 0x40000000 0x40000000 0x34b304 0x376230 RWE 0x4000
>> >> >   NOTE           0x1ecc08 0x401e8c08 0x401e8c08 0x00000 0x00000 R   0x4
>> >> >
>> >> > QEMU puts the args at 40376230, straight after the load region (unlike a
>> >> > real Meta Linux bootloader).
>> >> >
>> >> > After the above commit the ELF gets two load program headers, with a
>> >> > small alignment gap in the middle:
>> >> >
>> >> > Program Headers:
>> >> >   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
>> >> >   LOAD           0x004000 0x40000000 0x40000000 0x18f118 0x18f118 R E 0x4000
>> >> >   LOAD           0x194000 0x40190000 0x40190000 0x1bd304 0x1e8230 RWE 0x4000
>> >> >   NOTE           0x1eec08 0x401eac08 0x401eac08 0x00000 0x00000 R   0x4
>> >> >
>> >> > Here this version of QEMU puts the args at where it thinks the end of
>> >> > the loaded image is, which is based on the number of bytes copied from
>> >> > the ELF, i.e. the total MemSiz's, not taking into account the alignment
>> >> > gap in between, so it puts them at 0x40377348.
>> >> >
>> >> > But of course:
>> >> > 40378230 B ___bss_stop
>> >> >
>> >> > so it wipes them out while clearing bss during early init.
>> >> >
>> >> > Previously:
>> >> > 4018ebd0 T __sdata
>> >> > 4018f000 R ___start_rodata
>> >> >
>> >> > now:
>> >> > 4018ed98 T __sdata
>> >> > 40190000 R ___start_rodata
>> >> >
>> >> > So I'm thinking this may have been triggered by c74ba8b3480d ("arch:
>> >> > Introduce post-init read-only memory").
>> >> >
>> >> > The hack below does indeed reduce it to a single load section and this
>> >> > version of QEMU then succeeds:
>> >> >
>> >> > Program Headers:
>> >> >   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
>> >> >   LOAD           0x004000 0x40000000 0x40000000 0x34d304 0x378230 RWE 0x4000
>> >> >   NOTE           0x1eec88 0x401eac88 0x401eac88 0x00000 0x00000 R   0x4
>> >> >
>> >> > diff --git a/arch/metag/include/asm/cache.h b/arch/metag/include/asm/cache.h
>> >> > index a43b650cfdc0..b5c7364a94da 100644
>> >> > --- a/arch/metag/include/asm/cache.h
>> >> > +++ b/arch/metag/include/asm/cache.h
>> >> > @@ -20,4 +20,6 @@
>> >> >
>> >> >  #define __read_mostly __attribute__((__section__(".data..read_mostly")))
>> >> >
>> >> > +#define __ro_after_init        __read_mostly
>> >> > +
>> >> >  #endif
>> >> >
>> >> > Kees: Is it expected to get multiple load headers like this since your
>> >> > patch c74ba8b3480d ("arch: Introduce post-init read-only memory"),
>> >> > depending on alignment of the read only section?
>> >>
>> >> I'm not expecting that, and I'm especially not expecting any LOAD to
>> >> have "RWE" flags. It looks like metag's vmlinux.lds.S is using the
>> >> common RO_DATA_SECTION, so that doesn't jump out at me as a reason for
>> >> RO_AFTER_INIT_DATA to end up in the wrong place. Also the second LOAD
>> >> in the ELF is really huge, so it's not just the RO_AFTER_INIT_DATA
>> >> section (which is currently very small).
>> >>
>> >> Could the metag linker be failing to override the section flags when
>> >> putting RO_AFTER_INIT_DATA into RO_DATA_SECTION and this cuts the LOAD
>> >> in half? This smells like a linker glitch.
>> >
>> > Where is that section flags override supposed to be happening?
>> >
>> > The .rodata section is indeed becoming slightly larger to fit the
>> > ptmx_fops __ro_after_init, and in the process changing from flag A to
>> > flag WA (presumably means becoming writable).
>> >
>> > This then appears to be hitting the condition in the linker whereby a
>> > new segment is started if a writable section is found after a readonly
>> > section, and the sections are on separate pages:
>> >
>> > https://sourceware.org/git/?p=binutils.git;a=blob;f=bfd/elf.c;h=8df38ee37923c020994715f111a0ffc6bae83c8c;hb=HEAD#l3952
>>
>> Hm, well, I think x86, arm, and arm64 don't do this. They just clobber
>> the flags from the section and force it to match the master section
>> (i.e. ro_after_init gets rodata's flags).
>
> Okay. Please forgive my ignorance, I'm just trying to understand the
> mechanism, but is that thought to happen automatically due to
> *(.data..ro_after_init) being in a section after *(.rodata) in the
> linker script?
>
> The definition in question is:
> static struct file_operations ptmx_fops __ro_after_init;
>
> Which isn't const or anything, so I'm not sure how else the linker is
> supposed to know to make a section read-only that contains non-read-only
> data.
>
>
> Okay, I just built x86_64 default defconfig (on ef98de028afd, half way
> through the mm patches on linux-next from the other day where metag
> stopped booting). Perhaps I'm missing some important config option to
> enable the memory protection (if so I appologise).
>
> For metag:
>
> $ readelf -S drivers/tty/pty.o
>   [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
>   [51] .data..ro_after_i PROGBITS        00000000 00f0c0 00007c 00  WA  0   0  4
>
> $ readelf -S vmlinux.bust:
>   [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
>   [ 4] .rodata           PROGBITS        40190000 194000 04c9c8 00  WA  0   0 64
>
> And x86_64:
>
> $ readelf -S drivers/tty/pty.o
>   [Nr] Name              Type             Address           Offset
>        Size              EntSize          Flags  Link  Info  Align
>   [18] .data..ro_after_i PROGBITS         0000000000000000  00001140
>        00000000000000f8  0000000000000000  WA       0     0     64
>
> $ readelf -S vmlinux
>   [Nr] Name              Type             Address           Offset
>        Size              EntSize          Flags  Link  Info  Align
>   [ 4] .rodata           PROGBITS         ffffffff81a00000  00c00000
>        00000000002663d0  0000000000000000  WA       0     0     4096
>
> Both have WA on that section in the object file and the final vmlinux
> ELF too.

Hm, very true, I never noticed that. Oddly, the LOAD flags don't pay
any attention on x86:

$ readelf -l vmlinux

Elf file type is EXEC (Executable file)
Entry point 0x1000000
There are 5 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  LOAD           0x0000000000200000 0xffffffff81000000 0x0000000001000000
                 0x0000000000fdc000 0x0000000000fdc000  R E    200000
  LOAD           0x0000000001200000 0xffffffff82000000 0x0000000002000000
                 0x0000000000155000 0x0000000000155000  RW     200000
  LOAD           0x0000000001400000 0x0000000000000000 0x0000000002155000
                 0x0000000000019488 0x0000000000019488  RW     200000
  LOAD           0x000000000156f000 0xffffffff8216f000 0x000000000216f000
                 0x0000000000122000 0x0000000000eb4000  RWE    200000
  NOTE           0x0000000000ca0248 0xffffffff81aa0248 0x0000000001aa0248
                 0x0000000000000024 0x0000000000000024         4

 Section to Segment mapping:
  Segment Sections...
   00     .text .notes __ex_table .rodata __bug_table .pci_fixup
.builtin_fw .tracedata __ksymtab __ksymtab_gpl __ksymtab_strings
__param __modver
   01     .data .vvar
   02     .data..percpu
   03     .init.text .altinstr_aux .init.data .x86_cpu_dev.init
.altinstructions .altinstr_replacement .iommu_table .apicdrivers
.exit.text .smp_locks .bss .brk
   04     .notes

The first load (containing .rodata) is "R E".

But, the point is: the kernel is what sets up the permissions, so the
flags are ignored anyway.

-Kees

-- 
Kees Cook
Nexus Security
