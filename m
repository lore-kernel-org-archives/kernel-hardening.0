Date: Tue, 14 Feb 2017 09:26:57 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
In-Reply-To: <aa5204ef-8d02-efda-1edb-167cbf8d2e4a@schaufler-ca.com>
Message-ID: <alpine.LRH.2.20.1702140926070.19475@namei.org>
References: <alpine.LRH.2.20.1702131632340.8914@namei.org> <201702132029.HJD35443.HFQFVOJOFLtOMS@I-love.SAKURA.ne.jp> <CAGXu5jJDeFUKeSSxDEf4-HG4zfJFgU3ahs83TQtV1iPTrKY40Q@mail.gmail.com> <1487019833.9569.66.camel@tycho.nsa.gov>
 <aa5204ef-8d02-efda-1edb-167cbf8d2e4a@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/4] security: mark nf ops in
 SELinux and Smack as __ro_after_init
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Paul Moore <paul@paul-moore.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 13 Feb 2017, Casey Schaufler wrote:

> If we changed CONFIG_SECURITY_SELINUX_DISABLE to
> CONFIG_SECURITY_DYNAMIC_MODULES and put the __ro_after_init
> under !CONFIG_SECURITY_DYNAMIC_MODULES we solve both the
> current and potential future issues.

We don't need to solve issues which don't exist and ideally will not 
exist.

-- 
James Morris
<jmorris@namei.org>
