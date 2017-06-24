Date: Sat, 24 Jun 2017 10:11:11 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20170624091110.GX4902@n2100.armlinux.org.uk>
References: <1498251600-132458-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498251600-132458-1-git-send-email-keescook@chromium.org>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [kernel-hardening] Re: [PATCH v2 0/5] Use ELF_ET_DYN_BASE only for PIE
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Daniel Micay <danielmicay@gmail.com>, Qualys Security Advisory <qsa@qualys.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Pratyush Anand <panand@redhat.com>, James Hogan <james.hogan@imgtec.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 23, 2017 at 01:59:55PM -0700, Kees Cook wrote:
> This is v2 (to refresh the 5 patches in -mm) for moving ELF_ET_DYN_BASE
> safely lower. Changes are clarifications in the commit logs (suggested
> by mpe), a compat think-o fix for arm64 (thanks to Ard), and to add
> Rik and mpe's Acks.
> 
> Quoting patch 1/5:
> 
> The ELF_ET_DYN_BASE position was originally intended to keep loaders
> away from ET_EXEC binaries. (For example, running "/lib/ld-linux.so.2
> /bin/cat" might cause the subsequent load of /bin/cat into where the
> loader had been loaded.) With the advent of PIE (ET_DYN binaries with
> an INTERP Program Header), ELF_ET_DYN_BASE continued to be used since
> the kernel was only looking at ET_DYN. However, since ELF_ET_DYN_BASE
> is traditionally set at the top 1/3rd of the TASK_SIZE, a substantial
> portion of the address space is unused.

With existing kernels on ARM:

00010000-00017000 r-xp 00000000 08:01 270810     /bin/cat
00026000-00027000 r--p 00006000 08:01 270810     /bin/cat
00027000-00028000 rw-p 00007000 08:01 270810     /bin/cat
7f661000-7f679000 r-xp 00000000 08:01 281659     /lib/arm-linux-gnueabihf/ld-2.23.so
7f688000-7f689000 r--p 00017000 08:01 281659     /lib/arm-linux-gnueabihf/ld-2.23.so
7f689000-7f68a000 rw-p 00018000 08:01 281659     /lib/arm-linux-gnueabihf/ld-2.23.so

If the loader is loaded at 4MB, this means the size of an ET_EXEC
program is limited to less than 4MB - and distros aren't yet
building everything as PIE on ARM.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
