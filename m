MIME-Version: 1.0
In-Reply-To: <3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com>
References: <20170529213800.29438-1-matt@nmatt.com> <20170529213800.29438-3-matt@nmatt.com>
 <20170529232640.16211960@alans-desktop> <CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
 <3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Sun, 4 Jun 2017 02:29:03 -0400
Message-ID: <CAFUG7CeLD7kdqd1Ec5K54P77Yjn0ccNOz4wF-rm_cDsuD=0N6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matt Brown <matt@nmatt.com>, Greg KH <gregkh@linuxfoundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 29, 2017 at 8:27 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 5/29/2017 4:51 PM, Boris Lukashev wrote:
>> With all due respect sir, i believe your review falls short of the
>> purpose of this effort - to harden the kernel against flaws in
>> userspace. Comments along the line of "if <userspace> does it right
>> then your patch is pointless" are not relevant to the context of
>> securing kernel functions/interfaces. What userspace should do has
>> little bearing on defensive measures actually implemented in the
>> kernel - if we took the approach of "someone else is responsible for
>> that" in military operations, the world would be a much darker and
>> different place today. Those who have the luxury of standoff from the
>> critical impacts of security vulnerabilities may not take into account
>> the fact that peoples lives literally depend on Linux getting a lot
>> more secure, and quickly.
>
> You are not going to help anyone with a kernel configuration that
> breaks agetty, csh, xemacs and tcsh. The opportunities for using
> such a configuration are limited.
>

First off, thank you for the clear and rational responses - newbie
status in these upstreaming/kernel matters has a bit of a steep
learning curve.
I would however, have to disagree with the above in that there is a
very large number of purpose built Linux systems in play, home routers
being a good example, which effectively retain the same security
posture over their lifetime in an increasingly hostile operating
environment. Mitigation at every tier of the attack cycle is desirable
as a  (configurable) default such as to at least reduce the impact of
compromise (they may leak memory containing the admin cred  for the
web ui via some protocol error, but dont get shells, local privs, and
raw device access). Then there are all the servers out there which
would benefit from this, as they dont use those components but do
expose TTYs to dangerous consumers, and even the workstations in a
similar boat where they dont depend on faulty consumers but are
operated by faulty users. Devil's in the details right? Ideally, if
properly designed with input from greybeards, faults can be mostly
nullified and edge cases addressed with adjacent maintainers.

>> If this work were not valuable, it wouldnt be an enabled kernel option
>> on a massive number of kernels with attack surfaces reduced by the
>> compound protections offered by the grsec patch set.
>
> I'll bet you a beverage that 99-44/100% of the people who have
> this enabled have no clue that it's even there. And if they did,
> most of them would turn it off.
>

Wouldn't dream of taking that bet - the vast majority of Linux users
dont even know they're Linux users :). Disagree with the latter part
though, the majority of people rely on the appropriate organs of
society (military, police, security-focused devs) to provide for their
safety; they not only take for granted but largely abide by the
constraints placed by those in the know such as to ensure that safety.
A cynical example being that you may not know exactly what the stuff
in that hazmat-labled container will do to you (may make you into
Wolverine, or melt your bones), but you're not likely to open it and
take a sip - you trust the people who sealed it to know enough of the
details to have made that decision. Implementing changes like this
(properly scoped and implemented, as the refinement process seems to
be doing) makes a lot of sense top-down as it forces consumers to do
things the right way instead of waiting for them before adopting a
useful function.

>> I can't speak for
>> the grsec people, but having read a small fraction of the commentary
>> around the subject of mainline integration, it seems to me that NAKs
>> like this are exactly why they had no interest in even trying - this
>> review is based on the cultural views of the kernel community, not on
>> the security benefits offered by the work in the current state of
>> affairs (where userspace is broken).
>
> A security clamp-down that breaks important stuff is going
> to have a tough row to hoe going upstream. Same with a performance
> enhancement that breaks things.
>

