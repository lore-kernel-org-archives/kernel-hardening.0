Date: Thu, 21 Jun 2018 10:51:41 +0800
From: Jun Yao <yaojun8558363@gmail.com>
Subject: Re: [PATCH 1/1] arm64/mm: move
 {idmap_pg_dir,tramp_pg_dir,swapper_pg_dir} to .rodata section
Message-ID: <20180621025141.GB11276@toy>
References: <20180620085755.20045-1-yaojun8558363@gmail.com>
 <20180620085755.20045-2-yaojun8558363@gmail.com>
 <CAKv+Gu8_=uTJFDXr0GpGMc=9WZ9tbz305CE6i=qbnqRB=suRVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8_=uTJFDXr0GpGMc=9WZ9tbz305CE6i=qbnqRB=suRVA@mail.gmail.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Ard,

On Wed, Jun 20, 2018 at 12:09:49PM +0200, Ard Biesheuvel wrote:
> On 20 June 2018 at 10:57, Jun Yao <yaojun8558363@gmail.com> wrote:
> > Move {idmap_pg_dir,tramp_pg_dir,swapper_pg_dir} to .rodata
> > section. And update the swapper_pg_dir by fixmap.
> >
> 
> I think we may be able to get away with not mapping idmap_pg_dir and
> tramp_pg_dir at all.

I think we need to move tramp_pg_dir to .rodata. The attacker can write
a block-mapping(AP=01) to tramp_pg_dir and then he can access kernel
memory.

> As for swapper_pg_dir, it would indeed be nice if we could keep those
> mappings read-only most of the time, but I'm not sure how useful this
> is if we apply it to the root level only.

The purpose of it is to make 'KSMA' harder, where an single arbitrary
write is used to add a block mapping to the page-tables, giving the
attacker full access to kernel memory. That's why we just apply it to
the root level only. If the attacker can arbitrary write multiple times,
I think it's hard to defend.

> > @@ -417,12 +421,22 @@ static void __init __map_memblock(pgd_t *pgdp, phys_addr_t start,
> >
> >  void __init mark_linear_text_alias_ro(void)
> >  {
> > +       unsigned long size;
> > +
> >         /*
> >          * Remove the write permissions from the linear alias of .text/.rodata
> > +        *
> > +        * We free some pages in .rodata at paging_init(), which generates a
> > +        * hole. And the hole splits .rodata into two pieces.
> >          */
> > +       size = (unsigned long)swapper_pg_dir + PAGE_SIZE - (unsigned long)_text;
> >         update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
> > -                           (unsigned long)__init_begin - (unsigned long)_text,
> > -                           PAGE_KERNEL_RO);
> > +                           size, PAGE_KERNEL_RO);
> > +
> > +       size = (unsigned long)__init_begin - (unsigned long)swapper_pg_end;
> > +       update_mapping_prot(__pa_symbol(swapper_pg_end),
> > +                           (unsigned long)lm_alias(swapper_pg_end),
> > +                           size, PAGE_KERNEL_RO);
> 
> I don't think this is necessary. Even if some pages are freed, it
> doesn't harm to keep a read-only alias of them here since the new
> owner won't access them via this mapping anyway. So we can keep
> .rodata as a single region.

To be honest, I didn't think of this issue at first. I later found a
problem when testing the code on qemu:

[    7.027935] Unable to handle kernel write to read-only memory at virtual address ffff800000f42c00
[    7.028388] Mem abort info:
[    7.028495]   ESR = 0x9600004f
[    7.028602]   Exception class = DABT (current EL), IL = 32 bits
[    7.028749]   SET = 0, FnV = 0
[    7.028837]   EA = 0, S1PTW = 0
[    7.028930] Data abort info:
[    7.029017]   ISV = 0, ISS = 0x0000004f
[    7.029120]   CM = 0, WnR = 1
[    7.029253] swapper pgtable: 4k pages, 48-bit VAs, pgdp =         (ptrval)
[    7.029418] [ffff800000f42c00] pgd=00000000beff6803, pud=00000000beff5803, pmd=00000000beff3803, pte=00e0000040f42f93
[    7.029807] Internal error: Oops: 9600004f [#1] PREEMPT SMP
[    7.030027] Modules linked in:
[    7.030256] CPU: 0 PID: 1321 Comm: jbd2/vda-8 Not tainted 4.17.0-rc4-02908-g0fe42512b2f0-dirty #71
[    7.030486] Hardware name: linux,dummy-virt (DT)
[    7.030708] pstate: 40400005 (nZcv daif +PAN -UAO)
[    7.030880] pc : __memset+0x16c/0x1c0
[    7.030993] lr : jbd2_journal_get_descriptor_buffer+0x7c/0xfc
[    7.031134] sp : ffff00000a8ebbe0
[    7.031264] x29: ffff00000a8ebbe0 x28: ffff80007c104800
[    7.031430] x27: ffff00000a8ebd98 x26: ffff80007c4410d0
[    7.031567] x25: ffff80007c441118 x24: 00000000ffffffff
[    7.031704] x23: ffff80007c41b000 x22: ffff0000090d9000
[    7.031838] x21: 0000000002000000 x20: ffff80007bcee800
[    7.031973] x19: ffff80007c4413a8 x18: 0000000000000727
[    7.032107] x17: 0000ffff89eba028 x16: ffff0000080e2c38
[    7.032286] x15: ffff7e0000000000 x14: 0000000000048018
[    7.032424] x13: 0000000048018c00 x12: ffff80007bc65788
[    7.032558] x11: ffff00000a8eba68 x10: 0000000000000040
[    7.032709] x9 : 0000000000000000 x8 : ffff800000f42c00
[    7.032849] x7 : 0000000000000000 x6 : 000000000000003f
[    7.032984] x5 : 0000000000000040 x4 : 0000000000000000
[    7.033119] x3 : 0000000000000004 x2 : 00000000000003c0
[    7.033254] x1 : 0000000000000000 x0 : ffff800000f42c00
[    7.033414] Process jbd2/vda-8 (pid: 1321, stack limit = 0x        (ptrval))
[    7.033633] Call trace:
[    7.033757]  __memset+0x16c/0x1c0
[    7.033858]  journal_submit_commit_record+0x60/0x174
[    7.033985]  jbd2_journal_commit_transaction+0xf38/0x1330
[    7.034115]  kjournald2+0xcc/0x250
[    7.034207]  kthread+0xfc/0x128
[    7.034295]  ret_from_fork+0x10/0x18
[    7.034718] Code: 91010108 54ffff4a 8b040108 cb050042 (d50b7428)
[    7.035104] ---[ end trace 26d65a14ae983167 ]---

/sys/kernel/debug/kernel_page_tables shows that:

---[ Linear Mapping ]---
0xffff800000000000-0xffff800000080000         512K PTE       RW NX SHD AF NG CON     UXN MEM/NORMAL
0xffff800000080000-0xffff800000200000        1536K PTE       ro NX SHD AF NG         UXN MEM/NORMAL
0xffff800000200000-0xffff800000e00000          12M PMD       RW NX SHD AF NG     BLK UXN MEM/NORMAL
0xffff800000e00000-0xffff800000fb0000        1728K PTE       ro NX SHD AF NG         UXN MEM/NORMAL

So I split it into pieces.

Thanks,

Jun
