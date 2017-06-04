References: <20170603113007.GA1544@grsecurity.net>
 <1496498027.22395.1.camel@gmail.com> <20170603142110.GA7578@grsecurity.net>
 <CA+DvKQ+1BRVgWRcg_anBdf-8cV4=mgu8J9Kf1xVcbZBVePHSsw@mail.gmail.com>
 <20170604124900.GA7153@grsecurity.net>
 <a485c07b-459b-0f6f-4dd9-4ddcf9d21086@marcan.st>
 <20170604144454.GA9802@grsecurity.net>
From: Hector Martin <marcan@marcan.st>
Message-ID: <b6f12acb-8573-c093-7d37-3918bbe2322a@marcan.st>
Date: Mon, 5 Jun 2017 01:59:18 +0900
MIME-Version: 1.0
In-Reply-To: <20170604144454.GA9802@grsecurity.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Brad Spengler <spender@grsecurity.net>
Cc: Daniel Micay <danielmicay@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, pageexec@freemail.hu
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-06-04 23:44, Brad Spengler wrote:
> And your evidence is what exactly? That sounds like a statement of fact rather
> than opinion.  Have you considered that there might be others in whatever
> channels those are that disagree with you and happen to mention to me
> ridiculous things that are said about me in public?

That might well be the case, but honestly, things like [1] suggest
you're taking a particularly keen interest in the issue, regardless of
whether you personally idle in said channels or not. I mean, honestly,
if you're really that busy, why spend the time?

> I also even agree the designated initializers changes aren't copyrightable.

I'm glad we actually agree on this.

> My entire
> point was simply mentioning where those changes come from, which is a moral
> issue in these cases, not a copyright issue -- I'm sorry if you think
> not violating copyright means one doesn't engage in plagiarism; the bar for
> copyright is terribly low.

I wouldn't say the bar for copyright is "low", but indeed, it's fair to
point out where such changes came from (if they indeed came directly
from grsec and weren't just re-done; as mostly mechanical changes, it's
entirely expected that they could be). But this comes back to the issue
of making life easy for people. If you're offering nothing beyond your
legal obligations to the GPLv2, making your changes available only in a
format extremely inconvenient to be merged, and lacking fine-grained
attribution, why should people spend their time to meet more than their
bare minimum legal obligations to you in turn?

Ultimately, be nice to people and they'll have more of an incentive to
be nice to you. And an easier technical time getting the right info too.

> Credit is something people do that respect the
> work that they're copying.  Same as we're not *required* to credit people
> who report bugs to us, but we respect their time and so it's something we've
> always done.  Also since not crediting would give the impression that
> particular issue was found via some internal audit, which would be misleading.

To be fair, I was expecting you to credit me as an "infosec anklebiter"
in your changelog for my bug report, so kudos to you for actually
mentioning me by name in an otherwise passive-aggressive entry ;)

> I don't know, maybe to draw more attention for yourself in a way that 
> doesn't require doing any real work and dig yourself into a deeper hole 
> with more libel that you'll be held accountable for later?

Is this a legal threat?

> When you and comex started making your plugin licensing claims we 
> contacted the FSF ourselves given how damaging such claims are 
> (particularly given that a few of them are now included in Linux).  It 
> has been nearly 4 months now and despite repeated follow-ups, I still 
> haven't received anything back more than an automated reply.  Likewise 
> regarding some supposed claims by RMS which were published last year by 
> internet troll mikeeusa -- I have been trying since June 3rd of last 
> year to get any response from him, but have been unable to.

Well, if you're (potentially) violating someone else's license, it's no
surprise the might want to be cautious about replying outright...

Suffice it to say I've had better luck communicating with the FSF about
licensing issues.

> So when you 
> claim we're violating the GPL by releasing some GCC plugins under GPLv2,
> is that a claim of fact you're making?  Because last I checked, you're
> not a GCC copyright holder, only the FSF is, so you don't even meet the
> minimum threshold of being a person anyone should care about or listen to
> wrt this topic.  I think you'd be wise to stop talking, because we've really
> had enough of it.

Being a GCC copyright holder is only required to take *legal action* for
a licensing violation. It is not a requirement to point out a potential
licensing violation. I may not be a GCC copyright holder, but I am a
(minor) Linux kernel copyright holder, as well as heavily depend on both
pieces of software for my professional work and personal usage, and
therefore I have an interest in ensuring that upstream doesn't wind up
in a legal mess because grsecurity decided to license its plugins for
GPLv3'd GCC as GPLv2 in order to supposedly prevent their usage outside
of the kernel through a hilariously convoluted (and misinformed)
licensing hack involving libgcc usage and its exception clause.

And yes, I maintain that in my opinion this approach violates the GCC
license, and that upstream Linux therefore now contains a GCC license
violation, and that possibly nobody cares *in practice*, but that's
still really sad and should be fixed (and the only ways to fix it are
for you/PaX to relicense the code, or for it to be dropped and rewritten).

> Don't worry about it, there's nothing for a "grateful" user like yourself
> to download anymore.  Boy, if I had more "grateful" users like yourself
> obsessed with harrassing us on Twitter, Reddit, and IRC so that they
> can go around and paint themselves as some kind of victim, I wouldn't
> know what to do with myself.

Victim? Come on Brad, you know full well I'm only trolling you because
you troll everyone else[2]. I really don't mind the attitude; in my
case, I don't think it's hurting anyone but yourself. However, I do know
that your way of handling things has discouraged *other* people less
hardened against this kind of drama from working in infosec and Linux
security in particular, and that hurts the entire community. So, while I
invite you to keep being your usual self towards me, I would appreciate
it if you treated people who *haven't* poked fun at grsecurity on
Twitter nicely. There is no need to make a toxic atmosphere for the
community and for contributors who are just trying to help out.

[1] https://grsecurity.net/~spender/snakes.txt
[2] And I still think it's pretty funny that you could panic grsec with
'script /dev/null </dev/zero' as any user, and that the first bugfix
attempt was not tested and just made it worse.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
