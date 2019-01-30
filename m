MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Wed, 30 Jan 2019 17:32:00 +0100
Message-ID: <CAG48ez0QRmU9fGV3x7nceGqBGADNTb66MnG4PW_xu+xnGUqg=g@mail.gmail.com>
Subject: ARM64 suggestion: reduce the compat address limit (currently 0x100000000)?
Content-Type: text/plain; charset="UTF-8"
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi!

At the moment, compat tasks running on ARM64 can allocate memory up to
0x100000000 (TASK_SIZE_32). Testing on an Android device (with an
admittedly somewhat old kernel):

===========
$ cat mmap_filler.c
#include <sys/mman.h>
#include <unistd.h>
#include <err.h>
#include <stdlib.h>
#include <fcntl.h>
int main(void) {
  unsigned long size = 1UL<<31;
  while (size >= 0x1000UL) {
    void *res = mmap(NULL, size, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS|MAP_NORESERVE, -1, 0);
    if (res == MAP_FAILED) size >>= 1;
  }
  int fd = open("/proc/self/maps", O_RDONLY);
  if (fd == -1) err(1, "open");
  while (1) {
    char buf[0x1000];
    ssize_t res = read(fd, buf, sizeof(buf));
    if (res == -1) err(1, "read");
    if (res == 0) _exit(0);
    ssize_t wres = write(1, buf, res);
    if (wres != res) errx(1, "write failed");
  }
}
$ arm-linux-gnueabi-gcc -static -o mmap_filler mmap_filler.c && adb
push mmap_filler /data/local/tmp/ && adb shell
/data/local/tmp/mmap_filler
mmap_filler: 1 file pushed. 16.3 MB/s (587008 bytes in 0.034s)
00008000-00010000 rw-p 00000000 00:00 0
00010000-00089000 r-xp 00000000 103:1d 2080772
  /data/local/tmp/mmap_filler
00089000-00098000 rw-p 00000000 00:00 0
00098000-0009a000 rw-p 00078000 103:1d 2080772
  /data/local/tmp/mmap_filler
0009a000-0009b000 rw-p 00000000 00:00 0
0009b000-00752000 rw-p 00000000 00:00 0                                  [heap]
00752000-00774000 rw-p 00000000 00:00 0                                  [heap]
00774000-f081b000 rw-p 00000000 00:00 0                                  [heap]
f081b000-f081c000 r--p 00000000 00:00 0                                  [vvar]
f081c000-f081e000 r-xp 00000000 00:00 0                                  [vdso]
f081e000-ff710000 rw-p 00000000 00:00 0
ff810000-ff831000 rw-p 00000000 00:00 0                                  [stack]
ff831000-ffff0000 rw-p 00000000 00:00 0
ffff0000-ffff1000 r-xp 00000000 00:00 0
  [kuserhelpers]
ffff1000-100000000 rw-p 00000000 00:00 0
===========

This means that mmap() allocations do not adhere to section 6.5.8 of
C99 ("If the
expression P points to an element of an array object and the
expression Q points to the
last element of the same array object, the pointer expression Q+1
compares greater than
P.") if you treat mmap() allocations as returning an array.

In practice, I've also seen code that does things like computing a
pointer that is out of bounds by a few bytes and then comparing it
against the end of the array; while this is UB according to C99, it
probably makes sense to try to avoid breaking such code.

X86-64's compat code uses the limit 0xFFFFe000 (IA32_PAGE_OFFSET),
which I think makes more sense. Would it make sense to do something
like the following (untested)?

==============
diff --git a/arch/arm64/include/asm/processor.h
b/arch/arm64/include/asm/processor.h
index f1a7ab18faf3..a0c7eb1358dd 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -57,7 +57,7 @@
 #define TASK_SIZE_64           (UL(1) << vabits_user)

 #ifdef CONFIG_COMPAT
-#define TASK_SIZE_32           UL(0x100000000)
+#define TASK_SIZE_32           UL(0xFFFFe000)
 #define TASK_SIZE              (test_thread_flag(TIF_32BIT) ? \
                                TASK_SIZE_32 : TASK_SIZE_64)
 #define TASK_SIZE_OF(tsk)      (test_tsk_thread_flag(tsk, TIF_32BIT) ? \
==============
