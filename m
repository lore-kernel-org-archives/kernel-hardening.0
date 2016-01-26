Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CALCETrVZCVqWiwJFE47CiuDg1F37qo3V5v8qyrqvRyaHwYPJ3A@mail.gmail.com>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	<8737tp0zhr.fsf@x220.int.ebiederm.org>
	<CALCETrWYRvqhyCwx5RX6L3TEYCfW0j6ThFUc+ASL7BpxgO5dEQ@mail.gmail.com>
	<CAGXu5j+mx+6BOKb42yfyKnL7VTCUBNC0Nk9aCOd0D5tSD6DbCg@mail.gmail.com>
	<CALCETrXNZhJdjbxYH8x3wr3EyQVJzp2fhNyXwzgmuiKzoKO24A@mail.gmail.com>
	<CAGXu5jJ6fQ5E17jKoC3kFZ0RgbcNLuzW6zdunaXV+jiQPSo+Lg@mail.gmail.com>
	<87bn89sbc2.fsf@x220.int.ebiederm.org>
	<CAGXu5jLwwCw9wZA8QYNVrZ2+kHJn7G3sXQZchvqFMYj3bN=DpQ@mail.gmail.com>
	<87zivtj5tv.fsf@x220.int.ebiederm.org>
	<CA+5PVA5Q0_sv5MsETa9u79MLOcYbsf-vdeEe3gdxgJ8f1KAbdQ@mail.gmail.com>
	<20160126171523.GA13715@ubuntumail>
	<56A7B664.6070509@gmail.com>
	<CALCETrVZCVqWiwJFE47CiuDg1F37qo3V5v8qyrqvRyaHwYPJ3A@mail.gmail.com>
Date: Tue, 26 Jan 2016 15:15:57 -0800
Message-ID: <CAGXu5jL-_kmxwRLCd8nP0Zh+6=EHPgMNDjAUFTOLquxGpTcWpA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER to
 be disabled
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 26, 2016 at 10:27 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Jan 26, 2016 at 10:09 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-01-26 12:15, Serge Hallyn wrote:
>>>
>>> Quoting Josh Boyer (jwboyer@fedoraproject.org):
>>>> What you're saying is true for the "oh crap" case of a new userns
>>>> related CVE being found.  However, there is the case where sysadmins
>>>> know for a fact that a set of machines should not allow user
>>>> namespaces to be enabled.  Currently they have 2 choices, 1) use their
>>>
>>>
>>> Hi - can you give a specific example of this?  (Where users really should
>>> not be able to use them - not where they might not need them)  I think
>>> it'll help the discussion tremendously.  Because so far the only good
>>> arguments I've seen have been about actual bugs in the user namespaces,
>>> which would not warrant a designed-in permanent disable switch.  If
>>> there are good use cases where such a disable switch will always be
>>> needed (and compiling out can't satisfy) that'd be helpful.
>>
>> In general, if a particular daemon provides a network service and does not
>> use user namespaces for sand-boxing, it should not be allowed to use user
>> namespaces, because those then become something else to potentially land an
>> exploit through.  ntpd, postfix, and most other regularly used network
>> servers fall into this category.
>
> seccomp handles this issue quite nicely.
>
>>
>> If you're hosting a shared system providing terminal server like usage where
>> the users actually have shell access, then they probably should not be able
>> to use user namespaces on the server.
>>
>
> Au contraire.  If they have user ns access, then can sandbox their own programs.

The open-ended cases of web servers and shell access aren't cleanly
handled by seccomp. And we're talking about protecting them as soon as
this knob exists, not after each program or service grows its own
sandboxing solution.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
