Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	<8737tp0zhr.fsf@x220.int.ebiederm.org>
	<CALCETrWYRvqhyCwx5RX6L3TEYCfW0j6ThFUc+ASL7BpxgO5dEQ@mail.gmail.com>
	<CAGXu5j+mx+6BOKb42yfyKnL7VTCUBNC0Nk9aCOd0D5tSD6DbCg@mail.gmail.com>
	<CALCETrXNZhJdjbxYH8x3wr3EyQVJzp2fhNyXwzgmuiKzoKO24A@mail.gmail.com>
	<CAGXu5jJ6fQ5E17jKoC3kFZ0RgbcNLuzW6zdunaXV+jiQPSo+Lg@mail.gmail.com>
	<87bn89sbc2.fsf@x220.int.ebiederm.org>
	<CAGXu5jLwwCw9wZA8QYNVrZ2+kHJn7G3sXQZchvqFMYj3bN=DpQ@mail.gmail.com>
Date: Mon, 25 Jan 2016 22:57:32 -0600
In-Reply-To: <CAGXu5jLwwCw9wZA8QYNVrZ2+kHJn7G3sXQZchvqFMYj3bN=DpQ@mail.gmail.com>
	(Kees Cook's message of "Mon, 25 Jan 2016 14:34:32 -0800")
Message-ID: <87zivtj5tv.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER to be disabled
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> On Mon, Jan 25, 2016 at 11:33 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Kees Cook <keescook@chromium.org> writes:
>>>
>>> Well, I don't know about less weird, but it would leave a unneeded
>>> hole in the permission checks.
>>
>> To be clear the current patch has my:
>>
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>> The code is buggy, and poorly thought through.  Your lack of interest in
>> fixing the bugs in your patch is distressing.
>
> I'm not sure where you see me having a "lack of interest". The
> existing cap-checking sysctls have a corner-case bug, which is
> orthogonal to this change.

That certainly doesn't sound like you have any plans to change anything
there.

>> So broken code, not willing to fix.  No. We are not merging this sysctl.
>
> I think you're jumping to conclusions. :)

I think I am the maintainer.

What you are proposing is very much something that is only of interst to
people who are not using user namespaces.  It is fatally flawed as
a way to avoid new attack surfaces for people who don't care as the
sysctl leaves user namespaces enabled by default.  It is fatally flawed
as remediation to recommend to people to change if a new user namespace
related but is discovered.  Any running process that happens to be
created while user namespace creation was enabled will continue to
exist.  Effectively a reboot will be required as part of a mitigation.
Many sysadmins will get that wrong.

I can't possibly see your sysctl as proposed achieving it's goals.  A
person has to be entirely too aware of subtlety and nuance to use it
effectively.

> This feature is already implemented by two distros, and likely wanted
> by others. We cannot ignore that. The sysctl default doesn't change
> the existing behavior, so this doesn't get in your way at all. Can you
> please respond to my earlier email where I rebutted each of your
> arguments against it? Just saying "no" and putting words in my mouth
> isn't very productive.

Calling people who make mistakes insane is not a rebuttal.  In security
usability matters, and your sysctl has low usability.

Further you seem to have missed something crucial in your understanding.
As was explained earlier the sysctl was added to ubuntu to allow early
adopters to experiment not as a long term way of managing user
namespaces.


What sounds like a generally useful feature that would cover your use
case and many others is a per user limit on the number of user
namespaces users may create.

Eric
