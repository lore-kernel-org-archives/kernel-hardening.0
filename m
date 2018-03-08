From: ebiederm@xmission.com (Eric W. Biederman)
References: <20180103072642.161742-1-mahesh@bandewar.net>
	<87po6qzycp.fsf@xmission.com>
	<CAF2d9jhB56O6dGVokRtU46sbvJk4891Oa6A86okWbWptcG=pMg@mail.gmail.com>
	<CAF2d9jjPiXX2Rf5QTvMKPdym5cqZBpTSP1Z21xzyjNcpaD=fGg@mail.gmail.com>
	<20180205144015.GA12118@mail.hallyn.com>
	<CANn89iL3y7aEqgUYP8Qq5NbJiYcPKMFCOWedhgOrO5cgy5c7vA@mail.gmail.com>
	<alpine.LRH.2.21.1803090901100.20664@namei.org>
	<87r2oukwnt.fsf@xmission.com>
	<CAF2d9jjCtRi2Y2is6TaDruCLez9ZzqvEEvVGX2nMgC8S51K-QQ@mail.gmail.com>
Date: Thu, 08 Mar 2018 17:46:36 -0600
In-Reply-To: <CAF2d9jjCtRi2Y2is6TaDruCLez9ZzqvEEvVGX2nMgC8S51K-QQ@mail.gmail.com>
	(Mahesh Bandewar's message of "Thu, 8 Mar 2018 15:22:55 -0800")
Message-ID: <87muzii10j.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCHv4 0/2] capability controlled user-namespaces
To: =?utf-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS1?= =?utf-8?B?4KS+4KSwKQ==?= <maheshb@google.com>
Cc: James Morris <jmorris@namei.org>, Eric Dumazet <edumazet@google.com>, "Serge E. Hallyn" <serge@hallyn.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

"Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=
=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0)" <maheshb@google.com> writes:

> On Thu, Mar 8, 2018 at 2:52 PM, Eric W. Biederman <ebiederm@xmission.com>=
 wrote:
>> James Morris <jmorris@namei.org> writes:
>>
>>> Perhaps try a repost upstream for possible merging to 4.16.
>>
>> I have a real concern that capability controlled user namespaces
>> are only good for CAP_NET_RAW and CAP_NET_ADMIN.  They don't appear
>> general.
>>
> NET_RAW and NET_ADMIN threats are real and demonstrated and hence it's
> easy to show this patch-set to handle them well.
>
>> I think this should be discussed on the linux hardening mailing list.
>> As that is what we are really talking about something to reduce the
>> attack surface of the kernel.  Possibly after it has shipped.
>> In some well defined way.
>>
> This patch-set has been posted to linux-hardening mailing list since
> initial RFC series.

When I looked this thread was not.  Hmm.  It looks like this thread had
become completely private.  Sigh.

>> That feels to me like a project for profiling tools, and some bpf progra=
ms
>> that attach to functions and call permissions.
>>
>> Either that or something like my count of maximum number of namespaces.
>> Which appears to be just as usable as capability controlled user
>> namespaces.
>>
> maximum number of namespaces is similar to the distros adding a sysctl
> to disallow creating user-namespace and does not solve the problem nor
> it's usable if the use case involves creating user-namespaces.

If the namespace you are limiting creating is the network namespace it
has nearly the same efficacy and we already have that knob in the kernel
and we need it for several reasons.

>> I am very sympathetic but this does not appear to be a general solution
>> to a general problem.  The general problem being how to reduce the
>> attack surface of the kernel.
>>
> Now let's say there is vulnerability discovered in CAP_DAC_OVERRIDE,
> why do think this patch-set is not general enough to handle that? The
> point is that at this moment there is no mechanism that allows me to
> create a sandbox in a true sense. This patch-set allows you to do
> that.

I don't think the same amount of code is behind the other capablities
which drastically alters the efficacy of something like this when
considered in such a context.

>> Especially when the end goal is fixing the relevant kernel code and
>> removing the restrictions I don't see why a weird kernel patch with
>> oddball semantics can help.
>>
> I'm not fixated on *this only* solution but don't want a solution that
> restricts creating user-namespaces since my use-cases involve creating
> user-namespaces with "lesser" privileges. The patch-set has been
> posted for more than 6 months and problem is known for some time now
> unfortunately I haven't seen any other solution that does not involve
> blocking user-namespace creation.

I don't recall poposing a solution that limits creating user-namespaces.
Certainly I have proposed other kinds of solutions.

I offered sketches for several other solutions.  Including the one above
about using the tracing/debugging framework to inject additional
permission checks into the code at run-time.

There is a real danger in the direction you are walking.  Having a
mentality that is reactive and adding restrictions after the fact has
the very real danger of breaking applications when those restrictions
are imposed.

The only way I know to avoid breaking things is to have preemptive
sandboxing that tightly limits what applications can do.  Perhaps
something like sandstorm.io.  That preemptive sandbox let's you say.
Wasn't it nice that we don't allow that code path so patching is less of
a priority.

Past that you have to balance between what you might break and what you
are what problems you are going to avoid by disallowing things after the
fact.

I have a little time but I don't think I will have much time for a
general design discussion until after 4.16 is out.

So far to me, capability controlled user namespaces look like a nasty
adhoc feature that one person will use, and not much.  That however will
need to be maintained in perpetuity.  As such I think it is quite
reasonable to drag my feet, and ask is there something better and/or
more general that we can do.

Eric
