From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LRH.2.20.1702131631490.8914@namei.org>
	<201702131933.GAF69296.FHQOOJSLOFVtFM@I-love.SAKURA.ne.jp>
	<CAGXu5jK6Y3i+zoHhF1PyehmxURTVdmEcMPio0HGu=+sTiOz8Mg@mail.gmail.com>
	<alpine.LRH.2.20.1702140921150.19475@namei.org>
In-Reply-To: <alpine.LRH.2.20.1702140921150.19475@namei.org>
Message-Id: <201702141937.IAD69742.SVtHOQFLJOFFMO@I-love.SAKURA.ne.jp>
Date: Tue, 14 Feb 2017 19:37:54 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Re: [kernel-hardening] Re: [RFC PATCH 1/4] security: mark LSM hooks as __ro_after_init
To: jmorris@namei.org, keescook@chromium.org
Cc: linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

James Morris wrote:
> On Mon, 13 Feb 2017, Kees Cook wrote:
> > On Mon, Feb 13, 2017 at 2:33 AM, Tetsuo Handa
> > <penguin-kernel@...ove.sakura.ne.jp> wrote:
> > > James Morris wrote:
> > >> As the regsitration of LSMs is performed during init and then does
> > >> not change, we can mark all of the regsitration hooks as __ro_after_init.
> > >>
> > >> Signed-off-by: James Morris <james.l.morris@...cle.com>
> > >
> > > This patch makes LKM based LSMs (e.g. AKARI) impossible.
> > > I'm not happy with this patch.
> > 
> > LKM based LSMs don't exist yet, and when they do, we may also have the
> > "write rarely" infrastructure done, which LKM based LSMs can use to
> > update the structures.
> 
> I think it would be a backwards step security-wise to allow dynamically 
> loadable security modules.  The security risks of security code in the 
> kernel should be aggressively minimized.

If you do want secure kernels, build with CONFIG_MODULES=n for individual environment.

Loadable kernel modules used by antivirus software temporarily modify syscall tables
( http://stackoverflow.com/questions/13876369/system-call-interception-in-linux-kernel-module-kernel-3-5 )
in order to register hooks for execve()/open()/close(). It is very frustrating for
many users if you enforce CONFIG_MODULES=n or forbid post-__init registration of hooks.

Marking LSM hooks as __ro_after_init might help mitigating modification of
LSM hooks by innocent errors. A malicious attack can try to modify variables
that control whether access controls are in enforcing mode or not. You need to
eliminate such variables if you don't want access controls being disabled by
malicious attacks. You want to eliminate more things such as security= kernel
command line option, function pointers like security_hook_list, ability to
update policy configuration without rebooting.

Why SELinux is not the only security module? Why Smack, TOMOYO, AppArmor,
Yama were proposed and became in-tree security modules? Why still other
modules such as CaitSith, ptags, Timgad are proposed? Answer is very simple.
In-tree modules (or modules enabled in distributor's kernels) cannot satisfy
everybody's needs. But asking end users to rebuild their kernels is too painful.

Disallowing dynamically loadable security modules is as silly idea as
getting rid of LSM framework ( https://lwn.net/Articles/138042/ 
http://lkml.kernel.org/r/alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org )
unless we accept whatever out-of-tree LSM modules and maintain them as in-tree
modules and enable them in distributor's kernels. But such things won't happen.
If we legally allow LKM based LSMs, we don't need to make security/ directory
look like /dev/random .

There will be vulnerabilities like DirtyCOW which might defeat protection for
LSM. Security of kernel depends on correctness of all kernel code.
Marking LSM hooks as __ro_after_init buys little compared to its sacrifice.
We don't need to disallow dynamically loadable security modules.
