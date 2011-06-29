Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110628075053.GA4009@albatros>
References: <1308917318-4749-1-git-send-email-segoon@openwall.com>
	<4E07F1C0.2070305@jp.fujitsu.com>
	<20110627070300.GA4463@albatros>
	<4E08324D.9040605@jp.fujitsu.com>
	<20110627085242.GA6635@albatros>
	<BANLkTimFkb1TK_u+Xqp6LnRgzMAv21jFHg@mail.gmail.com>
	<20110628075053.GA4009@albatros>
Date: Wed, 29 Jun 2011 06:46:43 +0530
Message-ID: <BANLkTimBMz8onkYDsz6D_An7q0k0wZVyUw@mail.gmail.com>
From: Balbir Singh <bsingharora@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, security@kernel.org, eparis@redhat.com, kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 28, 2011 at 1:20 PM, Vasiliy Kulikov <segoon@openwall.com> wrot=
e:
> On Tue, Jun 28, 2011 at 06:54 +0530, Balbir Singh wrote:
>> > As to rounding - this is a workaround, not a fix. =A0What if some prog=
ram
>> > reads one byte from tty and then do some io activity exactly of 1kb-1?
>> > Then you just measure kbs and get original tty activity. =A0(just a cr=
azy
>> > example to show that it is not a full solution.)
>> >
>>
>> That would happen with a probability of 1/1024
>
> I'd not claim about probability here, but anyway rounding would be not
> a fix, just a workaround. =A0Also note that the random value is program
> dependent, it is not chosen at the program start time or anything
> similar. =A0IOW, if the program is vulnerable, it is vulnerable with 100%
> probability.
>

I was thinking along ASLR lines, ASLR reduces the probability of
malware finding specific address in code, but does not eliminate it
completely. The other possibility is that we do both ROUND_UP and
ROUND_DOWN as long as we keep the statistics as progressively
increasing. I am trying to find a way to make the statistics available
without compromising the system. In the worst case as you suggest may
be the statistics would be available only to root, but that is the
final drop down scenario.

>
>> >> > Also I'm worried about these statistics after dropping the privileg=
es.
>> >> > After setuid() and similar things not changing pid unprivileged use=
r
>> >> > gets some information about the previous io activity of this task b=
eing
>> >> > privileged. =A0In some situations it doesn't reveal any sensitive
>> >> > information, in some it might. =A0Clearing taskstats on credential
>> >> > changing functions would totally break taskstats' interfaces; and s=
hould
>> >> > be temporary changing fsuid/euid followed by reverting it considere=
d
>> >> > harmfull? =A0I don't know.
>> >>
>> >> Can you please explain more? I'm feeling "reset at credential change"=
 is
>> >> reasonable idea. How broken is there?
>> >
>> > In the code I see taskstats statistics is kept untouched, so it would
>> > break userspace assumptions about the statistics.
>> >
>>
>> Could you please elaborate on this point?
>
> It's better to consider my phrase as a question :) =A0Like this: don't
> userspace programs rely on the fact that all statistic information
> wouldn't be cleared after execve()/set*id()/prctl() ? =A0I'm not familiar
> with taskstats at all, so I don't know whether this assumption makes
> sense to userspace application.

No we don't clear taskstats info on credential changes.

Balbir Singh
