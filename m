From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20170605192216.21596-1-igor.stoppa@huawei.com>
	<20170605192216.21596-5-igor.stoppa@huawei.com>
	<71e91de0-7d91-79f4-67f0-be0afb33583c@schaufler-ca.com>
In-Reply-To: <71e91de0-7d91-79f4-67f0-be0afb33583c@schaufler-ca.com>
Message-Id: <201706060550.HAC69712.OVFOtSFLQJOMFH@I-love.SAKURA.ne.jp>
Date: Tue, 6 Jun 2017 05:50:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [PATCH 4/5] Make LSM Writable Hooks a command line option
To: casey@schaufler-ca.com, igor.stoppa@huawei.com, keescook@chromium.org, mhocko@kernel.org, jmorris@namei.org
Cc: paul@paul-moore.com, sds@tycho.nsa.gov, hch@infradead.org, labbott@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Casey Schaufler wrote:
> > @@ -33,8 +34,17 @@
> >  /* Maximum number of letters for an LSM name string */
> >  #define SECURITY_NAME_MAX	10
> >  
> > -static struct list_head hook_heads[LSM_MAX_HOOK_INDEX]
> > -	__lsm_ro_after_init;
> > +static int security_debug;
> > +
> > +static __init int set_security_debug(char *str)
> > +{
> > +	get_option(&str, &security_debug);
> > +	return 0;
> > +}
> > +early_param("security_debug", set_security_debug);
> 
> I don't care for calling this "security debug". Making
> the lists writable after init isn't about development,
> it's about (Tetsuo's desire for) dynamic module loading.
> I would prefer "dynamic_module_lists" our something else
> more descriptive.

Maybe dynamic_lsm ?

> 
> > +
> > +static struct list_head *hook_heads;
> > +static struct pmalloc_pool *sec_pool;
> >  char *lsm_names;
> >  /* Boot-time LSM user choice */
> >  static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
> > @@ -59,6 +69,13 @@ int __init security_init(void)
> >  {
> >  	enum security_hook_index i;
> >  
> > +	sec_pool = pmalloc_create_pool("security");
> > +	if (!sec_pool)
> > +		goto error_pool;
> 
> Excessive gotoing - return -ENOMEM instead.

But does it make sense to continue?
hook_heads == NULL and we will oops as soon as
call_void_hook() or call_int_hook() is called for the first time.
