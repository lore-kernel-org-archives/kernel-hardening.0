MIME-Version: 1.0
In-Reply-To: <87r2oukwnt.fsf@xmission.com>
References: <20180103072642.161742-1-mahesh@bandewar.net> <87po6qzycp.fsf@xmission.com>
 <CAF2d9jhB56O6dGVokRtU46sbvJk4891Oa6A86okWbWptcG=pMg@mail.gmail.com>
 <CAF2d9jjPiXX2Rf5QTvMKPdym5cqZBpTSP1Z21xzyjNcpaD=fGg@mail.gmail.com>
 <20180205144015.GA12118@mail.hallyn.com> <CANn89iL3y7aEqgUYP8Qq5NbJiYcPKMFCOWedhgOrO5cgy5c7vA@mail.gmail.com>
 <alpine.LRH.2.21.1803090901100.20664@namei.org> <87r2oukwnt.fsf@xmission.com>
From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= <maheshb@google.com>
Date: Thu, 8 Mar 2018 15:22:55 -0800
Message-ID: <CAF2d9jjCtRi2Y2is6TaDruCLez9ZzqvEEvVGX2nMgC8S51K-QQ@mail.gmail.com>
Subject: Re: [PATCHv4 0/2] capability controlled user-namespaces
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>, Eric Dumazet <edumazet@google.com>, "Serge E. Hallyn" <serge@hallyn.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 8, 2018 at 2:52 PM, Eric W. Biederman <ebiederm@xmission.com> w=
rote:
> James Morris <jmorris@namei.org> writes:
>
>> Perhaps try a repost upstream for possible merging to 4.16.
>
> I have a real concern that capability controlled user namespaces
> are only good for CAP_NET_RAW and CAP_NET_ADMIN.  They don't appear
> general.
>
NET_RAW and NET_ADMIN threats are real and demonstrated and hence it's
easy to show this patch-set to handle them well.

> I think this should be discussed on the linux hardening mailing list.
> As that is what we are really talking about something to reduce the
> attack surface of the kernel.  Possibly after it has shipped.
> In some well defined way.
>
This patch-set has been posted to linux-hardening mailing list since
initial RFC series.

> That feels to me like a project for profiling tools, and some bpf program=
s
> that attach to functions and call permissions.
>
> Either that or something like my count of maximum number of namespaces.
> Which appears to be just as usable as capability controlled user
> namespaces.
>
maximum number of namespaces is similar to the distros adding a sysctl
to disallow creating user-namespace and does not solve the problem nor
it's usable if the use case involves creating user-namespaces.


> I am very sympathetic but this does not appear to be a general solution
> to a general problem.  The general problem being how to reduce the
> attack surface of the kernel.
>
Now let's say there is vulnerability discovered in CAP_DAC_OVERRIDE,
why do think this patch-set is not general enough to handle that? The
point is that at this moment there is no mechanism that allows me to
create a sandbox in a true sense. This patch-set allows you to do
that.

> Especially when the end goal is fixing the relevant kernel code and
> removing the restrictions I don't see why a weird kernel patch with
> oddball semantics can help.
>
I'm not fixated on *this only* solution but don't want a solution that
restricts creating user-namespaces since my use-cases involve creating
user-namespaces with "lesser" privileges. The patch-set has been
posted for more than 6 months and problem is known for some time now
unfortunately I haven't seen any other solution that does not involve
blocking user-namespace creation.


