Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 16:41:06 +0300
From: Hans Liljestrand <ishkamiel@gmail.com>
Message-ID: <20161028134106.5f66wwqxxumkttfs@thigreal>
References: <20161025204303.GA36052@beast>
 <2236FBA76BA1254E88B949DDB74E612B41BF8C0A@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jJ2MmY=qDT420F9_hbKtkdRvXC+Juf0J8WKJmtZN4jC0g@mail.gmail.com>
 <20161027124652.2pys4h7tug5wmqge@thigreal>
 <CAGXu5jLnuny-rEcck5SKnORqFU0=Jqt8Pzomv+KdL7JRrB=S5A@mail.gmail.com>
 <20161028023027.GD19531@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161028023027.GD19531@linaro.org>
Subject: Re: [kernel-hardening] Re: [RFC v2 PATCH 13.1/13] lkdtm: add tests
 for atomic over-/underflow
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 28, 2016 at 11:30:28AM +0900, AKASHI Takahiro wrote:
> On Thu, Oct 27, 2016 at 02:36:25PM -0700, Kees Cook wrote:
> > On Thu, Oct 27, 2016 at 5:46 AM, Hans Liljestrand <ishkamiel@gmail.com> wrote:
> > > On Wed, Oct 26, 2016 at 01:41:34PM -0700, Kees Cook wrote:
> > >> On Wed, Oct 26, 2016 at 12:29 AM, Reshetova, Elena
> > >> <elena.reshetova@intel.com> wrote:
> > >> > Thank you Kees! I applied the commit to our hardened_atomic_on_next branch and it will be included into the next rfc.
> > >>
> > >> Cool, thanks. I assume this should get atomic64_t and local_t tests as well?
> > >>
> > >
> > > Yes, I'm currently compiling a build with atomic64_t and local_t tests added.
> > > With the improved lkdtm macros its much easier to add the extra types, thank
> > > you Kees!
> > 
> > Sure thing! I may have yet-another patch for this, as I didn't like
> > repeating the same things in three files whenever a new test was
> > added. Moar macro magick!
> 
> It would be nice to expose atomic* variables to userspace via debugfs
> so that we can confirm that the values will not be changed if overflowed.
> See the attached patch.

Yes, thanks! This definitely looks useful. I've been testing with a script that
parses the kernel logs, but that obviously doesn't test what the values end up
being. We actually just were troubleshooting an issue where this would have
helped greatly.

We can't unfortunately directly apply your patch since we just switched over to
using Kees' improved more-macros test implementation. We're currently furiously
trying to get a coherent next RFC together, but once I get the time I'll apply
the patch and rework it for the current test implementation.

Thanks,
-hans liljestrand


