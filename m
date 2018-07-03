Date: Tue, 3 Jul 2018 20:19:31 +0200
From: Hanno =?UTF-8?B?QsO2Y2s=?= <hanno@hboeck.de>
Subject: Patch for SymlinksIfOwnerMatches
Message-ID: <20180703201931.79b546f8@computer.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

There's a nasty problem in many webserver configurations on multiuser
systems, I've blogged about it a while ago [1]. With a symlink it's
often possible to read out configuration files of other users. This was
famously used in the freedom hosting II hack [2].

grsecurity had a workaround for this: By not allowing file operations
to follow symlinks if the owner of the link and the target don't match
it can block this kind of attack.

I saw a need to keep this feature alive in a post-grsecurity world, so
a while ago I extracted it from the grsecurity patch. I've now made
that public:
https://github.com/hannob/symlinkown

I'm not sure about upstreaming, I think it's a worthy feature, but it
might need some work in polishing it. But for now I'll just share it
and I will hopefully be able to keep the patch working for future
kernels.

[1]
https://blog.hboeck.de/archives/873-The-tricky-security-issue-with-FollowSy=
mLinks-and-Apache.html
[2]
https://securityaffairs.co/wordpress/55990/deep-web/freedom-hosting-ii-hack=
.html

--=20
Hanno B=C3=B6ck
https://hboeck.de/

mail/jabber: hanno@hboeck.de
GPG: FE73757FA60E4E21B937579FA5880072BBB51E42
