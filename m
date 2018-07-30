MIME-Version: 1.0
In-Reply-To: <87effy9gfz.fsf@xmission.com>
References: <1531935483-30784-1-git-send-email-s.mesoraca16@gmail.com>
 <CAGXu5jK4q6HLDZ6jokTeDABbzVasY85Jo0HFNKYeaKWZYPjPKg@mail.gmail.com> <87effy9gfz.fsf@xmission.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Mon, 30 Jul 2018 18:19:22 +0200
Message-ID: <CAJHCu1JkX+7bsh2c2GG1LbH4HW_tQ+kJAXzvWY-rVKBtpDL_4g@mail.gmail.com>
Subject: Re: [RFC] kconfig: add hardened defconfig helpers
Content-Type: text/plain; charset="UTF-8"
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-doc@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

2018-07-20 15:37 GMT+02:00 Eric W. Biederman <ebiederm@xmission.com>:
> Kees Cook <keescook@chromium.org> writes:
>
>>> +CONFIG_USER_NS=n
>>> +~~~~~~~~~~~~~~~~
>>> +
>>> +**Negative side effects level:** Medium
>>
>> Unfortunately I think this is High or Extreme. USER_NS gets a lot of use.
>>
>>> +**- Protection type:** Attack surface reduction
>>> +
>>> +This allows containers to use user namespaces to provide different
>>> +user info for different servers.
>>> +User namespaces have been abused in the past for privilege
>>> +escalation.
>
> This is not a particularly good description.

You are right, I've been a bit shallow...
Thank you for pointing it out.
I didn't mean to say that user namespaces are bad for security in general.
I'll make this less ambiguous in the next revision.

> User namespaces do indeed increase the attack surface of programs that
> don't use them.
>
> User namespaces when used to build ``unprivileged containers'' remove or
> at least drastically reduce the need to run as root when setting up
> containers.  Which is attack surface reduction.
>
> User namespaces make available tools that are commonly used to build
> sandboxes.  Chrome for example uses users namespaces if they are
> available as part of setting up it's sandbox.
>
> User namespaces are not limited to containers.
>
> The bugs in the attack surface that user namespaces expose that have
> been used for privilege escalation have to the best of my knowledge
> closed.  So while there is some danger in the increased attack surface
> we are looking at implementation defects rather than design defects.
>
> Eric
