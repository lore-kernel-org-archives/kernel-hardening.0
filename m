MIME-Version: 1.0
In-Reply-To: <CAEiveUcx8fwQgXdLPeMNsTjX2KPhQKH__a-XzcHko_1aCmh4sg@mail.gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
 <1492640420-27345-3-git-send-email-tixxdz@gmail.com> <CALCETrXFp-apnfRPg9qx6E7g3KDU8DanBW1pMUnA1zShrB5xKg@mail.gmail.com>
 <CAGXu5jJ5dm8yJJ34tEyOP78OxUr2awXmNhm6RaVP8jE4q+L5Ng@mail.gmail.com>
 <CALCETrUueOx1tqj+Ru93KGpy2HHR-A_GQ6DrAppiomkPTtX7Lw@mail.gmail.com>
 <CAGXu5jJBp6VHvDP9182hJgvzS2sBUbUFpmZZ+196K2FcEHUxzw@mail.gmail.com>
 <CALCETrVZ2KH4s2uGW2J3zUQ8RNsrq=N7pJP=YDqd=+cp6fJW=g@mail.gmail.com>
 <CAGXu5jJTdL7To2JsQUXyg6B7Xbb0kow6sXH-L+teVi88=gm7MQ@mail.gmail.com>
 <CALCETrXzZwz4a9uhQfdHb4L2afApTvVLPwVx640vvV-fzbCR0w@mail.gmail.com> <CAEiveUcx8fwQgXdLPeMNsTjX2KPhQKH__a-XzcHko_1aCmh4sg@mail.gmail.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Sat, 22 Apr 2017 03:19:55 +0200
Message-ID: <CAEiveUeHk4TkfGbLzomDUB3WB7eV=ts_64BL3SDVvrCKkrPW=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules
 autoload restriction
To: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Ingo Molnar <mingo@kernel.org>, belakhdar abdeldjalil <zendyani@gmail.com>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Apr 22, 2017 at 2:12 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
> On Sat, Apr 22, 2017 at 1:51 AM, Andy Lutomirski <luto@kernel.org> wrote:
> [...]
>>>> I personally like my implicit_rights idea, and it might be interesting
>>>> to prototype it.
>>>
>>> I don't like blocking a needed feature behind a large super-feature
>>> that doesn't exist yet. We'd be able to refactor this code into using
>>> such a thing in the future, so I'd prefer to move ahead with this
>>> since it would stop actual exploits.
>>
>> I don't think the super-feature is so hard, and I think we should not
>> add the per-task thing the way it's done in this patch.  Let's not add
>> per-task things where the best argument for their security is "not
>> sure how it would be exploited".
>
> Actually the XFRM framework CVE-2017-7184 [1] is one real example, of
> course there are others. The exploit was used on a generic distro
> during a security contest that distro is Ubuntu. That distro will
> never provide a module autoloading restriction by default to not harm
> it's users. Consumers or containers/sandboxes then can run their
> confined apps using such facilities.
>
> These bugs will stay in embedded devices that use these generic
> distros for ever.

The DCCP CVE-2017-6074 exploit:
http://seclists.org/oss-sec/2017/q1/503

Well, pretty sure there is more... the bugs are real, as their
exploits. Anyway I think these features can coexist as they are
optional, and most process trees protections can get along by design.


-- 
tixxdz
