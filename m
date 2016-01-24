Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+3==XC2jtHt1_N1hMVbRaUE4cVBQ_DWZo+82rQoXcgMA@mail.gmail.com>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
 <1453502345-30416-3-git-send-email-keescook@chromium.org> <CAP145piccauJvW6JrVzxm1xM3_5xtMk_Fa+uwFx-84+dKCS0WQ@mail.gmail.com>
 <CAGXu5j+dS3nEc-9HhxBxQO0gWC-bakWxfJHzmfsVb7_AK_8+Jw@mail.gmail.com>
 <CAP145pgdjQ4ALiq0wN9s-7PP5pxfMJs5xY7rdCjtYua6guUZqg@mail.gmail.com>
 <CAGXu5jKbroEt0nO=yA4V6esKePseO75tcsK=YVy-=1NEuzwxzQ@mail.gmail.com>
 <1453510799.3734.153.camel@decadent.org.uk> <CAGXu5j+3==XC2jtHt1_N1hMVbRaUE4cVBQ_DWZo+82rQoXcgMA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 24 Jan 2016 14:20:42 -0800
Message-ID: <CALCETrWUH0qYTJyiu-FEeV59bTDn4zwyak4ZCrzuv4aLWrr-bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: [PATCH 2/2] sysctl: allow CLONE_NEWUSER to
 be disabled
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 24, 2016 at 12:59 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Jan 22, 2016 at 4:59 PM, Ben Hutchings <ben@decadent.org.uk> wrot=
e:
>> On Fri, 2016-01-22 at 15:00 -0800, Kees Cook wrote:
>>> On Fri, Jan 22, 2016 at 2:55 PM, Robert =C5=9Awi=C4=99cki <robert@swiec=
ki.net> wrote:
>>> > 2016-01-22 23:50 GMT+01:00 Kees Cook <keescook@chromium.org>:
>>> >
>>> > > > Seems that Debian and some older Ubuntu versions are already usin=
g
>>> > > >
>>> > > > $ sysctl -a | grep usern
>>> > > > kernel.unprivileged_userns_clone =3D 0
>>> > > >
>>> > > > Shall we be consistent wit it?
>>> > >
>>> > > Oh! I didn't see that on systems I checked. On which version did yo=
u find that?
>>> >
>>> > $ uname -a
>>> > Linux bc1 4.3.0-0.bpo.1-amd64 #1 SMP Debian 4.3.3-5~bpo8+1
>>> > (2016-01-07) x86_64 GNU/Linux
>>> > $ cat /etc/debian_version
>>> > 8.2
>>>
>>> Ah-ha, Debian only, though it looks like this was just committed to
>>> the Ubuntu kernel tree too:
>>>
>>>
>>> > IIRC some older kernels delivered with Ubuntu Precise were also using
>>> > it (but maybe I'm mistaken)
>>>
>>> I don't see it there.
>>>
>>> I think my patch is more complete, but I'm happy to change the name if
>>> this sysctl has already started to enter the global consciousness. ;)
>>>
>>> Serge, Ben, what do you think?
>>
>> I agree that using the '_restrict' suffix for new restrictions makes
>> sense.  I also don't think that a third possible value for
>> kernel.unprivileged_userns_clone would would be understandable.
>>
>> I would probably make kernel.unprivileged_userns_clone a wrapper for
>> kernel.userns_restrict in Debian, then deprecate and eventually remove
>> it.
>
> Okay, cool. We'll keep my patch as-is then. Thanks!

We still need to deal with the capable check in the write handler though, r=
ight?

But I must be missing something: why is mode 0644 insufficient?

--Andy
