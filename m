Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110919051239.GY6573@outflux.net>
References: <CAEXv5_itbaNAjUNeDS9uW45YDrbG6zzUAi7Ei-n85ZgSQQLJ6Q@mail.gmail.com>
	<20110919051239.GY6573@outflux.net>
Date: Wed, 21 Sep 2011 01:25:01 -0400
Message-ID: <CAEXv5_g+8KYE_EkXSELERksPq-NOtjTxX65YYV8W4A6jA=Jy1Q@mail.gmail.com>
From: David Windsor <dwindsor@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: Sysctl for set_kernel_text_r[wo]
To: Kees Cook <kees@ubuntu.com>
Cc: ubuntu-hardened@lists.ubuntu.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On Mon, Sep 19, 2011 at 1:12 AM, Kees Cook <kees@ubuntu.com> wrote:
> Hi David,
>
> On Sun, Sep 18, 2011 at 09:42:59PM -0400, David Windsor wrote:
>> I am looking into adding a sysctl that enables toggling of
>> set_kernel_text_rw, set_kernel_text_ro. =A0It appears that the only
>> caller of these methods is ftrace, which can rather easily be disabled
>> when these methods are unavailable.
>
> It would be really nice to be able to wipe these functions out. I really
> dislike that they are available as such perfect ROP targets.
>

I agree.  The only caller of set_kernel_text_r[wo] is ftrace, and only
dynamic ftrace at that.  When CONFIG_DYNAMIC_FTRACE is enabled, ftrace
modifies an in-core table of function pointers to mcount call sites.
AFAICS, when tracing filters are used, ftrace walks this table and
sets mcount call sites in functions not being traced to nops, so as to
minimize execution time penalties for non-traced code paths.
Similarly, in cases where CONFIG_DYNAMIC_FTRACE is set but tracing
isn't currently being performed, performance penalties are mitigated
by making all members of the mcount call site table a nop.

Both of these operations require kernel text to be writable, but since
ftrace is the only user of the set_kernel_text_r[wo] and
set_all_modules_text_r[wo], why don't we at least guard the definition
of these interfaces with #ifdefs for CONFIG_DYNAMIC_FTRACE?  At least
this way, users for whom security is a concern (who also will not be
using ftrace), won't have these interfaces available for ROP attacks.
Currently, calls to these functions are guarded by #ifdefs but their
definition isn't.

I've included a patch that guards the definition of
set_kernel_text_r[wo] and set_all_modules_text_r[wo] with #ifdefs for
CONFIG_DYNAMIC_FTRACE.  I have not tested this patch.

Thanks,
David

 arch/x86/include/asm/cacheflush.h |    2 ++
 arch/x86/mm/init_32.c             |    2 ++
 arch/x86/mm/init_64.c             |    2 ++
 include/linux/module.h            |    2 +-
 kernel/module.c                   |    2 ++
 5 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h
b/arch/x86/include/asm/cacheflush.h
index 4e12668..ff4e7a0 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -146,12 +146,14 @@ void clflush_cache_range(void *addr, unsigned int siz=
e);
 void mark_rodata_ro(void);
 extern const int rodata_test_data;
 extern int kernel_set_to_readonly;
+#ifdef CONFIG_DYNAMIC_FTRACE
 void set_kernel_text_rw(void);
 void set_kernel_text_ro(void);
 #else
 static inline void set_kernel_text_rw(void) { }
 static inline void set_kernel_text_ro(void) { }
 #endif
+#endif

 #ifdef CONFIG_DEBUG_RODATA_TEST
 int rodata_test(void);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 29f7c6d..7e79965 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -888,6 +888,7 @@ EXPORT_SYMBOL_GPL(rodata_test_data);

 int kernel_set_to_readonly __read_mostly;

+#ifdef CONFIG_DYNAMIC_FTRACE
 void set_kernel_text_rw(void)
 {
 	unsigned long start =3D PFN_ALIGN(_text);
@@ -915,6 +916,7 @@ void set_kernel_text_ro(void)

 	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 }
+#endif

 static void mark_nxdata_nx(void)
 {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index bbaaa00..4a446d9 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -733,6 +733,7 @@ EXPORT_SYMBOL_GPL(rodata_test_data);

 int kernel_set_to_readonly;

+#ifdef CONFIG_DYNAMIC_FTRACE
 void set_kernel_text_rw(void)
 {
 	unsigned long start =3D PFN_ALIGN(_text);
@@ -768,6 +769,7 @@ void set_kernel_text_ro(void)
 	 */
 	set_memory_ro(start, (end - start) >> PAGE_SHIFT);
 }
+#endif

 void mark_rodata_ro(void)
 {
diff --git a/include/linux/module.h b/include/linux/module.h
index 1c30087..493d26c 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -721,7 +721,7 @@ extern int module_sysfs_initialized;

 #define __MODULE_STRING(x) __stringify(x)

-#ifdef CONFIG_DEBUG_SET_MODULE_RONX
+#ifdef CONFIG_DEBUG_SET_MODULE_RONX && CONFIG_DYNAMIC_FTRACE
 extern void set_all_modules_text_rw(void);
 extern void set_all_modules_text_ro(void);
 #else
diff --git a/kernel/module.c b/kernel/module.c
index 04379f92..edbedcb 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1667,6 +1667,7 @@ static void unset_module_init_ro_nx(struct module *mo=
d)
 		set_memory_rw);
 }

+#ifdef CONFIG_DYNAMIC_FTRACE
 /* Iterate through all modules and set each module's text as RW */
 void set_all_modules_text_rw(void)
 {
@@ -1708,6 +1709,7 @@ void set_all_modules_text_ro(void)
 	}
 	mutex_unlock(&module_mutex);
 }
+#endif
 #else
 static inline void set_section_ro_nx(void *base, unsigned long
text_size, unsigned long ro_size, unsigned long total_size) { }
 static void unset_module_core_ro_nx(struct module *mod) { }
