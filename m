MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Apr 2017 13:15:15 -0400
From: matt@nmatt.com
In-Reply-To: <20170420151928.GA14559@mail.hallyn.com>
References: <20170419034526.18565-1-matt@nmatt.com>
 <20170419045813.GA17990@mail.hallyn.com>
 <a6b8f9ab-d5f8-51fb-0481-89907c43289f@nmatt.com>
 <20170419235342.GA2305@mail.hallyn.com>
 <59d67e42-3532-6001-91cb-067bff1eec64@nmatt.com>
 <20170420151928.GA14559@mail.hallyn.com>
Message-ID: <0b6cec15f206329fc523983534baaf0d@nmatt.com>
Subject: [kernel-hardening] Re: [PATCH] make TIOCSTI ioctl require CAP_SYS_ADMIN
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: jmorris@namei.org, gregkh@linuxfoundation.org, jslaby@suse.com, akpm@linux-foundation.org, jannh@google.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-04-20 11:19, Serge E. Hallyn wrote:
> Quoting Matt Brown (matt@nmatt.com):
>> On 04/19/2017 07:53 PM, Serge E. Hallyn wrote:
>> >Quoting Matt Brown (matt@nmatt.com):
>> >>On 04/19/2017 12:58 AM, Serge E. Hallyn wrote:
>> >>>On Tue, Apr 18, 2017 at 11:45:26PM -0400, Matt Brown wrote:
>> >>>>This patch reproduces GRKERNSEC_HARDEN_TTY functionality from the grsecurity
>> >>>>project in-kernel.
>> >>>>
>> >>>>This will create the Kconfig SECURITY_TIOCSTI_RESTRICT and the corresponding
>> >>>>sysctl kernel.tiocsti_restrict that, when activated, restrict all TIOCSTI
>> >>>>ioctl calls from non CAP_SYS_ADMIN users.
>> >>>>
>> >>>>Possible effects on userland:
>> >>>>
>> >>>>There could be a few user programs that would be effected by this
>> >>>>change.
>> >>>>See: <https://codesearch.debian.net/search?q=ioctl%5C%28.*TIOCSTI>
>> >>>>notable programs are: agetty, csh, xemacs and tcsh
>> >>>>
>> >>>>However, I still believe that this change is worth it given that the
>> >>>>Kconfig defaults to n. This will be a feature that is turned on for the
>> >>>
>> >>>It's not worthless, but note that for instance before this was fixed
>> >>>in lxc, this patch would not have helped with escapes from privileged
>> >>>containers.
>> >>>
>> >>
>> >>I assume you are talking about this CVE:
>> >>https://bugzilla.redhat.com/show_bug.cgi?id=1411256
>> >>
>> >>In retrospect, is there any way that an escape from a privileged
>> >>container with the this bug could have been prevented?
>> >
>> >I don't know, that's what I was probing for.  Detecting that the pgrp
>> >or session - heck, the pid namespace - has changed would seem like a
>> >good indicator that it shouldn't be able to push.
>> >
>> 
>> pgrp and session won't do because in the case we are discussing
>> current->signal->tty is the same as tty.
>> 
>> This is the current check that is already in place:
>>  | if ((current->signal->tty != tty) && !capable(CAP_SYS_ADMIN))
>>  | 	return -EPERM;
> 
> Yeah...
> 
>> The only thing I could find to detect the tty message coming from a
>> container is as follows:
>>  | task_active_pid_ns(current)->level
>> 
>> This will be zero when run on the host, but 1 when run inside a
>> container. However this is very much a hack and could probably break
>> some userland stuff where there are multiple levels of namespaces.
> 
> Yes.  This is also however why I don't like the current patch, because
> capable() will never be true in a container, so nested containers 
> break.
> 

