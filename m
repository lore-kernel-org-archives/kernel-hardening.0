Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFxXS9z=NwoYug+qGoYufqN-6dCo4fm5ggTsoDonsMi4Dw@mail.gmail.com>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
	<BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com>
	<20110630075716.GB3377@albatros>
	<BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com>
	<BANLkTi=DiVRV9dkTtYgq+CY-kxVs5ecoWw@mail.gmail.com>
	<BANLkTimnP8L3kSoafdTtUhr9CXx9-WDVLQ@mail.gmail.com>
	<CA+55aFxXS9z=NwoYug+qGoYufqN-6dCo4fm5ggTsoDonsMi4Dw@mail.gmail.com>
Date: Mon, 19 Sep 2011 22:50:02 +0530
Message-ID: <CAKTCnzkfNjDJpOwMnhzH0OVZOJWRWgOSyP-n=KyXXZM_M1uq4Q@mail.gmail.com>
From: Balbir Singh <bsingharora@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [Security] [PATCH 2/2] taskstats: restrict access to user
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Shailabh Nagar <nagar@us.ibm.com>, linux-kernel@vger.kernel.org, security@kernel.org, Eric Paris <eparis@redhat.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 19, 2011 at 10:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Jun 30, 2011 at 8:02 PM, Balbir Singh <bsingharora@gmail.com> wro=
te:
> >>
> >> So that's why I think it should be marked BROKEN. What applications
> >> actually depend on this? iotop and what else? Because if it's just
> >> iotop, I do suspect we might be better off telling people "ok,
> >> disabling this will break iotop, but quite frankly, you're better off
> >> without it".
> >
> > I beg to differ, due to the reasons above. I'd rather find time and
> > fix the pending issues (network namespace), you've fixed the pid
> > namespace issue. I'd also look for exiting listeners
>
> So nothing ever happened on this thread, afaik.
>
> You can still read sensitive information at a byte granularity with tasks=
tats.
>
> Balbir never sent any of the fixes he was supposed to, and none of the
> namespace issues have gotten fixed.
>
> It's now almost three months later, and things are still equally broken.
>
> I think we need to just disable TASKSTAT's. Nobody maintains it, it's
> been a known issue for months, people pointed out problems and even
> sent patches, and nothing happened.
>
> Maybe we can minimize it with the appended patch, but dammit, we need
> to do *something*. If I don't get any reasonable replies, I'm really
> going to have to mark this as known-BROKEN, since nothing ever
> happens, and the "maintainer" clearly doesn't care about security
> issues.
>

Sorry, I've been bogged down with work issues and have not had time to
look at it.=A0If someone else wants to take a look while I am busy, I'd
be happy. The patch you've sent seems reasonable, but I'd suggest a
changelog

"Change taskstats user interface, henceforth we need (for security
purposes) CAP_SYS_ADMIN to receive taskstats
data on a particular CPU, a subset or all CPUs on the system. The
patch also rounds the data returned to the KiloByte
boundary for IO parameters, read_bytes, write_bytes and cancelled_write_byt=
es"

Thanks for looking into this.
Balbir
