Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <87zivtj5tv.fsf@x220.int.ebiederm.org>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	<8737tp0zhr.fsf@x220.int.ebiederm.org>
	<CALCETrWYRvqhyCwx5RX6L3TEYCfW0j6ThFUc+ASL7BpxgO5dEQ@mail.gmail.com>
	<CAGXu5j+mx+6BOKb42yfyKnL7VTCUBNC0Nk9aCOd0D5tSD6DbCg@mail.gmail.com>
	<CALCETrXNZhJdjbxYH8x3wr3EyQVJzp2fhNyXwzgmuiKzoKO24A@mail.gmail.com>
	<CAGXu5jJ6fQ5E17jKoC3kFZ0RgbcNLuzW6zdunaXV+jiQPSo+Lg@mail.gmail.com>
	<87bn89sbc2.fsf@x220.int.ebiederm.org>
	<CAGXu5jLwwCw9wZA8QYNVrZ2+kHJn7G3sXQZchvqFMYj3bN=DpQ@mail.gmail.com>
	<87zivtj5tv.fsf@x220.int.ebiederm.org>
Date: Tue, 26 Jan 2016 08:37:28 -0800
Message-ID: <CAGXu5jJzdK1JHkmqsbuaeY9XDJSF97MNTrnGDr66py7+-zixgw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER to be disabled
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 25, 2016 at 8:57 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Kees Cook <keescook@chromium.org> writes:
>
>> On Mon, Jan 25, 2016 at 11:33 AM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Kees Cook <keescook@chromium.org> writes:
>>>>
>>>> Well, I don't know about less weird, but it would leave a unneeded
>>>> hole in the permission checks.
>>>
>>> To be clear the current patch has my:
>>>
>>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>>
>>> The code is buggy, and poorly thought through.  Your lack of interest in
>>> fixing the bugs in your patch is distressing.
>>
>> I'm not sure where you see me having a "lack of interest". The
>> existing cap-checking sysctls have a corner-case bug, which is
>> orthogonal to this change.
>
> That certainly doesn't sound like you have any plans to change anything
> there.

Again, not sure why you think that. My primary role in kernel
development is fixing or helping coordinate fixing of security issues
and features. I already acknowledged the issue (it is a corner case,
and no one seems to debate that). I'm working based on priorities; I
have a long list of things to do. :)

>>> So broken code, not willing to fix.  No. We are not merging this sysctl.
>>
>> I think you're jumping to conclusions. :)
>
> I think I am the maintainer.

Sure, no debate there. In fact, I'm certain you're the maintainer. :)

> What you are proposing is very much something that is only of interst to
> people who are not using user namespaces.  It is fatally flawed as
> a way to avoid new attack surfaces for people who don't care as the
> sysctl leaves user namespaces enabled by default.  It is fatally flawed
> as remediation to recommend to people to change if a new user namespace
> related but is discovered.  Any running process that happens to be
> created while user namespace creation was enabled will continue to
> exist.  Effectively a reboot will be required as part of a mitigation.
> Many sysadmins will get that wrong.

I disagree. The same kinds of issues exist with any of the *_restrict
sysctls: if you turn them on later, things that happened before are
still going to be a problem. You'll have already leaked a kernel base
address, etc. This would be no different.

I'm open to having this sysctl kill all CLONE_NEWUSERed process trees,
if you think that'll be more useful?

> I can't possibly see your sysctl as proposed achieving it's goals.  A
> person has to be entirely too aware of subtlety and nuance to use it
> effectively.

Again, I disagree. There are plenty of people who want to have user ns
disabled. This gives them the knob to do so.

>> This feature is already implemented by two distros, and likely wanted
>> by others. We cannot ignore that. The sysctl default doesn't change
>> the existing behavior, so this doesn't get in your way at all. Can you
>> please respond to my earlier email where I rebutted each of your
>> arguments against it? Just saying "no" and putting words in my mouth
>> isn't very productive.
>
> Calling people who make mistakes insane is not a rebuttal.  In security

I said this:

>> Any admin that decides to just turn off CLONE_NEWUSER in the middle of
>> still using it is insane. I don't think this breeds any false sense of
>> security as most sysctls are set at boot time.

I was arguing that admins that use the sysctl are not going to be the
admins that are using containers already. I didn't mean it as "making
a mistake is insane" but rather "it would appear that a person using
both would be seeking opposing goals".

> usability matters, and your sysctl has low usability.

Unsurprisingly, we disagree here too. This sysctl serves as an attack
surface reduction tool. I never saw it as a way to evict existing
containers.

> Further you seem to have missed something crucial in your understanding.
> As was explained earlier the sysctl was added to ubuntu to allow early
> adopters to experiment not as a long term way of managing user
> namespaces.

It's not about management: the audience of the sysctl is only those
that are not using user namespaces. Providing attack surface reduction
tools to admins is a net win for Linux security as a whole. We both
want the same thing: a safer Linux environment. There's no debate that
having user ns exposes a larger attack surface than not having it.
Being able to disable it for people not interested in using user ns
means a reduction in their attack surface.

> What sounds like a generally useful feature that would cover your use
> case and many others is a per user limit on the number of user
> namespaces users may create.

That sounds fine to me. Are you thinking of a new RLIMIT, or something
else? I don't need a sysctl, I just want a way to effectively disable
user ns.

-Kees


-- 
Kees Cook
Chrome OS & Brillo Security