What do you mean by "capable() will never be true in a container"? My 
understanding
is that if a container is given CAP_SYS_ADMIN then 
capable(CAP_SYS_ADMIN) will return
true? I agree the hack I mentioned above would be a bad idea because it 
would break
nested containers, but the current patch would not IMO.

A better version of the hack could involve a config 
CONFIG_TIOCSTI_MAX_NS_LEVEL where
a check would be performed to ensure that 
task_active_pid_ns(current)->level is not
greater than the config value(an integer that is >= 0) .

Again, I think we both would agree that this is not the best solution. 
The clear
downside is that you could have multiple container layers where the 
desired security
boundaries happened to fall at different levels. Just throwing ideas 
around.

> What does current->signal->tty->pgrp actually point to?  Can we take
> it to be the pgrp which opened it?  Could we check
> ns_capable(current_pid_ns()->user_ns, CAP_whatever) and get a 
> meaningful
> answer?
> 
>> The real problem is that there are no TTY namespaces. I don't think we
>> can solve this problem for CAP_SYS_ADMIN containers unless we want to
>> introduce a config that allows one to override normal CAP_SYS_ADMIN
>> functionality by denying TIOCSTI ioctls for processes whom
>> task_active_pid_ns(current)->level is equal to 0.
>> 
>> In the mean time, I think we can go ahead with this feature to give
>> people the ability to lock down non CAP_SYS_ADMIN 
>> containers/processes.
>> 
>> >>>>same reason that people activate it when using grsecurity. Users of this
>> >>>>opt-in feature will realize that they are choosing security over some OS
>> >>>>features like unprivileged TIOCSTI ioctls, as should be clear in the
>> >>>>Kconfig help message.
>> >>>>
>> >>>>Threat Model/Patch Rational:
>> >>>>
>> >>>>>From grsecurity's config for GRKERNSEC_HARDEN_TTY.
>> >>>>
>> >>>>| There are very few legitimate uses for this functionality and it
>> >>>>| has made vulnerabilities in several 'su'-like programs possible in
>> >>>>| the past.  Even without these vulnerabilities, it provides an
>> >>>>| attacker with an easy mechanism to move laterally among other
>> >>>>| processes within the same user's compromised session.
>> >>>>
>> >>>>So if one process within a tty session becomes compromised it can follow
>> >>>>that additional processes, that are thought to be in different security
>> >>>>boundaries, can be compromised as a result. When using a program like su
>> >>>>or sudo, these additional processes could be in a tty session where TTY file
>> >>>>descriptors are indeed shared over privilege boundaries.
>> >>>>
>> >>>>This is also an excellent writeup about the issue:
>> >>>><http://www.halfdog.net/Security/2012/TtyPushbackPrivilegeEscalation/>
>> >>>>
>> >>>>Signed-off-by: Matt Brown <matt@nmatt.com>
>> >>>>---
>> >>>>drivers/tty/tty_io.c |  4 ++++
>> >>>>include/linux/tty.h  |  2 ++
>> >>>>kernel/sysctl.c      | 12 ++++++++++++
>> >>>>security/Kconfig     | 13 +++++++++++++
>> >>>>4 files changed, 31 insertions(+)
>> >>>>
>> >>>>diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
>> >>>>index e6d1a65..31894e8 100644
>> >>>>--- a/drivers/tty/tty_io.c
>> >>>>+++ b/drivers/tty/tty_io.c
>> >>>>@@ -2296,11 +2296,15 @@ static int tty_fasync(int fd, struct file *filp, int on)
>> >>>> *	FIXME: may race normal receive processing
>> >>>> */
>> >>>>
>> >>>>+int tiocsti_restrict = IS_ENABLED(CONFIG_SECURITY_TIOCSTI_RESTRICT);
>> >>>>+
>> >>>>static int tiocsti(struct tty_struct *tty, char __user *p)
>> >>>>{
>> >>>>	char ch, mbz = 0;
>> >>>>	struct tty_ldisc *ld;
>> >>>>
>> >>>>+	if (tiocsti_restrict && !capable(CAP_SYS_ADMIN))
>> >>>>+		return -EPERM;
>> >>>>	if ((current->signal->tty != tty) && !capable(CAP_SYS_ADMIN))
>> >>>>		return -EPERM;
>> >>>>	if (get_user(ch, p))
>> >>>>diff --git a/include/linux/tty.h b/include/linux/tty.h
>> >>>>index 1017e904..7011102 100644
>> >>>>--- a/include/linux/tty.h
>> >>>>+++ b/include/linux/tty.h
>> >>>>@@ -342,6 +342,8 @@ struct tty_file_private {
>> >>>>	struct list_head list;
>> >>>>};
>> >>>>
>> >>>>+extern int tiocsti_restrict;
>> >>>>+
>> >>>>/* tty magic number */
>> >>>>#define TTY_MAGIC		0x5401
>> >>>>
>> >>>>diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> >>>>index acf0a5a..68d1363 100644
>> >>>>--- a/kernel/sysctl.c
>> >>>>+++ b/kernel/sysctl.c
>> >>>>@@ -67,6 +67,7 @@
>> >>>>#include <linux/kexec.h>
>> >>>>#include <linux/bpf.h>
>> >>>>#include <linux/mount.h>
>> >>>>+#include <linux/tty.h>
>> >>>>
>> >>>>#include <linux/uaccess.h>
>> >>>>#include <asm/processor.h>
>> >>>>@@ -833,6 +834,17 @@ static struct ctl_table kern_table[] = {
>> >>>>		.extra2		= &two,
>> >>>>	},
>> >>>>#endif
>> >>>>+#if defined CONFIG_TTY
>> >>>>+	{
>> >>>>+		.procname	= "tiocsti_restrict",
>> >>>>+		.data		= &tiocsti_restrict,
>> >>>>+		.maxlen		= sizeof(int),
>> >>>>+		.mode		= 0644,
>> >>>>+		.proc_handler	= proc_dointvec_minmax_sysadmin,
>> >>>>+		.extra1		= &zero,
>> >>>>+		.extra2		= &one,
>> >>>>+	},
>> >>>>+#endif
>> >>>>	{
>> >>>>		.procname	= "ngroups_max",
>> >>>>		.data		= &ngroups_max,
>> >>>>diff --git a/security/Kconfig b/security/Kconfig
>> >>>>index 3ff1bf9..7d13331 100644
>> >>>>--- a/security/Kconfig
>> >>>>+++ b/security/Kconfig
>> >>>>@@ -18,6 +18,19 @@ config SECURITY_DMESG_RESTRICT
>> >>>>
>> >>>>	  If you are unsure how to answer this question, answer N.
>> >>>>
>> >>>>+config SECURITY_TIOCSTI_RESTRICT
>> >>>
>> >>>This is an odd way to name this.  Shouldn't the name reflect that it
>> >>>is setting the default, rather than enabling the feature?
>> >>>
>> >>>Besides that, I'm ok with the patch.
>> >>>
>> >>>>+	bool "Restrict unprivileged use of tiocsti command injection"
>> >>>>+	default n
>> >>>>+	help
>> >>>>+	  This enforces restrictions on unprivileged users injecting commands
>> >>>>+	  into other processes which share a tty session using the TIOCSTI
>> >>>>+	  ioctl. This option makes TIOCSTI use require CAP_SYS_ADMIN.
>> >>>>+
>> >>>>+	  If this option is not selected, no restrictions will be enforced
>> >>>>+	  unless the tiocsti_restrict sysctl is explicitly set to (1).
>> >>>>+
>> >>>>+	  If you are unsure how to answer this question, answer N.
>> >>>>+
>> >>>>config SECURITY
>> >>>>	bool "Enable different security models"
>> >>>>	depends on SYSFS
>> >>>>--
>> >>>>2.10.2
