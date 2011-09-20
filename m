Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
	<BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com>
	<20110630075716.GB3377@albatros>
	<BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com>
	<BANLkTi=DiVRV9dkTtYgq+CY-kxVs5ecoWw@mail.gmail.com>
	<BANLkTimnP8L3kSoafdTtUhr9CXx9-WDVLQ@mail.gmail.com>
	<CA+55aFxXS9z=NwoYug+qGoYufqN-6dCo4fm5ggTsoDonsMi4Dw@mail.gmail.com>
	<20110919173905.GA3804@albatros>
	<CA+55aFzedLJfK2h2hY_a73Tn9F8Qu=LyjPhq2gVi5S=CYsCnDA@mail.gmail.com>
Date: Mon, 19 Sep 2011 20:35:10 -0700
In-Reply-To: <CA+55aFzedLJfK2h2hY_a73Tn9F8Qu=LyjPhq2gVi5S=CYsCnDA@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 19 Sep 2011 10:45:20 -0700")
Message-ID: <m1obyfopht.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [Security] [PATCH 2/2] taskstats: restrict access to user
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Balbir Singh <bsingharora@gmail.com>, Shailabh Nagar <nagar@us.ibm.com>, linux-kernel@vger.kernel.org, security@kernel.org, Eric Paris <eparis@redhat.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Sep 19, 2011 at 10:39 AM, Vasiliy Kulikov <segoon@openwall.com> w=
rote:
>>
>> Shouldn't it simply protect taskstats_user_cmd()? =C2=A0You may still po=
ll
>> the counters with TASKSTATS_CMD_ATTR_PID/TASKSTATS_CMD_ATTR_TGID.
>
> Yeah, I wondered where I'd really want to hook it in, that was the
> other option.
>
> However, one thing that I'm currently independently asking some
> networking people is whether that patch guarantees anything at all: is
> the netlink command even guaranteed to be run in the same context as
> the person sending it?

I don't know where that conversation is happening but since I have been
involved rather heavily in netlink syncrhonously processing messages I
will answer.

> After all, it comes in as a packet of data.  How synchronous is the
> genetlink thing guaranteed to be in the first place?

Yes.  The netlink skb is guaranteed to be processed synchronously
and in the senders process.  So accessing current is guaranteed
to be valid.

I just confirmed my memory by reading the cod in 3.1-rc1

> IOW, are *any* of those "check current capabilities/euid" approaches
> really guaranteed to be valid? Are they valid today, will they
> necessarily be valid in a year?

They are valid until such time as someone as someone rearchitects
netlink message processing.

Several years ago it was decided that processing netlink messages
syncrhonously so we could access current made for much simpler easier to
understand kernel code, and most if not all of the netlink permissions
checks now depend upon the fact that we process netlink messages
synchronously.

Eric
