From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Mon,  5 Jun 2017 11:33:11 +0530
Message-Id: <1496642591-1373-1-git-send-email-bhsharma@redhat.com>
Subject: [kernel-hardening] [PATCH] powerpc: Increase ELF_ET_DYN_BASE to 1TB for 64-bit applications
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: bhupesh.linux@gmail.com, Bhupesh Sharma <bhsharma@redhat.com>, Anton Blanchard <anton@samba.org>, Daniel Cashman <dcashman@android.com>, Kees Cook <keescook@chromium.org>, Michael Ellerman <mpe@ellerman.id.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-ID: <kernel-hardening.lists.openwall.com>

Since 7e60d1b427c51cf2525e5d736a71780978cfb828, the ELF_ET_DYN_BASE
for powerpc applications has been set to 512MB.

Recently there have been several reports of applications SEGV'ing
and newer version of glibc also SEGV'ing (while testing) when using the following
test method:

    LD_LIBRARY_PATH=/XXX/lib /XXX/lib/ld-2.24.so <binary>

For reproducing the above, consider the following test application which
uses a larger bss:

    1.
    # cat large-bss-test-app.c
 
    	#include <stdio.h>
    	#include <unistd.h>
    	#define VECSIZE (1024 * 1024 * 100)
    
    	float p[VECSIZE], v1[VECSIZE], v2[VECSIZE];
    
    	void vec_mult(long int N) {
    		long int i;
    		for (i = 0; i < N; i++)
    			p[i] = v1[i] * v2[i];
    	}
    
    	int main() {
        		char command[1024];
    		sprintf(command,"cat /proc/%d/maps",getpid());
    		system(command);
    
       		vec_mult(VECSIZE/100);
       		printf ("Done\n");
    		return 0;
    	}
    
    2. Compile it using gcc (I am using gcc-6.3.1):
    # gcc -g -o large-bss-test-app large-bss-test-app.c
    
    3. Running the compiled application with ld.so directly is enough to trigger the SEGV
       on ppc64le/ppc64:
    # /lib64/ld-2.24.so ./large-bss-test-app 
    Segmentation fault (core dumped)
    
    4. Notice it's random depending on the layout changes, so it passes on some occassions as well:
    # /lib64/ld-2.24.so ./large-bss-test-app
    10000000-10010000 r-xp 00000000 fd:00 2883597                            /root/large-bss-test-app
    10010000-10020000 r--p 00000000 fd:00 2883597                            /root/large-bss-test-app
    10020000-10030000 rw-p 00010000 fd:00 2883597                            /root/large-bss-test-app
    10030000-5b030000 rw-p 00000000 00:00 0
    5e950000-5e990000 r-xp 00000000 fd:00 1180301                            /usr/lib64/ld-2.24.so
    5e990000-5e9a0000 r--p 00030000 fd:00 1180301                            /usr/lib64/ld-2.24.so
    5e9a0000-5e9b0000 rw-p 00040000 fd:00 1180301                            /usr/lib64/ld-2.24.so
    3fffa3680000-3fffa3860000 r-xp 00000000 fd:00 1180308                    /usr/lib64/libc-2.24.so
    3fffa3860000-3fffa3870000 r--p 001d0000 fd:00 1180308                    /usr/lib64/libc-2.24.so
    3fffa3870000-3fffa3880000 rw-p 001e0000 fd:00 1180308                    /usr/lib64/libc-2.24.so
    3fffa3890000-3fffa38b0000 r-xp 00000000 00:00 0                          [vdso]
    3fffc6740000-3fffc6770000 rw-p 00000000 00:00 0                          [stack]
    Done

One way to fix this is to move ELF_ET_DYN_BASE from 0x20000000 (512MB) to 0x10000000000 (1TB),
atleast for 64-bit applications. This allows hopefully enough space for most of the
applications without causing them to trample upon the ld.so, leading to a SEGV.

ELF_ET_DYN_BASE is still kept as 0x20000000 (512MB) for 32-bit applications to preserve their
compatibility.

After this change, the layout for the 'large-bss-test-app' changes as shown below:
    # /lib64/ld-2.24.so ./large-bss-test-app
    10000000-10010000 r-xp 00000000 fd:00 2107527                            /root/large-bss-test-app
    10010000-10020000 r--p 00000000 fd:00 2107527                            /root/large-bss-test-app
    10020000-10030000 rw-p 00010000 fd:00 2107527                            /root/large-bss-test-app
    10030000-5b030000 rw-p 00000000 00:00 0
    100283b0000-100283f0000 r-xp 00000000 fd:00 1835645                      /usr/lib64/ld-2.24.so
    100283f0000-10028400000 r--p 00030000 fd:00 1835645                      /usr/lib64/ld-2.24.so
    10028400000-10028410000 rw-p 00040000 fd:00 1835645                      /usr/lib64/ld-2.24.so
    7fff8a470000-7fff8a650000 r-xp 00000000 fd:00 1835652                    /usr/lib64/libc-2.24.so
    7fff8a650000-7fff8a660000 r--p 001d0000 fd:00 1835652                    /usr/lib64/libc-2.24.so
    7fff8a660000-7fff8a670000 rw-p 001e0000 fd:00 1835652                    /usr/lib64/libc-2.24.so
    7fff8a680000-7fff8a6a0000 r-xp 00000000 00:00 0                          [vdso]
    7fffc6d90000-7fffc6dc0000 rw-p 00000000 00:00 0                          [stack]
    Done

Cc: Anton Blanchard <anton@samba.org>
Cc: Daniel Cashman <dcashman@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au> 
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
---
 arch/powerpc/include/asm/elf.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
index 09bde6e..683230c 100644
--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -28,7 +28,9 @@
    the loader.  We need to make sure that it is out of the way of the program
    that it will "exec", and that there is sufficient room for the brk.  */
 
-#define ELF_ET_DYN_BASE	0x20000000
+/* Keep this as 512MB for 32-bit applications and 1TB for 64-bit ones */
+#define ELF_ET_DYN_BASE	(test_thread_flag(TIF_32BIT) ? \
+			 0x20000000 : 0x10000000000)
 
 #define ELF_CORE_EFLAGS (is_elf2_task() ? 2 : 0)
 
-- 
2.7.4
