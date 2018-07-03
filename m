MIME-Version: 1.0
References: <20180703201931.79b546f8@computer.lan>
In-Reply-To: <20180703201931.79b546f8@computer.lan>
From: Jann Horn <jannh@google.com>
Date: Tue, 3 Jul 2018 20:48:54 +0200
Message-ID: <CAG48ez1JMdtoRmfR8haeYMmsXXwR4G2nJS_GSXu-c40SX8k1bQ@mail.gmail.com>
Subject: Re: Patch for SymlinksIfOwnerMatches
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: hanno@hboeck.de
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 3, 2018 at 8:29 PM Hanno B=C3=B6ck <hanno@hboeck.de> wrote:
> There's a nasty problem in many webserver configurations on multiuser
> systems, I've blogged about it a while ago [1]. With a symlink it's
> often possible to read out configuration files of other users. This was
> famously used in the freedom hosting II hack [2].
>
> grsecurity had a workaround for this: By not allowing file operations
> to follow symlinks if the owner of the link and the target don't match
> it can block this kind of attack.
>
> I saw a need to keep this feature alive in a post-grsecurity world, so
> a while ago I extracted it from the grsecurity patch. I've now made
> that public:
> https://github.com/hannob/symlinkown
>
> I'm not sure about upstreaming, I think it's a worthy feature, but it
> might need some work in polishing it. But for now I'll just share it
> and I will hopefully be able to keep the patch working for future
> kernels.
>
> [1]
> https://blog.hboeck.de/archives/873-The-tricky-security-issue-with-Follow=
SymLinks-and-Apache.html
> [2]
> https://securityaffairs.co/wordpress/55990/deep-web/freedom-hosting-ii-ha=
ck.html

Does upstream's /proc/sys/fs/protected_symlinks not work for that?
