Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed, 17 Feb 2016 14:41:17 -0800
Message-Id: <1455748879-21872-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1455748879-21872-1-git-send-email-keescook@chromium.org>
References: <1455748879-21872-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 6/7] x86, vdso: mark vDSO read-only after init
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, David Brown <david.brown@linaro.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

The vDSO does not need to be writable after __init, so mark it as
__ro_after_init. The result kills the exploit method of writing to the
vDSO from kernel space resulting in userspace executing the modified code,
as shown here to bypass SMEP restrictions: http://itszn.com/blog/?p=21

The memory map (with added vDSO address reporting) shows the vDSO moving
into read-only memory:

Before:
[    0.143067] vDSO @ ffffffff82004000
[    0.143551] vDSO @ ffffffff82006000
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000      16M                         pmd
0xffffffff81000000-0xffffffff81800000       8M   ro     PSE     GLB x  pmd
0xffffffff81800000-0xffffffff819f3000    1996K   ro             GLB x  pte
0xffffffff819f3000-0xffffffff81a00000      52K   ro                 NX pte
0xffffffff81a00000-0xffffffff81e00000       4M   ro     PSE     GLB NX pmd
0xffffffff81e00000-0xffffffff81e05000      20K   ro             GLB NX pte
0xffffffff81e05000-0xffffffff82000000    2028K   ro                 NX pte
0xffffffff82000000-0xffffffff8214f000    1340K   RW             GLB NX pte
0xffffffff8214f000-0xffffffff82281000    1224K   RW                 NX pte
0xffffffff82281000-0xffffffff82400000    1532K   RW             GLB NX pte
0xffffffff82400000-0xffffffff83200000      14M   RW     PSE     GLB NX pmd
0xffffffff83200000-0xffffffffc0000000     974M                         pmd

After:
[    0.145062] vDSO @ ffffffff81da1000
[    0.146057] vDSO @ ffffffff81da4000
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000      16M                         pmd
0xffffffff81000000-0xffffffff81800000       8M   ro     PSE     GLB x  pmd
0xffffffff81800000-0xffffffff819f3000    1996K   ro             GLB x  pte
0xffffffff819f3000-0xffffffff81a00000      52K   ro                 NX pte
0xffffffff81a00000-0xffffffff81e00000       4M   ro     PSE     GLB NX pmd
0xffffffff81e00000-0xffffffff81e0b000      44K   ro             GLB NX pte
0xffffffff81e0b000-0xffffffff82000000    2004K   ro                 NX pte
0xffffffff82000000-0xffffffff8214c000    1328K   RW             GLB NX pte
0xffffffff8214c000-0xffffffff8227e000    1224K   RW                 NX pte
0xffffffff8227e000-0xffffffff82400000    1544K   RW             GLB NX pte
0xffffffff82400000-0xffffffff83200000      14M   RW     PSE     GLB NX pmd
0xffffffff83200000-0xffffffffc0000000     974M                         pmd

Based on work by PaX Team and Brad Spengler.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Andy Lutomirski <luto@kernel.org>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/entry/vdso/vdso2c.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/vdso/vdso2c.h b/arch/x86/entry/vdso/vdso2c.h
index abe961c7c71c..63a03bb91497 100644
--- a/arch/x86/entry/vdso/vdso2c.h
+++ b/arch/x86/entry/vdso/vdso2c.h
@@ -140,7 +140,7 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 	fprintf(outfile, "#include <asm/vdso.h>\n");
 	fprintf(outfile, "\n");
 	fprintf(outfile,
-		"static unsigned char raw_data[%lu] __page_aligned_data = {",
+		"static unsigned char raw_data[%lu] __ro_after_init __aligned(PAGE_SIZE) = {",
 		mapping_size);
 	for (j = 0; j < stripped_len; j++) {
 		if (j % 10 == 0)
-- 
2.6.3
