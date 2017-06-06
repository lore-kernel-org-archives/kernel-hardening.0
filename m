From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20170605192216.21596-1-igor.stoppa@huawei.com>
	<20170605192216.21596-5-igor.stoppa@huawei.com>
	<71e91de0-7d91-79f4-67f0-be0afb33583c@schaufler-ca.com>
	<201706060550.HAC69712.OVFOtSFLQJOMFH@I-love.SAKURA.ne.jp>
	<ff5714b2-bbb0-726d-2fe6-13d4f1a30a38@huawei.com>
In-Reply-To: <ff5714b2-bbb0-726d-2fe6-13d4f1a30a38@huawei.com>
Message-Id: <201706061954.GBH56755.QSOOFMFLtJFVOH@I-love.SAKURA.ne.jp>
Date: Tue, 6 Jun 2017 19:54:05 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [PATCH 4/5] Make LSM Writable Hooks a command line option
To: igor.stoppa@huawei.com, casey@schaufler-ca.com, keescook@chromium.org, mhocko@kernel.org, jmorris@namei.org
Cc: paul@paul-moore.com, sds@tycho.nsa.gov, hch@infradead.org, labbott@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Igor Stoppa wrote:
> On 05/06/17 23:50, Tetsuo Handa wrote:
> > Casey Schaufler wrote:
> 
> [...]
> 
> >> I don't care for calling this "security debug". Making
> >> the lists writable after init isn't about development,
> >> it's about (Tetsuo's desire for) dynamic module loading.
> >> I would prefer "dynamic_module_lists" our something else
> >> more descriptive.
> > 
> > Maybe dynamic_lsm ?
> 
> ok, apologies for misunderstanding, I'll fix it.
> 
> I am not sure I understood what exactly the use case is:
> -1) loading off-tree modules

Does off-tree mean out-of-tree? If yes, this case is not correct.

"Loading modules which are not compiled as built-in" is correct.
My use case is to allow users to use LSM modules as loadable kernel
modules which distributors do not compile as built-in.

> -2) loading and unloading modules

Unloading LSM modules is dangerous. Only SELinux allows unloading
at the risk of triggering an oops. If we insert delay while removing
list elements, we can easily observe oops due to free function being
called without corresponding allocation function.

> -3) something else ?

Nothing else, as far as I know.

> 
> I'm asking this because I now wonder if I should provide means for
> protecting the heads later on (which still can make sense for case 1).
> 
> Or if it's expected that things will stay fluid and this dynamic loading
> is matched by unloading, therefore the heads must stay writable (case 2)
> 
> [...]
> 
> >>> +	if (!sec_pool)
> >>> +		goto error_pool;
> >>
> >> Excessive gotoing - return -ENOMEM instead.
> > 
> > But does it make sense to continue?
> > hook_heads == NULL and we will oops as soon as
> > call_void_hook() or call_int_hook() is called for the first time.
> 
> Shouldn't the caller check for result? -ENOMEM gives it a chance to do
> so. I can replace the goto.

security_init() is called from start_kernel() in init/main.c , and
errors are silently ignored. Thus, I don't think returning error to
the caller makes sense.
