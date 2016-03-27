Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLModth62F8PsFfNVCL=7PrAd+kT_NEsMP5WwOJvLS8EQ@mail.gmail.com>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
	<CAGXu5jLModth62F8PsFfNVCL=7PrAd+kT_NEsMP5WwOJvLS8EQ@mail.gmail.com>
Date: Sun, 27 Mar 2016 05:03:10 +0000
Message-ID: <CAOp4FwTc6C=E2fynp85tVWrZpthMvFpJFmV=HG+czHH_D41OXA@mail.gmail.com>
From: Loganaden Velvindron <loganaden@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Re: [RFC v1 00/17] seccomp-object: From attack
 surface reduction to sandboxing
To: kernel-hardening@lists.openwall.com
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, linux-security-module <linux-security-module@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 24, 2016 at 4:24 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Mar 23, 2016 at 6:46 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.ne=
t> wrote:
>> Hi,
>>
>> This series is a proof of concept (not ready for production) to extend s=
eccomp
>> with the ability to check argument pointers of syscalls as kernel object=
 (e.g.
>> file path). This add a needed feature to create a full sandbox managed b=
y
>> userland like the Seatbelt/XNU Sandbox or the OpenBSD Pledge. It was ini=
tially
>> inspired from a partial seccomp-LSM prototype [1] but has evolved a lot =
since :)
>
> This is interesting! I'd really like to get argument inspection
> working. I'm going to spend some time examining this series more
> closely, but my initial reaction is that I'm suspicious of the ToCToU
> checking -- I'd rather there be no race at all. As for the bug-fixes,
> I'll get those pulled in now. Thanks!
>

Personally, I love the OpenBSD pledge() mechanism. It makes it so easy
to apply attack surface reduction. If seccomp moves closer to pledge,
that would be great.

See here:
https://github.com/dimkr/libwaive
