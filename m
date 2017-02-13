References: <alpine.LRH.2.20.1702131632340.8914@namei.org>
 <201702132029.HJD35443.HFQFVOJOFLtOMS@I-love.SAKURA.ne.jp>
 <CAGXu5jJDeFUKeSSxDEf4-HG4zfJFgU3ahs83TQtV1iPTrKY40Q@mail.gmail.com>
 <1487019833.9569.66.camel@tycho.nsa.gov>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <aa5204ef-8d02-efda-1edb-167cbf8d2e4a@schaufler-ca.com>
Date: Mon, 13 Feb 2017 13:32:41 -0800
MIME-Version: 1.0
In-Reply-To: <1487019833.9569.66.camel@tycho.nsa.gov>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/4] security: mark nf ops in
 SELinux and Smack as __ro_after_init
To: Stephen Smalley <sds@tycho.nsa.gov>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: James Morris <jmorris@namei.org>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Paul Moore <paul@paul-moore.com>, Casey Schaufler <casey@schaufler-ca.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 2/13/2017 1:03 PM, Stephen Smalley wrote:
> On Mon, 2017-02-13 at 09:29 -0800, Kees Cook wrote:
>> On Mon, Feb 13, 2017 at 3:29 AM, Tetsuo Handa
>> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>> James Morris wrote:
>>>> Both SELinux and Smack register Netfilter operations during init,
>>>> which then don't change.  Mark these ops as __ro_after_init.
>>>>
>>>> Signed-off-by: James Morris <james.l.morris@oracle.com>
>>> This patch breaks CONFIG_SECURITY_SELINUX_DISABLE=y +
>>> SELINUX=disabled in /etc/selinux/config case,
>>> doesn't it? Although I heard that SELinux is planning to remove
>>> CONFIG_SECURITY_SELINUX_DISABLE,
>>> CONFIG_SECURITY_SELINUX_DISABLE is valid as of current linux-
>>> security.git#next .
>> We could fold that removal into this series?
> I'm personally in favor of removing it, but that support was originally
> requested by the Fedora distro folks on the grounds that it is too
> painful to manage kernel boot parameters on some platforms, and
> therefore they needed an alternative to booting with selinux=0 on the
> kernel command line.  The documented way to disable SELinux on such
> distros is through the use of /etc/selinux/config SELINUX=disabled,
> which relies on this mechanism.  So you'd have to work through removal
> with the distro folks.
>
> Maybe in the interim we could just wrap the ro-after-init markings
> under a conditional dependent on !CONFIG_SECURITY_SELINUX_DISABLE so
> that systems (e.g. Android) that do not rely on this feature could
> benefit.

If we changed CONFIG_SECURITY_SELINUX_DISABLE to
CONFIG_SECURITY_DYNAMIC_MODULES and put the __ro_after_init
under !CONFIG_SECURITY_DYNAMIC_MODULES we solve both the
current and potential future issues.
 

> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