> 
> We will be able to check the test result:
> 
>  # /bin/echo ATOMIC_ADD_OVERFLOW > /debug/provoke-crash/DIRECT
>  # echo $?
>  # if [ cat /debug/provoke-crash/atomic -eq INT_MAX ]; then
>  # echo PASS ; fi
> 
> Thanks,
> -Takahiro AKASHI
> 
> > 
> > -Kees
> > 
> > -- 
> > Kees Cook
> > Nexus Security
> ===8<===
> From c516b50b4764c5c1ba0dd39e3a5022d026e35514 Mon Sep 17 00:00:00 2001
> From: AKASHI Takahiro <takahiro.akashi@linaro.org>
> Date: Fri, 28 Oct 2016 10:55:50 +0900
> Subject: [PATCH] lkdtm: expose atomic variables via debugfs
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  drivers/misc/lkdtm.h      |  2 ++
>  drivers/misc/lkdtm_bugs.c | 75 +++++++++++++++++++++++++++++++++++++----------
>  drivers/misc/lkdtm_core.c |  3 ++
>  3 files changed, 64 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
> index 0ef66ff..b4dd231 100644
> --- a/drivers/misc/lkdtm.h
> +++ b/drivers/misc/lkdtm.h
> @@ -3,10 +3,12 @@
>  
>  #define pr_fmt(fmt) "lkdtm: " fmt
>  
> +#include <linux/fs.h>
>  #include <linux/kernel.h>
>  
>  /* lkdtm_bugs.c */
>  void __init lkdtm_bugs_init(int *recur_param);
> +void __init lkdtm_bugs_init2(struct dentry *parent);
>  void lkdtm_PANIC(void);
>  void lkdtm_BUG(void);
>  void lkdtm_WARNING(void);
> diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
> index 7b4067b..dd5003f 100644
> --- a/drivers/misc/lkdtm_bugs.c
> +++ b/drivers/misc/lkdtm_bugs.c
> @@ -5,6 +5,8 @@
>   * test source files.
>   */
>  #include "lkdtm.h"
> +#include <linux/debugfs.h>
> +#include <linux/fs.h>
>  #include <linux/sched.h>
>  
>  /*
> @@ -35,6 +37,33 @@ static int recursive_loop(int remaining)
>  		return recursive_loop(remaining - 1);
>  }
>  
> +/* from fs/debugfs/file.c */
> +static int debugfs_atomic_long_t_set(void *data, u64 val)
> +{
> +	atomic_long_set((atomic_long_t *)data, val);
> +	return 0;
> +}
> +
> +static int debugfs_atomic_long_t_get(void *data, u64 *val)
> +{
> +	*val = atomic_long_read((atomic_long_t *)data);
> +	return 0;
> +}
> +
> +DEFINE_DEBUGFS_ATTRIBUTE(fops_atomic_long_t, debugfs_atomic_long_t_get,
> +			debugfs_atomic_long_t_set, "%lld\n");
> +
> +static struct dentry *debugfs_create_atomic_long_t(const char *name,
> +				umode_t mode,
> +				struct dentry *parent, atomic_long_t *value)
> +{
> +	return debugfs_create_file_unsafe(name, mode, parent, value,
> +					&fops_atomic_long_t);
> +}
> +
> +static atomic_t atomic_var = ATOMIC_INIT(0);
> +static atomic_long_t atomic_long_var = ATOMIC_LONG_INIT(0);
> +
>  /* If the depth is negative, use the default, otherwise keep parameter. */
>  void __init lkdtm_bugs_init(int *recur_param)
>  {
> @@ -44,6 +73,20 @@ void __init lkdtm_bugs_init(int *recur_param)
>  		recur_count = *recur_param;
>  }
>  
> +void __init lkdtm_bugs_init2(struct dentry *parent)
> +{
> +	struct dentry *de;
> +
> +	de = debugfs_create_atomic_t("atomic", 0644, parent, &atomic_var);
> +	if (de == NULL)
> +		pr_err("could not create atomic dentry under debugfs\n");
> +
> +	de = debugfs_create_atomic_long_t("atomic-long", 0644, parent,
> +							&atomic_long_var);
> +	if (de == NULL)
> +		pr_err("could not create atomic-long dentry under debugfs\n");
> +}
> +
>  void lkdtm_PANIC(void)
>  {
>  	panic("dumptest");
> @@ -125,53 +168,53 @@ void lkdtm_HUNG_TASK(void)
>  
>  #define ATOMIC_LKDTM_MIN(tag,fun) void lkdtm_ATOMIC_##tag(void)	\
>  {									\
> -	atomic_t atomic = ATOMIC_INIT(INT_MIN);				\
> +	atomic_set(&atomic_var, INT_MIN);				\
>  									\
>  	pr_info("attempting good atomic_" #fun "\n");			\
> -	atomic_inc(&atomic);						\
> -	TEST_FUNC(&atomic);						\
> +	atomic_inc(&atomic_var);					\
> +	TEST_FUNC(&atomic_var);						\
>  									\
>  	pr_info("attempting bad atomic_" #fun "\n");			\
> -	TEST_FUNC(&atomic);						\
> +	TEST_FUNC(&atomic_var);						\
>  }
>  
>  #define ATOMIC_LKDTM_MAX(tag,fun,...)					\
>  void lkdtm_ATOMIC_##tag(void)						\
>  {									\
> -	atomic_t atomic = ATOMIC_INIT(INT_MAX);				\
> +	atomic_set(&atomic_var, INT_MAX);				\
>  									\
>  	pr_info("attempting good atomic_" #fun "\n");			\
> -	atomic_dec(&atomic);						\
> -	TEST_FUNC(&atomic);						\
> +	atomic_dec(&atomic_var);					\
> +	TEST_FUNC(&atomic_var);						\
>  									\
>  	pr_info("attempting bad atomic_" #fun "\n");			\
> -	TEST_FUNC(&atomic);						\
> +	TEST_FUNC(&atomic_var);						\
>  }
>   
>  #define ATOMIC_LKDTM_LONG_MIN(tag,fun,...)				\
>  void lkdtm_ATOMIC_LONG_##tag(void)					\
>  {									\
> -	atomic_long_t atomic  = ATOMIC_LONG_INIT(LONG_MIN);		\
> +	atomic_long_set(&atomic_long_var, LONG_MIN);			\
>  									\
>  	pr_info("attempting good atomic_long_" #fun "\n");		\
> -	atomic_long_inc(&atomic);					\
> -	TEST_FUNC(&atomic);						\
> +	atomic_long_inc(&atomic_long_var);				\
> +	TEST_FUNC(&atomic_long_var);					\
>  									\
>  	pr_info("attempting bad atomic_long_" #fun "\n");		\
> -	TEST_FUNC(&atomic);						\
> +	TEST_FUNC(&atomic_long_var);					\
>  }
>   
>  #define ATOMIC_LKDTM_LONG_MAX(tag,fun,...)				\
>  void lkdtm_ATOMIC_LONG_##tag(void)					\
>  {									\
> -	atomic_long_t atomic = ATOMIC_LONG_INIT(LONG_MAX);		\
> +	atomic_long_set(&atomic_long_var, LONG_MAX);			\
>  									\
>  	pr_info("attempting good atomic_long_" #fun "\n");		\
> -	atomic_long_dec(&atomic);					\
> -	TEST_FUNC(&atomic);						\
> +	atomic_long_dec(&atomic_long_var);				\
> +	TEST_FUNC(&atomic_long_var);					\
>  									\
>  	pr_info("attempting bad atomic_long_" #fun "\n");		\
> -	TEST_FUNC(&atomic);						\
> +	TEST_FUNC(&atomic_long_var);					\
>  }
>   
>  #define TEST_FUNC(x) atomic_dec(x)
> diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
> index 01d8540..6f5f9c2 100644
> --- a/drivers/misc/lkdtm_core.c
> +++ b/drivers/misc/lkdtm_core.c
> @@ -536,6 +536,9 @@ static int __init lkdtm_module_init(void)
>  		pr_info("No crash points registered, enable through debugfs\n");
>  	}
>  
> +	/* misc setup */
> +	lkdtm_bugs_init2(lkdtm_debugfs_root);
> +
>  	return 0;
>  
>  out_err:
> -- 
> 2.10.0
> 
