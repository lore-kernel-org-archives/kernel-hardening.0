Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 1 Apr 2016 10:44:04 +0200
From: Ralf Baechle <ralf@linux-mips.org>
Message-ID: <20160401084403.GA28123@linux-mips.org>
References: <1459415142-3412-1-git-send-email-matt.redfearn@imgtec.com>
 <1459415142-3412-12-git-send-email-matt.redfearn@imgtec.com>
 <56FD1A32.10204@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56FD1A32.10204@cogentembedded.com>
Subject: [kernel-hardening] Re: [PATCH v2 11/11] MIPS: KASLR: Print relocation Information on
 boot
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Matt Redfearn <matt.redfearn@imgtec.com>, linux-mips@linux-mips.org, kernel-hardening@lists.openwall.com, Aaro Koskinen <aaro.koskinen@nokia.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexander Sverdlin <alexander.sverdlin@gmail.com>, linux-kernel@vger.kernel.org, Jaedon Shin <jaedon.shin@gmail.com>, Jonas Gorski <jogo@openwrt.org>, Paul Burton <paul.burton@imgtec.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 31, 2016 at 03:38:10PM +0300, Sergei Shtylyov wrote:

> >When debugging a relocated kernel, the addresses of the relocated
> >symbols and the offset applied is essential information. If the kernel
> >is compiled with debugging information, then print this information
> >during bootup using the same function as the panic notifer.
> 
>    Notifier.

Fixed when merging.

> >Signed-off-by: Matt Redfearn <matt.redfearn@imgtec.com>
> >---
> >
> >Changes in v2: None
> >
> >  arch/mips/kernel/setup.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> >diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
> >index d8376d7b3345..ae71f8d9b555 100644
> >--- a/arch/mips/kernel/setup.c
> >+++ b/arch/mips/kernel/setup.c
> >@@ -477,9 +477,18 @@ static void __init bootmem_init(void)
> >  	 */
> >  	if (__pa_symbol(_text) > __pa_symbol(VMLINUX_LOAD_ADDRESS)) {
> >  		unsigned long offset;
> >+		extern void show_kernel_relocation(const char *level);
> >
> >  		offset = __pa_symbol(_text) - __pa_symbol(VMLINUX_LOAD_ADDRESS);
> >  		free_bootmem(__pa_symbol(VMLINUX_LOAD_ADDRESS), offset);
> >+
> >+#if (defined CONFIG_DEBUG_KERNEL) && (defined CONFIG_DEBUG_INFO)
> 
>    Not #if defined(CONFIG_DEBUG_KERNEL) && defined(CONFIG_DEBUG_INFO)?
> 
> [...]

CPP syntax is not what most people seem to believe that is the parenthesis
around the argument of defined are not required so above line is unusual
but perfectly ok.  However following boring standards is good so I changed
this, too.

  Ralf
