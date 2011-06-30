Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110630075716.GB3377@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
	<BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com>
	<20110630075716.GB3377@albatros>
Date: Thu, 30 Jun 2011 16:29:41 +0530
Message-ID: <BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com>
From: Balbir Singh <bsingharora@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [Security] [PATCH 2/2] taskstats: restrict access to user
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Shailabh Nagar <nagar@us.ibm.com>, linux-kernel@vger.kernel.org, security@kernel.org, Eric Paris <eparis@redhat.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 30, 2011 at 1:27 PM, Vasiliy Kulikov <segoon@openwall.com> wrot=
e:
> On Wed, Jun 29, 2011 at 13:09 -0700, Linus Torvalds wrote:
>> Ok, having looked at this some more, I'm quite ready to just mark the
>> whole TASKSTATS config option as BROKEN. It does seem to be a horrible
>> security hazard, and very little seems to use it.
>>

I am not sure how you define BROKEN, BROKEN as per security rules?
/proc/$pid/xxx also expose similar information.

>> It also seems to be really fundamentally broken. Afaik, there's no way
>> to filter taskstats not only by security issues (Vasiliy's patch
>> really is very ugly), but it seems to be some global cross-namespace
>> thing too, so it exposes taskstats across pid namespaces afaik.
>
> The problem here is that it keeps a pid in a global list. =A0This list is
> then browsed by all namespaces. =A0Looking into the code, I see 2 real
> problems (didn't check, though):
>
> 1) If there are 2+ pid namespaces, one listener in pid_ns #1 and some
> process dies in pid_ns #2, then the dying task wouldn't find the
> listener via find_task_by_vpid() and would just delete the listener from
> listeners list. =A0Looks like this problem was created by optimization
> patch f9fd8914c1acca0.

I must admit, I did not pay much attention to pid namespace changes as
they were being made to taskstats. I'll look at the code later this
week.

>
> 2) Netlink sockets are per net namespace, but this accounting thing is pe=
r
> pid namespace. =A0So, if the dying task and the listener are in a single
> pid namespace, but in different net namespaces, the message will not be
> sent via genlmsg_unicast(). =A0I suspect it is a problem of all non-net
> netlink sockets.
>

Good catch, under what circumstances would tasks have the same pid
namespace, but different net namespaces?

>
>> It
>> does that even with Vasiliy's patch, afaik, although then I think you
>> need to have collissions in the namespaces if I read the code
>> correctly.
>>
>> I suspect that could be fixed by adding a pid namespace to the
>> 'listener' structure. Also adding a 'cred' pointer (or the actual
>> listener thread pointer) to it would make Vasiliy's patch more
>> palatable, since then you wouldn't need to look up the credentials at
>> send_cpu_listeners() time.
>>

A simple work around could be to disable taskstats under network
namespace or even the current behaviour should just warn the user that
the network namespace of the listener is distinct and disallow the
listener

>> Maybe I have mis-read the code. But it does all make me shudder. There
>> doesn't even seem to be all that many _users_ of the thing, so the
>> problems it has really makes me go "is that code worth it"? We
>> probably should never have merged it in the first place.

iotop(), getdelays (in kernel) with many developers using it and many
more. The interface has been published for a while now

Thanks for the review,
Balbir Singh
