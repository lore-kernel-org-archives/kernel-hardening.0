Date: Tue, 14 Feb 2017 13:46:28 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
In-Reply-To: <a4a8572c-938b-8fa8-82e5-01b4e1e752ce@schaufler-ca.com>
Message-ID: <alpine.LRH.2.20.1702141346220.19475@namei.org>
References: <alpine.LRH.2.20.1702131632340.8914@namei.org> <201702132029.HJD35443.HFQFVOJOFLtOMS@I-love.SAKURA.ne.jp> <CAGXu5jJDeFUKeSSxDEf4-HG4zfJFgU3ahs83TQtV1iPTrKY40Q@mail.gmail.com> <1487019833.9569.66.camel@tycho.nsa.gov> <aa5204ef-8d02-efda-1edb-167cbf8d2e4a@schaufler-ca.com>
 <alpine.LRH.2.20.1702140926070.19475@namei.org> <a4a8572c-938b-8fa8-82e5-01b4e1e752ce@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/4] security: mark nf ops in
 SELinux and Smack as __ro_after_init
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Paul Moore <paul@paul-moore.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 13 Feb 2017, Casey Schaufler wrote:

> On 2/13/2017 2:26 PM, James Morris wrote:
> > On Mon, 13 Feb 2017, Casey Schaufler wrote:
> >
> >> If we changed CONFIG_SECURITY_SELINUX_DISABLE to
> >> CONFIG_SECURITY_DYNAMIC_MODULES and put the __ro_after_init
> >> under !CONFIG_SECURITY_DYNAMIC_MODULES we solve both the
> >> current and potential future issues.
> > We don't need to solve issues which don't exist and ideally will not 
> > exist.
> >
> There is a problem with CONFIG_SECURITY_SELINUX_DISABLE
> and __ro_after_init that does exist. Whether the possible
> future issue should or shouldn't exist has no bearing on
> the existing issue. It's true that we don't need to change
> CONFIG_SECURITY_SELINUX_DISABLE to CONFIG_SECURITY_DYNAMIC_MODULES
> to solve the current problem. I suggest that we leave that
> change to the separate debate on loadable security modules.

Agreed.


-- 
James Morris
<jmorris@namei.org>
