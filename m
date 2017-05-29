MIME-Version: 1.0
In-Reply-To: <20170529232640.16211960@alans-desktop>
References: <20170529213800.29438-1-matt@nmatt.com> <20170529213800.29438-3-matt@nmatt.com>
 <20170529232640.16211960@alans-desktop>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Mon, 29 May 2017 19:51:42 -0400
Message-ID: <CAFUG7CdDd0Yfegb1S6_wNQzje4EuLE0jPdvOE=uSQL152meyjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Matt Brown <matt@nmatt.com>, Greg KH <gregkh@linuxfoundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

With all due respect sir, i believe your review falls short of the
purpose of this effort - to harden the kernel against flaws in
userspace. Comments along the line of "if <userspace> does it right
then your patch is pointless" are not relevant to the context of
securing kernel functions/interfaces. What userspace should do has
little bearing on defensive measures actually implemented in the
kernel - if we took the approach of "someone else is responsible for
that" in military operations, the world would be a much darker and
different place today. Those who have the luxury of standoff from the
critical impacts of security vulnerabilities may not take into account
the fact that peoples lives literally depend on Linux getting a lot
more secure, and quickly.
If this work were not valuable, it wouldnt be an enabled kernel option
on a massive number of kernels with attack surfaces reduced by the
compound protections offered by the grsec patch set. I can't speak for
the grsec people, but having read a small fraction of the commentary
around the subject of mainline integration, it seems to me that NAKs
like this are exactly why they had no interest in even trying - this
review is based on the cultural views of the kernel community, not on
the security benefits offered by the work in the current state of
affairs (where userspace is broken). The purpose of each of these
protections (being ported over from grsec) is not to offer carte
blanche defense against all attackers and vectors, but to prevent
specific classes of bugs from reducing the security posture of the
system. By implementing these defenses in a layered manner we can
significantly reduce our kernel attack surface. Once userspace catches
up and does things the right way, and has no capacity for doing them
the wrong way (aka, nothing attackers can use to bypass the proper
userspace behavior), then the functionality really does become
pointless, and can then be removed.
>From a practical perspective, can alternative solutions be offered
along with NAKs? Killing things on the vine isnt great, and if a
security measure is being denied, upstream should provide their
solution to how they want to address the problem (or just an outline
to guide the hardened folks).

On Mon, May 29, 2017 at 6:26 PM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
> On Mon, 29 May 2017 17:38:00 -0400
> Matt Brown <matt@nmatt.com> wrote:
>
>> This introduces the tiocsti_restrict sysctl, whose default is controlled
>> via CONFIG_SECURITY_TIOCSTI_RESTRICT. When activated, this control
>> restricts all TIOCSTI ioctl calls from non CAP_SYS_ADMIN users.
>
> Which is really quite pointless as I keep pointing out and you keep
> reposting this nonsense.
>
>>
>> This patch depends on patch 1/2
>>
>> This patch was inspired from GRKERNSEC_HARDEN_TTY.
>>
>> This patch would have prevented
>> https://bugzilla.redhat.com/show_bug.cgi?id=1411256 under the following
>> conditions:
>> * non-privileged container
>> * container run inside new user namespace
>
> And assuming no other ioctl could be used in an attack. Only there are
> rather a lot of ways an app with access to a tty can cause mischief if
> it's the same controlling tty as the higher privileged context that
> launched it.
>
> Properly written code allocates a new pty/tty pair for the lower
> privileged session. If the code doesn't do that then your change merely
> modifies the degree of mayhem it can cause. If it does it right then your
> patch is pointless.
>
>> Possible effects on userland:
>>
>> There could be a few user programs that would be effected by this
>> change.
>
> In other words, it's yet another weird config option that breaks stuff.
>
>
> NAK v7.
>
> Alan



-- 
Boris Lukashev
Systems Architect
Semper Victus
