References: <20170529213800.29438-1-matt@nmatt.com>
 <20170529213800.29438-3-matt@nmatt.com>
 <20170529232640.16211960@alans-desktop>
 <CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
 <3738951f-7a4a-b37f-c695-21a2fcd45f76@schaufler-ca.com>
 <0e078ce7-5b62-f27c-3920-efc2ffdf342b@nmatt.com>
 <b0a29f23-4154-8f2f-98e7-0942612f0cdc@schaufler-ca.com>
 <e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <db8fb372-27c8-6332-74b1-fe99cf5aedcb@schaufler-ca.com>
Date: Tue, 30 May 2017 08:20:12 -0700
MIME-Version: 1.0
In-Reply-To: <e1c9e4e8-5427-b4b6-aad2-72c88552a6af@nmatt.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>, Boris Lukashev <blukashev@sempervictus.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 5/29/2017 8:18 PM, Matt Brown wrote:
> On 5/29/17 10:46 PM, Casey Schaufler wrote:
>> On 5/29/2017 7:00 PM, Matt Brown wrote:
>>> Casey Schaufler,
>>>
>>> First I must start this off by saying I really appreciate your presentation on
>>> LSMs that is up on youtube. I've got a LSM in the works and your talk has
>>> helped me a bunch.
>> Thank you. Feedback (especially positive) is always appreciated.
>>
>>> On 5/29/17 8:27 PM, Casey Schaufler wrote:
>>>> On 5/29/2017 4:51 PM, Boris Lukashev wrote:
>>>>> With all due respect sir, i believe your review falls short of the
>>>>> purpose of this effort - to harden the kernel against flaws in
>>>>> userspace. Comments along the line of "if <userspace> does it right
>>>>> then your patch is pointless" are not relevant to the context of
>>>>> securing kernel functions/interfaces. What userspace should do has
>>>>> little bearing on defensive measures actually implemented in the
>>>>> kernel - if we took the approach of "someone else is responsible for
>>>>> that" in military operations, the world would be a much darker and
>>>>> different place today. Those who have the luxury of standoff from the
>>>>> critical impacts of security vulnerabilities may not take into account
>>>>> the fact that peoples lives literally depend on Linux getting a lot
>>>>> more secure, and quickly.
>>>> You are not going to help anyone with a kernel configuration that
>>>> breaks agetty, csh, xemacs and tcsh. The opportunities for using
>>>> such a configuration are limited.
>>> This patch does not break these programs as you imply. 99% of users of these
>>> programs will not be effected. Its not like the TIOCSTI ioctl is a critical
>>> part of these programs.
>> Most likely not.
>>
>>> Also as I've stated elsewhere, this is not breaking userspace because this
>>> Kconfig/sysctl defaults to n. If someone is using the programs listed above in
>>> a way that does utilize an unprivileged call to the TIOCSTI ioctl, they can
>>> turn this feature off.
>> Default "off" does not mean it doesn't break userspace. It means that it might
>> not break userspace in your environment. Or it might, depending on the whim of
>> the build tool of the day.
>>
> By this logic, it seems like any introduced feature which toggles some security
> feature could be seen as "breaking userspace." For example:
>
> 1. Let there exist a LSM X that is set to "off" by default.
> 	(let's say its a simpler type of MAC ;)

You picked a bad example ...

> 2. There exists an inexperienced user Bob that toggles X to "on".

... which is easy enough, however ...

> 3. Bob complains that X has broken userspace because he now cannot access his
> SSH key from firefox.

... that's not going to happen. Because the LSM you're referring to requires
additional configuration to "break" userspace. That, by the way, was a conscious
design choice. Now, I realize that's not the case for some other security modules,
but they have things like "permissive mode" to make it easy on accident prone Bob.

The analogy, while obvious, is invalid.

> build tool's will always have important impacts on a system based on the config
> that is used.
>
> My understanding of the "don't break userspace" rule has always been to not
> change existing, userspace facing, APIs/ioctls/system calls/etc. I don't
> believe that my patch does this.
>
>>>>> If this work were not valuable, it wouldnt be an enabled kernel option
>>>>> on a massive number of kernels with attack surfaces reduced by the
>>>>> compound protections offered by the grsec patch set.
>>>> I'll bet you a beverage that 99-44/100% of the people who have
>>>> this enabled have no clue that it's even there. And if they did,
>>>> most of them would turn it off.
>>>>
>>> First, I don't know how to parse "99-44/100%" and therefore do not wish to
>>> wager a beverage on such confusing odds ;)
>> 99.44%. And I loose a *lot* of beverage bets.
>>
>>> Second, as stated above, this feature is off by default. However, I would expect
>>> this sysctl to show up in lists of procedures for hardening linux servers.
>> It's esoteric enough that I expect that if anyone got bitten by it
>> word would get out and no one would use it thereafter.
>>
> As we know in the security world, esoteric things can have major a impact. I
> have not looked thought all of these, but I imagine most of them could have
> been prevented by this patch.
>
> https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=tiocsti
>
>>>>> I can't speak for
>>>>> the grsec people, but having read a small fraction of the commentary
>>>>> around the subject of mainline integration, it seems to me that NAKs
>>>>> like this are exactly why they had no interest in even trying - this
>>>>> review is based on the cultural views of the kernel community, not on
>>>>> the security benefits offered by the work in the current state of
>>>>> affairs (where userspace is broken).
>>>> A security clamp-down that breaks important stuff is going
>>>> to have a tough row to hoe going upstream. Same with a performance
>>>> enhancement that breaks things.
>>>>
>>>>> The purpose of each of these
>>>>> protections (being ported over from grsec) is not to offer carte
>>>>> blanche defense against all attackers and vectors, but to prevent
>>>>> specific classes of bugs from reducing the security posture of the
>>>>> system. By implementing these defenses in a layered manner we can
>>>>> significantly reduce our kernel attack surface.
>>>> Sure, but they have to work right. That's an important reason to do
>>>> small changes. A change that isn't acceptable can be rejected without
>>>> slowing the general progress.
>>>>
>>>>> Once userspace catches
>>>>> up and does things the right way, and has no capacity for doing them
>>>>> the wrong way (aka, nothing attackers can use to bypass the proper
>>>>> userspace behavior), then the functionality really does become
>>>>> pointless, and can then be removed.
>>>> Well, until someone comes along with yet another spiffy feature
>>>> like containers and breaks it again. This is why a really good
>>>> solution is required, and the one proposed isn't up to snuff.
>>>>
>>> Can you please state your reasons for why you believe this solution is not "up
>>> to snuff?" So far myself and others have given what I believe to be sound
>>> responses to any objections to this patch.
>> If you can't convince Alan, who know ways more about ttys than anyone
>> ought to, it's not up to snuff.
>>
>>>>> >From a practical perspective, can alternative solutions be offered
>>>>> along with NAKs?
>>>> They often are, but let's face it, not everyone has the time,
>>>> desire and/or expertise to solve every problem that comes up.
>>>>
>>>>> Killing things on the vine isnt great, and if a
>>>>> security measure is being denied, upstream should provide their
>>>>> solution to how they want to address the problem (or just an outline
>>>>> to guide the hardened folks).
>>>> The impact of a "security measure" can exceed the value provided.
>>>> That is, I understand, the basis of the NAK. We need to be careful
>>>> to keep in mind that, until such time as there is substantial interest
>>>> in the sort of systemic changes that truly remove this class of issue,
>>>> we're going to have to justify the risk/reward trade off when we try
>>>> to introduce a change.
>>>>
>>>>> On Mon, May 29, 2017 at 6:26 PM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
>>>>>> On Mon, 29 May 2017 17:38:00 -0400
>>>>>> Matt Brown <matt@nmatt.com> wrote:
>>>>>>
>>>>>>> This introduces the tiocsti_restrict sysctl, whose default is controlled
>>>>>>> via CONFIG_SECURITY_TIOCSTI_RESTRICT. When activated, this control
>>>>>>> restricts all TIOCSTI ioctl calls from non CAP_SYS_ADMIN users.
>>>>>> Which is really quite pointless as I keep pointing out and you keep
>>>>>> reposting this nonsense.
>>>>>>
>>>>>>> This patch depends on patch 1/2
>>>>>>>
>>>>>>> This patch was inspired from GRKERNSEC_HARDEN_TTY.
>>>>>>>
>>>>>>> This patch would have prevented
>>>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=1411256 under the following
>>>>>>> conditions:
>>>>>>> * non-privileged container
>>>>>>> * container run inside new user namespace
>>>>>> And assuming no other ioctl could be used in an attack. Only there are
>>>>>> rather a lot of ways an app with access to a tty can cause mischief if
>>>>>> it's the same controlling tty as the higher privileged context that
>>>>>> launched it.
>>>>>>
>>>>>> Properly written code allocates a new pty/tty pair for the lower
>>>>>> privileged session. If the code doesn't do that then your change merely
>>>>>> modifies the degree of mayhem it can cause. If it does it right then your
>>>>>> patch is pointless.
>>>>>>
>>>>>>> Possible effects on userland:
>>>>>>>
>>>>>>> There could be a few user programs that would be effected by this
>>>>>>> change.
>>>>>> In other words, it's yet another weird config option that breaks stuff.
>>>>>>
>>>>>>
>>>>>> NAK v7.
>>>>>>
>>>>>> Alan
>>> Thanks,
>>> Matt Brown
>>>
