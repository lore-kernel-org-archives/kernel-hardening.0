Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+dS3nEc-9HhxBxQO0gWC-bakWxfJHzmfsVb7_AK_8+Jw@mail.gmail.com>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	<1453502345-30416-3-git-send-email-keescook@chromium.org>
	<CAP145piccauJvW6JrVzxm1xM3_5xtMk_Fa+uwFx-84+dKCS0WQ@mail.gmail.com>
	<CAGXu5j+dS3nEc-9HhxBxQO0gWC-bakWxfJHzmfsVb7_AK_8+Jw@mail.gmail.com>
Date: Fri, 22 Jan 2016 23:55:05 +0100
Message-ID: <CAP145pgdjQ4ALiq0wN9s-7PP5pxfMJs5xY7rdCjtYua6guUZqg@mail.gmail.com>
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 2/2] sysctl: allow CLONE_NEWUSER to be disabled
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

2016-01-22 23:50 GMT+01:00 Kees Cook <keescook@chromium.org>:

>> Seems that Debian and some older Ubuntu versions are already using
>>
>> $ sysctl -a | grep usern
>> kernel.unprivileged_userns_clone =3D 0
>>
>> Shall we be consistent wit it?
>
> Oh! I didn't see that on systems I checked. On which version did you find=
 that?

$ uname -a
Linux bc1 4.3.0-0.bpo.1-amd64 #1 SMP Debian 4.3.3-5~bpo8+1
(2016-01-07) x86_64 GNU/Linux
$ cat /etc/debian_version
8.2

IIRC some older kernels delivered with Ubuntu Precise were also using
it (but maybe I'm mistaken)

--=20
Robert =C5=9Awi=C4=99cki