> Eric
>
>
>> On Mon, 26 Feb 2018, Eric Dumazet wrote:
>>
>>> On Mon, Feb 5, 2018 at 6:40 AM, Serge E. Hallyn <serge@hallyn.com> wrot=
e:
>>> > Quoting Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=
=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) (maheshb@google.=
com):
>>> >> -everyone (just keeping the relevant people)
>>> >>
>>> >> Hi James and Eric,
>>> >>
>>> >> I would really like to know how we can proceed with this patch-serie=
s.
>>> >> At this moment it does seem like this is the only solution (unless
>>> >> something is in the kitchen that solves this problem differently tha=
t
>>> >> I'm not aware of) to reduce the surface attack and address 0day
>>> >> vulnerabilities. I have been trying this for last 6+ months now and
>>> >> most of the questions are answered. I really appreciate the feedback=
 /
>>> >> queries / questions received in making this a better solution from
>>> >> Serge.
>>> >>
>>> >> The last status that I know from this and other mail-thread is that
>>> >> James wants to know Eric's take. Eric wanted to see if no_new_privs
>>> >> way solves the problem. To which I have replied.
>>> >>
>>> >> I would really love to see if there is any blockage that I can clear
>>> >> and why this has been held back.
>>> >>
>>> >> So Eric, please respond (publicly or to this thread) to make me
>>> >
>>> > Hey Eric,
>>> >
>>> > ping?
>>> >
>>> > (ack or nack, let's not leave him hanging :)
>>>
>>>
>>> Hmm...
>>>
>>> Eric Biederman , what can we do to unblock this ?
>>>
>>> We can pretend the issue does not exist, until something bad happens.
>>>
>>> Thanks.
>>>
>>>
>>> >> understand why this can/cannot make into linux and make it easier fo=
r
>>> >> James to decide when/how/what to pull as far as this patch-series is
>>> >> concerned.
>>> >>
>>> >> [I don't mean to hurt anyone by being direct so please accept my
>>> >> sincere apologies if that happened.]
>>> >>
>>> >> Thanks,
>>> >> --mahesh..
>>> >>
>>> >> On Wed, Jan 3, 2018 at 9:53 PM, Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=
=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=
=E0=A4=B0)
>>> >> <maheshb@google.com> wrote:
>>> >> > On Wed, Jan 3, 2018 at 8:44 AM, Eric W. Biederman <ebiederm@xmissi=
on.com> wrote:
>>> >> >> Mahesh Bandewar <mahesh@bandewar.net> writes:
>>> >> >>
>>> >> >>> From: Mahesh Bandewar <maheshb@google.com>
>>> >> >>>
>>> >> >>> TL;DR version
>>> >> >>> -------------
>>> >> >>> Creating a sandbox environment with namespaces is challenging
>>> >> >>> considering what these sandboxed processes can engage into. e.g.
>>> >> >>> CVE-2017-6074, CVE-2017-7184, CVE-2017-7308 etc. just to name fe=
w.
>>> >> >>> Current form of user-namespaces, however, if changed a bit can a=
llow
>>> >> >>> us to create a sandbox environment without locking down user-
>>> >> >>> namespaces.
>>> >> >>
>>> >> >> In other conversations it appears it has been pointed out that us=
er
>>> >> >> namespaces are not necessarily safe under no_new_privs.  In theor=
y
>>> >> >> user namespaces should be safe but in practice not so much.
>>> >> >>
>>> >> >> So let me ask.  Would your concerns be addressed if we simply mad=
e
>>> >> >> creation and joining of user namespaces impossible in a no_new_pr=
ivs
>>> >> >> sandbox?
>>> >> >>
>>> >> > Isn't this another form of locking down user-ns similar to setting=
 per
>>> >> > user-ns sysctl max_userns =3D 0?
>>> >> >
>>> >> > Having said that, not allowing processes to create and/or attach
>>> >> > user-namespaces is going to be problematic and possibly a regressi=
on.
>>> >> > This (current) patchset doesn't do that. It allows users to create
>>> >> > user-ns's of any depth and number permitted by per-ns max_userns
>>> >> > sysctl. However one can decide what to take-off and what to leave =
in
>>> >> > terms of capabilities for the sandbox environment.
>>> >> >
>>> >> > --mahesh..
>>> >> >
>>> >> >> Eric
>>> >> >>
>>> >>
>>> >> > [...]
>>>
