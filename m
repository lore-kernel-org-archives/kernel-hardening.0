Date: Tue, 14 Feb 2017 22:07:26 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
In-Reply-To: <201702141937.IAD69742.SVtHOQFLJOFFMO@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.2.20.1702142142480.20182@namei.org>
References: <alpine.LRH.2.20.1702131631490.8914@namei.org> <201702131933.GAF69296.FHQOOJSLOFVtFM@I-love.SAKURA.ne.jp> <CAGXu5jK6Y3i+zoHhF1PyehmxURTVdmEcMPio0HGu=+sTiOz8Mg@mail.gmail.com> <alpine.LRH.2.20.1702140921150.19475@namei.org>
 <201702141937.IAD69742.SVtHOQFLJOFFMO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC PATCH 1/4] security: mark LSM hooks
 as __ro_after_init
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: keescook@chromium.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 14 Feb 2017, Tetsuo Handa wrote:

> > I think it would be a backwards step security-wise to allow dynamically 
> > loadable security modules.  The security risks of security code in the 
> > kernel should be aggressively minimized.
> 
> If you do want secure kernels, build with CONFIG_MODULES=n for individual environment.

The rationale for disallowing dynamically loaded LSMs in this case is so 
that the LSM hooks can be made read-only, to harden the kernel against LSM 
being used as an attack vector.  Overwriting an LSM hook can provide an 
attacker with a security-critical control point at any of hundreds 
locations within the kernel.

It's not about modules, per se.

> 
> Loadable kernel modules used by antivirus software temporarily modify syscall tables
> ( http://stackoverflow.com/questions/13876369/system-call-interception-in-linux-kernel-module-kernel-3-5 )
> in order to register hooks for execve()/open()/close(). It is very frustrating for
> many users if you enforce CONFIG_MODULES=n or forbid post-__init registration of hooks.

We don't cater to out of tree code.

Additionally, I'd also seriously question whether the security benefits of 
kernel AV outweigh its security risks.

> 
> Marking LSM hooks as __ro_after_init might help mitigating modification of
> LSM hooks by innocent errors. A malicious attack can try to modify variables
> that control whether access controls are in enforcing mode or not. You need to
> eliminate such variables if you don't want access controls being disabled by
> malicious attacks. You want to eliminate more things such as security= kernel
> command line option, function pointers like security_hook_list, ability to
> update policy configuration without rebooting.

We are not trying to prevent every possible attack here, just the class of 
attack where someone uses a function pointer overwrite to compromise the 
kernel, via an LSM hook.

We want to reduce the security risk introduced by LSM itself, i.e. 
providing hooks at security-critical locations all over the kernel.

This is an important and useful goal, IMHO.

> 
> Why SELinux is not the only security module? Why Smack, TOMOYO, AppArmor,
> Yama were proposed and became in-tree security modules? Why still other
> modules such as CaitSith, ptags, Timgad are proposed? Answer is very simple.
> In-tree modules (or modules enabled in distributor's kernels) cannot satisfy
> everybody's needs. But asking end users to rebuild their kernels is too painful.

Once again, and this is a very widely accepted and long standing norm, 
the mainline kernel does not cater to out of tree code.

> Disallowing dynamically loadable security modules is as silly idea as
> getting rid of LSM framework ( https://lwn.net/Articles/138042/ 
> http://lkml.kernel.org/r/alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org )
> unless we accept whatever out-of-tree LSM modules and maintain them as in-tree
> modules and enable them in distributor's kernels. But such things won't happen.
> If we legally allow LKM based LSMs, we don't need to make security/ directory
> look like /dev/random .

Dynamically loadable LSMs are legally allowed, we just don't cater to them 
in mainline.

> There will be vulnerabilities like DirtyCOW which might defeat protection for
> LSM. Security of kernel depends on correctness of all kernel code.

As mentioned above, we are trying to harden the LSM framework against 
being an attack vector.  We are not trying to harden it against an already 
compromised kernel.

> Marking LSM hooks as __ro_after_init buys little compared to its sacrifice.

On the contrary, I believe it provides useful hardening and in fact helps 
to mitigate the risk of the LSM API itself.

> We don't need to disallow dynamically loadable security modules.

It's not supported by mainline LSMs, for very good reasons (such as 
needing to start from a known security state during boot), per many 
previous threads on the topic.


- James
-- 
James Morris
<jmorris@namei.org>
