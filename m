Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFx43nZmhRg5Qv5x-4BdgcM-y80ECrgC8mCWc0RqU+_8rQ@mail.gmail.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
	<1331421919-15499-2-git-send-email-tixxdz@opendz.org>
	<20120311172512.GA2729@redhat.com>
	<20120311174953.GB2729@redhat.com>
	<CA+55aFx43nZmhRg5Qv5x-4BdgcM-y80ECrgC8mCWc0RqU+_8rQ@mail.gmail.com>
Date: Sun, 11 Mar 2012 19:37:28 +0100
Message-ID: <CAFLxGvx2zc-qOYCzHEEzU6XY1JHqCqzU2+Kiq=e0YKfqqJWLnQ@mail.gmail.com>
From: richard -rw- weinberger <richard.weinberger@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: self_exec_id/parent_exec_id && CLONE_PARENT
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Djalal Harouni <tixxdz@opendz.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 11, 2012 at 7:02 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Mar 11, 2012 at 10:49 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>
>> I am also asking because the change above looks like the fix to me.
>> The child must not control its ->exit_signal, it is the parent who
>> decides which signal the child should use for notification.
>>
>> And to me, clone(CLONE_PARENT | SIGXXX) looks like a violation of
>> rule above.
>
> SIGXXX is for doing things like AIO with threads, but it would never
> be used together with CLONE_PARENT, that would be odd and wrong.
>
> So I think we could disallow that - or at least try. See if anybody
> notices, and if it breaks anything.
>

UserModeLinux is using CLONE_PARENT | CLONE_FILES | SIGCHLD.
Is this a problem?

-- 
Thanks,
//richard
