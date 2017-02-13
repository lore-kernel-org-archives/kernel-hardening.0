From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1487019833.9569.66.camel@tycho.nsa.gov>
	<aa5204ef-8d02-efda-1edb-167cbf8d2e4a@schaufler-ca.com>
	<CAGXu5j+BoPiy_YNgS4MC9vue8UDWZ5bwhpCO=bnvbgucsNGeqQ@mail.gmail.com>
	<201702140705.FIJ18206.FOtJOHFFLMSVQO@I-love.SAKURA.ne.jp>
	<CAGXu5jK-D6VzcxQ+Jxo0=uQnu3rhkO6mqCpozwqxnELjuhn82g@mail.gmail.com>
In-Reply-To: <CAGXu5jK-D6VzcxQ+Jxo0=uQnu3rhkO6mqCpozwqxnELjuhn82g@mail.gmail.com>
Message-Id: <201702140715.GHI51518.MHVOSFJQLOFOtF@I-love.SAKURA.ne.jp>
Date: Tue, 14 Feb 2017 07:15:17 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/4] security: mark nf ops in SELinux and Smack as __ro_after_init
To: keescook@chromium.org
Cc: casey@schaufler-ca.com, sds@tycho.nsa.gov, jmorris@namei.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, paul@paul-moore.com
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook wrote:
> On Mon, Feb 13, 2017 at 2:05 PM, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > Kees Cook wrote:
> >> On Mon, Feb 13, 2017 at 1:32 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> >> > If we changed CONFIG_SECURITY_SELINUX_DISABLE to
> >> > CONFIG_SECURITY_DYNAMIC_MODULES and put the __ro_after_init
> >> > under !CONFIG_SECURITY_DYNAMIC_MODULES we solve both the
> >> > current and potential future issues.
> >>
> >> Something like...
> >>
> >> #ifdef CONFIG_SECURITY_DYNAMIC_LSM
> >> # define lsm_ro_after_init __ro_after_init
> >> # define lsm_const         const
> >> #else
> >> # define lsm_ro_after_init
> >> # define lsm_const
> >> #endif
> >>
> >> ?
> >
> > Fedora/RHEL won't use CONFIG_SECURITY_DYNAMIC_LSM=y whereas
> > LKM based LSMs are targeted for such distributions.
> >
> > I don't worry much about Android, for manufactures who ship their
> > products with TOMOYO enabled can rebuild their kernels. But asking
> > for rebuild of Fedora/RHEL kernels to end users is too painful.
> 
> I thought the argument was that Fedora WOULD ship that way, since it
> needs to have the run-time selinux disabling feature?

True only if Fedora/RHEL doesn't separate kernel packages.
They can build separate kernel packages for with-/etc/selinux/config
environments and without-/etc/selinux/config environments because
modules needed for those environments would differ.
