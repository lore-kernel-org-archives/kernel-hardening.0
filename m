References: <20170522013233.21780-1-dja@axtens.net>
 <20170522013233.21780-3-dja@axtens.net>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Mon, 22 May 2017 14:38:03 +1000
MIME-Version: 1.0
In-Reply-To: <20170522013233.21780-3-dja@axtens.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <a523ab3b-95c9-96ba-b3f0-cb374107b06e@au1.ibm.com>
Subject: [kernel-hardening] Re: [PATCH 2/2] powerpc: Make feature-fixup tests fortify-safe
To: Daniel Axtens <dja@axtens.net>, kernel-hardening@lists.openwall.com, linuxppc-dev@lists.ozlabs.org
Cc: Daniel Micay <danielmicay@gmail.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 22/05/17 11:32, Daniel Axtens wrote:
> Testing the fortified string functions[1] would cause a kernel
> panic on boot in test_feature_fixups() due to a buffer overflow
> in memcmp.
>
> This boils down to things like this:
>
>   extern unsigned int ftr_fixup_test1;
>   extern unsigned int ftr_fixup_test1_orig;
>
>   check(memcmp(&ftr_fixup_test1, &ftr_fixup_test1_orig, size) == 0);
>
> We know that these are asm labels so it is safe to read up to
> 'size' bytes at those addresses.
>
> However, because we have passed the address of a single unsigned
> int to memcmp, the compiler believes the underlying object is in
> fact a single unsigned int. So if size > sizeof(unsigned int),
> there will be a panic at runtime.
>
> We can fix this by changing the types: instead of calling the asm
> labels unsigned ints, call them unsigned int[]s. Therefore the
> size isn't incorrectly determined at compile time and we get a
> regular unsafe memcmp and no panic.
>
> [1] http://openwall.com/lists/kernel-hardening/2017/05/09/2
>
> Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Daniel Micay <danielmicay@gmail.com>
> Signed-off-by: Daniel Axtens <dja@axtens.net>

With this patch on top of Kees' fortify branch, my Tuleta boots 
powernv_defconfig baremetal with no obvious regressions.

Tested-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

Patch looks sane enough too.

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>


-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
