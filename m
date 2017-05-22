MIME-Version: 1.0
In-Reply-To: <20170522120848.GA3003@openwall.com>
References: <1495454226-10027-1-git-send-email-tixxdz@gmail.com> <20170522120848.GA3003@openwall.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Mon, 22 May 2017 15:49:15 +0200
Message-ID: <CAEiveUdqfMk4+vLg6TaEJNSGwoQHxYq0P4aqZoL4i9GgR3Vdtw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v4 next 0/3] modules: automatic module
 loading restrictions
To: Solar Designer <solar@openwall.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Rusty Russell <rusty@rustcorp.com.au>, "Serge E. Hallyn" <serge@hallyn.com>, Jessica Yu <jeyu@redhat.com>, "David S. Miller" <davem@davemloft.net>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Ingo Molnar <mingo@kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, Jonathan Corbet <corbet@lwn.net>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Zendyani <zendyani@gmail.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Ben Hutchings <ben.hutchings@codethink.co.uk>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Alexander,

On Mon, May 22, 2017 at 2:08 PM, Solar Designer <solar@openwall.com> wrote:
> Hi Djalal,
>
> Thank you for your work on this!
>
> On Mon, May 22, 2017 at 01:57:03PM +0200, Djalal Harouni wrote:
>> *) When modules_autoload_mode is set to (2), automatic module loading is
>> disabled for all. Once set, this value can not be changed.
>
> What purpose does this securelevel-like property ("Once set, this value
> can not be changed.") serve here?  I think this mode 2 is needed, but
> without this extra property, which is bypassable by e.g. explicitly
> loaded kernel modules anyway (and that's OK).

My reasoning about "Once set, this value can not be changed" is mainly for:

If you have some systems where modules are not updated for any given
reason, then the only one who will be able to load a module is an
administrator, basically this is a shortcut for:

* Apps/services can run with CAP_NET_ADMIN but they are not allowed to
auto-load 'netdev' modules.

* Explicitly loading modules can be guarded by seccomp filters *per*
app, so even if these apps have
  CAP_SYS_MODULE they won't be able to explicitly load modules, one
has to remount some sysctl /proc/ entries read-only here and remove
CAP_SYS_ADMIN for all apps anyway.

This mainly serves the purpose of these systems that do not receive
updates, if I don't want to expose those kernel interfaces what should
I do ? then if I want to unload old versions and replace them with new
ones what operation should be allowed ? and only real root of the
system can do it. Hence, the "Once set, this value can not be changed"
is more of a shortcut, also the idea was put in my mind based on how
"modules_disabled" is disabled forever, and some other interfaces. I
would say: it is easy to handle a transition from 1) "hey this system
is still up to date, some features should be exposed" to 2) "this
system is not up to date anymore, only root should expose some
features..."

Hmm, I am not sure if this answers your question ? :-)

I definitively don't want to fall into "modules_disabled" trap where
is it too strict! "Once set, this value can not be changed" means for
some users do not set it otherwise the system is unusable...

Maybe an extra "4" mode for that ? better get it right.

Thanks!

-- 
tixxdz
