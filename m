Reply-To: kernel-hardening@lists.openwall.com
References: <1453226922-16831-1-git-send-email-keescook@chromium.org>
 <1453226922-16831-9-git-send-email-keescook@chromium.org>
From: "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <569EF642.90302@zytor.com>
Date: Tue, 19 Jan 2016 18:51:46 -0800
MIME-Version: 1.0
In-Reply-To: <1453226922-16831-9-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4 8/8] x86, vdso: mark vDSO read-only after init
To: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 01/19/16 10:08, Kees Cook wrote:
> The vDSO does not need to be writable after __init, so mark it as
> __ro_after_init. The result kills the exploit method of writing to the
> vDSO from kernel space resulting in userspace executing the modified code,
> as shown here to bypass SMEP restrictions: http://itszn.com/blog/?p=21
> 
> The memory map (with added vDSO address reporting) shows the vDSO moving
> into read-only memory:
> 
> Before:
> [    0.143067] vDSO @ ffffffff82004000
> [    0.143551] vDSO @ ffffffff82006000
> ---[ High Kernel Mapping ]---
> 0xffffffff80000000-0xffffffff81000000      16M                         pmd
> 0xffffffff81000000-0xffffffff81800000       8M   ro     PSE     GLB x  pmd
> 0xffffffff81800000-0xffffffff819f3000    1996K   ro             GLB x  pte
> 0xffffffff819f3000-0xffffffff81a00000      52K   ro                 NX pte
> 0xffffffff81a00000-0xffffffff81e00000       4M   ro     PSE     GLB NX pmd
> 0xffffffff81e00000-0xffffffff81e05000      20K   ro             GLB NX pte
> 0xffffffff81e05000-0xffffffff82000000    2028K   ro                 NX pte
> 0xffffffff82000000-0xffffffff8214f000    1340K   RW             GLB NX pte
> 0xffffffff8214f000-0xffffffff82281000    1224K   RW                 NX pte
> 0xffffffff82281000-0xffffffff82400000    1532K   RW             GLB NX pte
> 0xffffffff82400000-0xffffffff83200000      14M   RW     PSE     GLB NX pmd
> 0xffffffff83200000-0xffffffffc0000000     974M                         pmd
> 
> After:
> [    0.145062] vDSO @ ffffffff81da1000
> [    0.146057] vDSO @ ffffffff81da4000
> ---[ High Kernel Mapping ]---
> 0xffffffff80000000-0xffffffff81000000      16M                         pmd
> 0xffffffff81000000-0xffffffff81800000       8M   ro     PSE     GLB x  pmd
> 0xffffffff81800000-0xffffffff819f3000    1996K   ro             GLB x  pte
> 0xffffffff819f3000-0xffffffff81a00000      52K   ro                 NX pte
> 0xffffffff81a00000-0xffffffff81e00000       4M   ro     PSE     GLB NX pmd
> 0xffffffff81e00000-0xffffffff81e0b000      44K   ro             GLB NX pte
> 0xffffffff81e0b000-0xffffffff82000000    2004K   ro                 NX pte
> 0xffffffff82000000-0xffffffff8214c000    1328K   RW             GLB NX pte
> 0xffffffff8214c000-0xffffffff8227e000    1224K   RW                 NX pte
> 0xffffffff8227e000-0xffffffff82400000    1544K   RW             GLB NX pte
> 0xffffffff82400000-0xffffffff83200000      14M   RW     PSE     GLB NX pmd
> 0xffffffff83200000-0xffffffffc0000000     974M                         pmd
> 
> Based on work by PaX Team and Brad Spengler.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Andy Lutomirski <luto@kernel.org>

Acked-by: H. Peter Anvin <hpa@linux.intel.com>
