References: <20170529213800.29438-1-matt@nmatt.com>
 <20170529213800.29438-3-matt@nmatt.com>
 <20170529232640.16211960@alans-desktop>
From: Matt Brown <matt@nmatt.com>
Message-ID: <37ebc366-2d1f-4939-db58-da72fd179418@nmatt.com>
Date: Mon, 29 May 2017 20:15:19 -0400
MIME-Version: 1.0
In-Reply-To: <20170529232640.16211960@alans-desktop>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI ioctl require
 CAP_SYS_ADMIN
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: gregkh@linuxfoundation.org, serge@hallyn.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 5/29/17 6:26 PM, Alan Cox wrote:
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

Can you give me an example of another ioctl that you can abuse to practically
gain code execution in the privileged context? Saying that the child process
could "cause mischief" is a bit vague.

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

It doesn't break anything because it is default n. People that enable this
option will understand they are disabling the tiocsti ioctl for non privileged
processes.

> 
> NAK v7.

Rather than a NAK, could you explain how you would solve this problem in a way
that we can protect userspace from shooting itself in the foot.

See CVE lookup: https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=tiocsti

Matt
