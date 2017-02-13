MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <201702132029.HJD35443.HFQFVOJOFLtOMS@I-love.SAKURA.ne.jp>
References: <alpine.LRH.2.20.1702131632340.8914@namei.org> <201702132029.HJD35443.HFQFVOJOFLtOMS@I-love.SAKURA.ne.jp>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 13 Feb 2017 09:29:08 -0800
Message-ID: <CAGXu5jJDeFUKeSSxDEf4-HG4zfJFgU3ahs83TQtV1iPTrKY40Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/4] security: mark nf ops in
 SELinux and Smack as __ro_after_init
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: James Morris <jmorris@namei.org>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 13, 2017 at 3:29 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> James Morris wrote:
>> Both SELinux and Smack register Netfilter operations during init,
>> which then don't change.  Mark these ops as __ro_after_init.
>>
>> Signed-off-by: James Morris <james.l.morris@oracle.com>
>
> This patch breaks CONFIG_SECURITY_SELINUX_DISABLE=y + SELINUX=disabled in /etc/selinux/config case,
> doesn't it? Although I heard that SELinux is planning to remove CONFIG_SECURITY_SELINUX_DISABLE,
> CONFIG_SECURITY_SELINUX_DISABLE is valid as of current linux-security.git#next .

We could fold that removal into this series?

-Kees

-- 
Kees Cook
Pixel Security