Back to the newbie status bit, i've read and heard (in varying degrees
of satisfaction and frustration) that upstream makes it hard to adopt
significant changes as a culture. Obviously there are practical
concerns around compatibility, but there must be some avenue to have a
clear and rational discussion with Olympus about inducing a well
planned and short period of churn to affect changes which will greatly
extend the iconic notion of systems running stable and safe for years
at a time...
In practical terms, distributions ship tons of patches for kernel bugs
faster than you can reload a blunderbuss. While that is good practice,
and should continue, it results in constant operating efforts on the
parts of the consumer having to "manage their updates" since the bug
isn't restricted in access vectors or efficacy by a global defensive
measure, but requires direct patching to mitigate. Compliance beholden
systems, which tend to be in the critical path, suffer obligatory
burdens from the status quo - find me a hospital IT security manager
who hasn't thought of running (himself or his boss) head first through
his office window since the start of the quarter, and i'll betcha he
started work Friday.
A "security clamp-down" would be great if it were well coordinated
with the ecosystem such as to have bugs found by compile-time
approaches immediately addressed by their owning maintainers, quickly
spread use of read-only and randomized structures, memory allocations,
or whatever other defenses are implemented at the core/LSM
infrastructure tiers. Once the large changes are in, things go back to
business-as-usual, but without the ops engineers being restricted to
eating with dull plastic spoons.

>> The purpose of each of these
>> protections (being ported over from grsec) is not to offer carte
>> blanche defense against all attackers and vectors, but to prevent
>> specific classes of bugs from reducing the security posture of the
>> system. By implementing these defenses in a layered manner we can
>> significantly reduce our kernel attack surface.
>
> Sure, but they have to work right. That's an important reason to do
> small changes. A change that isn't acceptable can be rejected without
> slowing the general progress.
>

Understood and agreed - getting the right scope and constraints for
the job is imperative for proper design and implementation of the
solution. As i'm reading the evolution of this thread i'm learning how
submissions evolve to fit the needs defined by members. Sort of rare
to see a process involving multiple participants these days which
hasn't devolved into a sandy goat-roping procedure.

>> Once userspace catches
>> up and does things the right way, and has no capacity for doing them
>> the wrong way (aka, nothing attackers can use to bypass the proper
>> userspace behavior), then the functionality really does become
>> pointless, and can then be removed.
>
> Well, until someone comes along with yet another spiffy feature
> like containers and breaks it again. This is why a really good
> solution is required, and the one proposed isn't up to snuff.
>
>> >From a practical perspective, can alternative solutions be offered
>> along with NAKs?
>
> They often are, but let's face it, not everyone has the time,
> desire and/or expertise to solve every problem that comes up.
>
>> Killing things on the vine isnt great, and if a
>> security measure is being denied, upstream should provide their
>> solution to how they want to address the problem (or just an outline
>> to guide the hardened folks).
>
> The impact of a "security measure" can exceed the value provided.
> That is, I understand, the basis of the NAK. We need to be careful
> to keep in mind that, until such time as there is substantial interest
> in the sort of systemic changes that truly remove this class of issue,
> we're going to have to justify the risk/reward trade off when we try
> to introduce a change.
>

Here i again, have to respectfully disagree. Waiting on "significant
interest" to patch their workstations and servers is what got a chunk
of the world looking for backups and coughing up bitcoins recently. If
there is a viable threat model, it should be addressed proactively, as
opposed to potential operating bugs which are shaken out in the course
of ops (which is how i understand current triage to work for bugs -
once its found, not potentially because conditions could create it).
Security as an afterthought can be seen as a form of complacency, and
as we've all read - "complacency kills."

>>
>> On Mon, May 29, 2017 at 6:26 PM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
>>> On Mon, 29 May 2017 17:38:00 -0400
>>> Matt Brown <matt@nmatt.com> wrote:
>>>
>>>> This introduces the tiocsti_restrict sysctl, whose default is controlled
>>>> via CONFIG_SECURITY_TIOCSTI_RESTRICT. When activated, this control
>>>> restricts all TIOCSTI ioctl calls from non CAP_SYS_ADMIN users.
>>> Which is really quite pointless as I keep pointing out and you keep
>>> reposting this nonsense.
>>>
>>>> This patch depends on patch 1/2
>>>>
>>>> This patch was inspired from GRKERNSEC_HARDEN_TTY.
>>>>
>>>> This patch would have prevented
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=1411256 under the following
>>>> conditions:
>>>> * non-privileged container
>>>> * container run inside new user namespace
>>> And assuming no other ioctl could be used in an attack. Only there are
>>> rather a lot of ways an app with access to a tty can cause mischief if
>>> it's the same controlling tty as the higher privileged context that
>>> launched it.
>>>
>>> Properly written code allocates a new pty/tty pair for the lower
>>> privileged session. If the code doesn't do that then your change merely
>>> modifies the degree of mayhem it can cause. If it does it right then your
>>> patch is pointless.
>>>
>>>> Possible effects on userland:
>>>>
>>>> There could be a few user programs that would be effected by this
>>>> change.
>>> In other words, it's yet another weird config option that breaks stuff.
>>>
>>>
>>> NAK v7.
>>>
>>> Alan
>>
>>
>
