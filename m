Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAP145pigHJ0CsuvWy=9s1g+Pb2xfLPbqFcYfEP_Dww=6c-G2Yg@mail.gmail.com>
References: <20160128143825.GA17383@www.outflux.net>
	<87io2degsu.fsf@x220.int.ebiederm.org>
	<CAP145pigHJ0CsuvWy=9s1g+Pb2xfLPbqFcYfEP_Dww=6c-G2Yg@mail.gmail.com>
Date: Thu, 28 Jan 2016 12:17:22 -0800
Message-ID: <CAGXu5jJeOnvt3+PguEshdrbyKkXPodBH49RDsAf8rGX5=7C_zA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2] sysctl: allow CLONE_NEWUSER to be disabled
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Andy Lutomirski <luto@kernel.org>, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Richard Weinberger <richard@nod.at>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 28, 2016 at 11:11 AM, Robert =C5=9Awi=C4=99cki <robert@swiecki.=
net> wrote:
> 2016-01-28 18:48 GMT+01:00 Eric W. Biederman <ebiederm@xmission.com>:
>> Kees Cook <keescook@chromium.org> writes:
>>
>>> +     if (sysctl_userns_restrict && !(capable(CAP_SYS_ADMIN) &&
>>> +                                     capable(CAP_SETUID) &&
>>> +                                     capable(CAP_SETGID)))
>>> +             return -EPERM;
>>> +
>>
>> I will also note that the way I have seen containers used this check
>> adds no security and is not mentioned or justified in any way in your
>> patch description.
>>
>> Furthermore this looks like blame shifting.  And quite frankly shifting
>> the responsibility to users if they get hacked is not an acceptable
>> attitude.
>
> I think I might start understanding your point. Which, if I'm not
> mistaken, is that it's not user namespaces which are buggy, but rather
> some pieces of the kernel which would otherwise not be reachable from
> the typical low-priv level of regular users (e.g. bugs in SOCK_RAW
> sockets or iptables or mounts)?
>
> If so, I can agree with such wording, but the proposed sysctl might
> still be needed in such case. I guess those bits of the kernel which
> were not reachable previously from non-priv users historically got
> much less attention in terms of time spent on security reviews and
> security fuzzing. And as much as users of the kernel would like to see
> those pieces of the kernel to be tested to a level that the attack
> surface reachable from unprivileged users level were tested, it will
> not happen tomorrow. And our best option now might be to have some
> switchable setting to disable this attack surface for those users who
> feel they need it. In the meantime, we can concentrate on sec
> reviewing those newly reachable kernel APIs, so some day we could
> remove this sysctl.

Yes, exactly. I want to find a way to offer admins a way to reduce
attack surface. I have no interest in blame; this is a matter of
practicality. It exposes a less well tested set of APIs to
non-privileged users, so let's offer a way to remove that when
desired.

-Kees

--=20
Kees Cook
Chrome OS & Brillo Security
