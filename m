Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 27 Oct 2016 15:54:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20161027145450.GB3762@e104818-lin.cambridge.arm.com>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
 <20160915162044.GB19214@leverpostej>
 <20160929224452.GA71670@samitolvanen.mtv.corp.google.com>
 <CAGXu5jKEpZgc9zqmX=QKs_NH70fX_4CRNEtFKXEETK6UwykNMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKEpZgc9zqmX=QKs_NH70fX_4CRNEtFKXEETK6UwykNMw@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v3 0/7] arm64: Privileged Access
 Never using TTBR0_EL1 switching
To: Kees Cook <keescook@chromium.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, James Morse <james.morse@arm.com>, andre.przywara@arm.com, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 30, 2016 at 11:42:02AM -0700, Kees Cook wrote:
> On Thu, Sep 29, 2016 at 3:44 PM, Sami Tolvanen <samitolvanen@google.com> wrote:
> > On Thu, Sep 15, 2016 at 05:20:45PM +0100, Mark Rutland wrote:
> >> Likewise, how do we handle __flush_cache_user_range and
> >> flush_icache_range? Some callers (e.g. __do_compat_cache_op) pass in
> >> __user addresses.
> >
> > Also EXEC_USERSPACE in lkdtm passes a user space address to flush_icache_range
> > and causes the process to hang when I tested these patches on HiKey.
> >
> > Adding uaccess_{enable,disable}_not_uao to __flush_cache_user_range appears to
> > fix the problem.
> 
> I had a thought just now on this: is lkdtm maybe doing the wrong thing
> here? i.e. should lkdtm be the one do to the uaccess_en/disable
> instead of flush_icache_range() itself, since it's the one abusing the
> API?

(preparing the v4 series)

I think lkdtm is using the API incorrectly here. The documentation for
flush_icache_range() (Documentation/cachetlb.txt) states that it is to
be used on kernel addresses. Even with uaccess_enable/disable in lkdtm,
faults on user space can still happen and the flush_icache_range()
function must be able to handle them. It happens to work on arm64
because of the fall through __flush_cache_user_range() but that's not
guaranteed on other architectures.

A potential solution is to use access_process_vm() and let the arch code
handle the cache maintenance automatically:

---------------------8<--------------------------------
>From fcbb7c9c30daf9bfc2a215ec10dba79c109ab835 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 27 Oct 2016 15:47:20 +0100
Subject: [PATCH] lkdtm: Do not use flush_icache_range() on user addresses

The flush_icache_range() API is meant to be used on kernel addresses
only as it may not have the infrastructure (exception entries) to handle
user memory faults.

The lkdtm execute_user_location() function tests the kernel execution of
user space addresses by mmap'ing an anonymous page, copying some code
together with cache maintenance and attempting to run it. However, the
cache maintenance step may fail because of the incorrect API usage
described above. The patch changes lkdtm to use access_process_vm() for
copying the code into user space which would take care of the necessary
cache maintenance.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/misc/lkdtm_perms.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/lkdtm_perms.c b/drivers/misc/lkdtm_perms.c
index 45f1c0f96612..c7635a79341f 100644
--- a/drivers/misc/lkdtm_perms.c
+++ b/drivers/misc/lkdtm_perms.c
@@ -60,15 +60,18 @@ static noinline void execute_location(void *dst, bool write)
 
 static void execute_user_location(void *dst)
 {
+	int copied;
+
 	/* Intentionally crossing kernel/user memory boundary. */
 	void (*func)(void) = dst;
 
 	pr_info("attempting ok execution at %p\n", do_nothing);
 	do_nothing();
 
-	if (copy_to_user((void __user *)dst, do_nothing, EXEC_SIZE))
+	copied = access_process_vm(current, (unsigned long)dst, do_nothing,
+				   EXEC_SIZE, FOLL_WRITE);
+	if (copied < EXEC_SIZE)
 		return;
-	flush_icache_range((unsigned long)dst, (unsigned long)dst + EXEC_SIZE);
 	pr_info("attempting bad execution at %p\n", func);
 	func();
 }
