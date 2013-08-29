Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
	<871u5gqtw3.fsf@xmission.com>
	<20130826172054.GE27005@ZenIV.linux.org.uk>
	<20130827172406.GA2664@dztty> <20130828201141.GA21455@dztty>
	<CAGXu5jJ2yop1JrJT1nzKWoT_Q83s9fGK_2BuBcCotHCR9YecDQ@mail.gmail.com>
	<20130828211116.GA22184@dztty> <87sixt735b.fsf@xmission.com>
	<CAGXu5jLD+wFpaDW=Zr0gMj-8FqZtD4=UXekrjJS4py_uD7YgUQ@mail.gmail.com>
	<87li3l5mnh.fsf@xmission.com>
	<CAGXu5j+axsd2DPA-QTLSLH32canH4V0FEnW4=wuCqZFa-niKGA@mail.gmail.com>
Date: Thu, 29 Aug 2013 00:42:26 -0700
In-Reply-To: <CAGXu5j+axsd2DPA-QTLSLH32canH4V0FEnW4=wuCqZFa-niKGA@mail.gmail.com>
	(Kees Cook's message of "Wed, 28 Aug 2013 20:33:20 -0700")
Message-ID: <87sixt3pul.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: restore 0400 permissions on /proc/*/{syscall,stack,personality}
To: Kees Cook <keescook@chromium.org>
Cc: Djalal Harouni <tixxdz@opendz.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Solar Designer <solar@openwall.com>, Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> On Wed, Aug 28, 2013 at 6:08 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Kees Cook <keescook@chromium.org> writes:
>>
>>> On Wed, Aug 28, 2013 at 5:26 PM, Eric W. Biederman
>>> <ebiederm@xmission.com> wrote:
>>>> Can someome please state what they are worried about in simple language
>>>> step by step?
>>>> [...]
>>>> The closest I saw in the thread was people were worried about ASLR being
>>>> defeated.  All I see are kernel addresses and we don't have much if any
>>>> runtime or even load time randomization of where code is located in the
>>>> kernel address map on x86_64.  So I don't understand the concern.
>>>
>>> I showed the output of "syscall", since that contains user-space
>>> addresses and shows a leak of ASLR from a privileged process to an
>>> unprivileged process.
>>>
>>> The flaw as I see it is that an unprivileged process opens
>>> /proc/$priv_pid/syscall and passes it to a setuid process which is
>>> able to read it, and provides those contents to the unprivileged
>>> process.
>>>
>>> The unprivileged process should not be able to the open the file in
>>> the first place.
>>
>> I see so the complaint is that we don't give read permission but we do
>> give open permission.    Which is a variant of: the permissions used to
>> open are not the permission used to access the file.
>>
>> This does seem to be a legitimate concern.
>>
>> I think there are several discussions that have been going on lately
>> with respect to this class of problems in proc files.
>>
>> Given the existence of suid exec we can not in general prevent this
>> class of bugs with a check at open time.
>
> I'm not suggesting removing the read check -- that's certainly needed.
>
>> I believe the solution needs to be to enhance the ptrace_may_access
>> checks to verify that both the creds of the current task and the creds
>> of the opening process would have allowed the access.
>
> As in, DAC perms are insufficient?

As in any checks at open time are insufficient.

Roughly what we need is to use the credentials that are present at open
time (file->f_cred) in the ptrace_may_access call instead of or
in addition to current_cred().

Eric
