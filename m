Date: Tue, 3 Jul 2018 23:02:33 +0200
From: Hanno =?UTF-8?B?QsO2Y2s=?= <hanno@hboeck.de>
Subject: Re: Patch for SymlinksIfOwnerMatches
Message-ID: <20180703230233.5f383b63@computer.lan>
In-Reply-To: <CAG48ez0efGF2TQ4Di9FnTJq091z7SpWBcB+oj1gG05AKiZ0U2g@mail.gmail.com>
References: <20180703201931.79b546f8@computer.lan>
	<CAG48ez0efGF2TQ4Di9FnTJq091z7SpWBcB+oj1gG05AKiZ0U2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 3 Jul 2018 21:47:34 +0200
Jann Horn <jannh@google.com> wrote:

> Hmm. Actually, I wonder whether the kernel is a good place to handle
> this at all.
>=20
> As you note, Apache already has the option SymLinksIfOwnerMatch, which
> means that it already has to do a component-wise path walk in
> userspace (because AT_BENEATH hasn't landed yet). Here's what "strace"
> reports when Apache with that option is following a symlink:

Maybe for context: I haven't looked into the details of the technical
implementation and I'm not claiming this is a good solution (nor do I
claim to have good knowledge of these things at all). But when I looked
into this a while ago it was the only solution that was available.

Right now the apache option has 2 problems:
* There are many web apps that will enable "FollowSymlinks". If you
  start forbidding that you'll break them. There's currently no way to
  configure apache in a way that both enforces symlink owner match and
  doesn't break half of the PHP ecosystem. It would need an option like
  "treat FollowSymlinks like FollowSymlinksIfOwnerMatch"
* The option has a documented race condition. (Apache has this habit of
  documenting security bugs and thinking this makes them go away...) I
  have heard people saying that this is unfixable in userspace, but
  well, if you say it's possible I'm not going to argue with it.

Point is: I merely wanted to keep the grsecurity option working, so I
ripped it out of grsec into a separate patch. If there's a better way
I'm all for it.

--=20
Hanno B=C3=B6ck
https://hboeck.de/

mail/jabber: hanno@hboeck.de
GPG: FE73757FA60E4E21B937579FA5880072BBB51E42
