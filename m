MIME-Version: 1.0
In-Reply-To: <1ffd8f10f10fc8c328dcc3ee358df18279233211.camel@debian.org>
References: <20180831174406.GA1702@chatter> <1ffd8f10f10fc8c328dcc3ee358df18279233211.camel@debian.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 10 Sep 2018 09:03:48 -0700
Message-ID: <CAGXu5jLtUK7QnZVE_0c+AM2zaN_0uuU3LBxfzfWh=HavHisDFA@mail.gmail.com>
Subject: Re: "Hardened" tree on kernel.org?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Yves-Alexis Perez <corsac@debian.org>
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 10, 2018 at 5:24 AM, Yves-Alexis Perez <corsac@debian.org> wrot=
e:
> On Fri, 2018-08-31 at 13:44 -0400, Konstantin Ryabitsev wrote:
>> Do you think this would be a worthwhile thing, or would that distract
>> from overall mainlining goals?
>
> I think it would be a nice addition. There are already bits here and ther=
e,
> the most prominent one being https://github.com/thestinger/linux-hardened=
 /
> https://github.com/AndroidHardeningArchive/linux-hardened from Daniel Mic=
ay
> (added to CC although I guess he's subscribed)
>
> Maybe Kees maintains KSSP-related stuff somewhere.
>
> I think having a central repository of =E2=80=9Cvouched=E2=80=9D stuff wo=
uld be nice, even it
> includes things not ready for mainline.

KSPP is just a "focus group" of the upstream kernel, not a separate
project, so we're part of the regular development cycle and practices.
Therefore linux-next is where things live before getting merged. For
work that has an obvious upstream maintainer (e.g. arch-specific
hardening) live in their respective trees (e.g. refcount_t went in via
tip/atomic). For less-obvious stuff, or for when I'm the maintainer it
goes via my for-next/kspp tree. An example would be that the stackleak
gcc plugin has been kept up to date there (by Alexander) for several
upstream releases while it continues to get buffeted by review.

Some things aren't ready for merging (e.g. XPFO, SARA, Landlock) due
to needed dependencies or improvements. While each of these have
versions of their patches that work against specific kernel versions,
keeping them forward-ported is a non-trivial bit of work. The
individual authors have been doing that work when they have time and
are doing their next revision, for example. But as such, there isn't
really a "single repository" of hardening work. The effort to
stabilize patches has been focused on getting them into upstream.

So, yes, tl;dr would be: there isn't a separate collection because
I've been trying to get people to focus on upstreaming. Having another
fork doesn't really help the general public. (That said, there _are_
people with distro-like forks of the kernel that HAVE been collecting
things, but I haven't been tracking them: please speak up if you want
to let people know about the work!)

-Kees

--=20
Kees Cook
Pixel Security
