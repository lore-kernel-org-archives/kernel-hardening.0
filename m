Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 28 Jun 2016 22:29:41 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160628222941.3f76a4a09767c0134a03a70b@gmail.com>
In-Reply-To: <20160628170022.GH22554@ld-linux.so>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
	<20160628170022.GH22554@ld-linux.so>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v1 0/2] Introduce the initify gcc plugin
To: Mathias Krause <minipli@ld-linux.so>
Cc: kernel-hardening@lists.openwall.com, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 28 Jun 2016 19:00:22 +0200
Mathias Krause <minipli@ld-linux.so> wrote:

> > section         vanilla                 vanilla + initify        change
> > -----------------------------------------------------------------------
> > .rodata         39059688 (0x25400e8)    38527210 (0x24be0ea)    -532478
> > .data           45744128 (0x2ba0000)    45404160 (0x2b4d000)    -339968
> > .init.data       1361144  (0x14c4f8)     1674200  (0x198bd8)    +313056
> > .text           77615128 (0x4a05018)    77576664 (0x49fb9d8)     -38464
> > .init.text       1108455  (0x10e9e7)     1137618  (0x115bd2)     +29163
> 
> You should probably provide numbers for .init.rodata.str, .exit.rodata.str
> and .exit.text as well. Otherwise this delta calculation suggests a rather
> gigantic image size reduction which is probably not the case ;)

init.rodata.str is an input section that merges into the INIT_DATA output section.
I didn't make statistics for exit* yet because I have a problem with that (I asked
for help in a previous e-mail).
 
> Also a comparison of the final kernel image size would be nice to see if

I no longer have the vmlinux images but I saved away the readelf outputs,
here's the PT_LOAD size data:

        FileSiz (vanilla)       FileSiz (vanilla+initify)       change
-----------------------------------------------------------------------
00      119189504 (0x71ab000)   118657024 (0x7129000)           -532480
01       45838336 (0x2bb7000)    45498368 (0x2b64000)           -339968
03        2830336  (0x2b3000)     3198976  (0x30d000)           +368640


00     .text .text.exit .text.startup .notes __ex_table .rodata __bug_table .pci_fixup
       .builtin_fw .tracedata __ksymtab __ksymtab_gpl __ksymtab_strings __init_rodata __param __modver
01     .data .fini_array .vvar
03     .init.text .altinstr_aux .init.data .x86_cpu_dev.init .parainstructions .altinstructions
       .altinstr_replacement .iommu_table .apicdrivers .exit.text .exit.data .smp_locks .bss .brk

I think the smaller .data section is wrong, so I'll look into it.

-- 
Emese
