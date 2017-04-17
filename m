References: <20170417060706.28674-1-matt@nmatt.com>
 <20170417060706.28674-4-matt@nmatt.com> <20170417065345.GC21022@kroah.com>
 <CAG48ez1NBnrsPnHN6D9nbOJP6+Q6zEV9vfx9q7ME4Eti-vRmhQ@mail.gmail.com>
From: Matt Brown <matt@nmatt.com>
Message-ID: <6638dd35-e154-4145-804e-c6fd3ebd32d7@nmatt.com>
Date: Mon, 17 Apr 2017 12:18:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAG48ez1NBnrsPnHN6D9nbOJP6+Q6zEV9vfx9q7ME4Eti-vRmhQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH 3/4] restrict unprivileged TIOCSTI
 tty ioctl
To: Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: jmorris@namei.org, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 04/17/2017 10:18 AM, Jann Horn wrote:
> On Mon, Apr 17, 2017 at 8:53 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Mon, Apr 17, 2017 at 02:07:05AM -0400, Matt Brown wrote:
>>> this patch depends on patch 1 and 2
>>>
>>> enforces restrictions on unprivileged users injecting commands
>>> into other processes in the same tty session using the TIOCSTI ioctl
>>>
>>> Signed-off-by: Matt Brown <matt@nmatt.com>
>>> ---
>>>  drivers/tty/tty_io.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
>>> index e6d1a65..31894e8 100644
>>> --- a/drivers/tty/tty_io.c
>>> +++ b/drivers/tty/tty_io.c
>>> @@ -2296,11 +2296,15 @@ static int tty_fasync(int fd, struct file *filp, int on)
>>>   *   FIXME: may race normal receive processing
>>>   */
>>>
>>> +int tiocsti_restrict = IS_ENABLED(CONFIG_SECURITY_TIOCSTI_RESTRICT);
>>> +
>>>  static int tiocsti(struct tty_struct *tty, char __user *p)
>>>  {
>>>       char ch, mbz = 0;
>>>       struct tty_ldisc *ld;
>>>
>>> +     if (tiocsti_restrict && !capable(CAP_SYS_ADMIN))
>>> +             return -EPERM;
>>
>> So, what type of "normal" userspace operations did you just break here?
>> What type of "not normal" did you break/change?
>
> Looking at
> <https://codesearch.debian.net/search?q=ioctl%5C%28.*TIOCSTI>,
> it looks like there are a couple users whose behavior would probably
> change when run by unprivileged users - in particular agetty, csh, xemacs
> and tcsh.
>

This is why I set this Kconfig to default to no.

This is also why I think this belongs under security and not tty. This
is more of a security feature than a tty feature.

>
>> Why tie this to CAP_SYS_ADMIN as well?  That wasn't listed in your
>> Kconfig help text.  This seems like an additional capabilities
>> dependancy that odds are, most people do not want...
>>
>>>       if ((current->signal->tty != tty) && !capable(CAP_SYS_ADMIN))
>>>               return -EPERM;
>
> I think CAP_SYS_ADMIN is a logical choice here. AFAIK
> CAP_SYS_ADMIN is normally used for random functionality that permits
> users to bypass normal access controls without constraints that clearly
> map to existing capabilities. See seccomp() without NNP,
> proc_dointvec_minmax_sysadmin() and so on.
>
> I guess you could also argue for CAP_SYS_TTY_CONFIG, but I don't
> think that fits well, given that this is more about using a TTY in a
> privileged way than about configuring it.
>

I can update the Kconfig help text to mention the use of CAP_SYS_ADMIN.

>
>> And finally, why doesn't this original check handle what you want to do
>> already?
>>
>> I don't understand your "threat model" you wish to address by this
>> change series, please be a lot more explicit in your patch changelog
>> descriptions.
>
> While I don't know what Matt Brown's threat model is here, I like the
> patch for the following reason:
>
> For me, there are two usecases for having UIDs on a Linux
> system. The first usecase is to isolate human users from each other.
> The second usecase are service accounts, where the same human
> administrator has access to multiple UIDs, each of which is used for
> one specific service, reducing the impact of a compromise of a single
> service.
>
> In the "isolated services" usecase, the machine's administrator needs
> to be able to access the various service accounts in some way. One
> way that integrates well with existing tools is to log in as root, then
> use su or sudo to run a shell with the service's UID with reduced
> privileges.
>
> The only issue I know of that makes this dangerous in the default
> configuration is that the tty file descriptor becomes accessible to the
> shell running under the service's UID, allowing the service to e.g.
> use ptrace() or .bashrc or so to inject code into the service-privileged
> shell, then abuse TIOCSTI to take over root's shell.
>
> So, the reason the additional check is necessary is that there are
> usecases where in practice, TTY file descriptors are shared over
> privilege boundaries, and thereforce, access to the TTY fd should not
> automatically grant the level of access that is normally only available
> using a PTY master fd.
>
> sudo can mitigate this using the use_pty config option, which creates
> a new PTY and forwards I/O to and from that PTY, but this option is
> off by default. I think the version of su that e.g. ships in Debian can't
> even be configured to mitigate this.
>
> In my opinion, while it's possible for system administrators or
> programmers to avoid this pitfall if they know enough about how TTY
> devices work, this behavior is highly unintuitive.
>
> Also, quoting part of the help text for grsecurity's config option
> GRKERNSEC_HARDEN_TTY:
>
> | There are very few legitimate uses for this functionality and it
> | has made vulnerabilities in several 'su'-like programs possible in
> | the past.  Even without these vulnerabilities, it provides an
> | attacker with an easy mechanism to move laterally among other
> | processes within the same user's compromised session.
>
> Basically, TIOCSTI permits exactly what Yama is designed to
> prevent: It lets different processes in one session compromise
> each other.
>
>
> For context, in case someone in this thread hasn't seen it yet:
> http://www.halfdog.net/Security/2012/TtyPushbackPrivilegeEscalation/
> is a writeup about the issue and some prior discussions about it.
>

I couldn't have explained my threat model and rational better myself.

I can take any other feedback and roll it into a single updated patch.
