References: <20170505232018.28846-1-matt@nmatt.com>
 <20170505232018.28846-3-matt@nmatt.com> <20170518133126.GA29952@kroah.com>
From: Matt Brown <matt@nmatt.com>
Message-ID: <9a633fdc-c260-d9e2-14ed-6911b6950ec0@nmatt.com>
Date: Fri, 19 May 2017 00:51:29 -0400
MIME-Version: 1.0
In-Reply-To: <20170518133126.GA29952@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v6 2/2] security: tty: make TIOCSTI ioctl require
 CAP_SYS_ADMIN
To: Greg KH <gregkh@linuxfoundation.org>
Cc: serge@hallyn.com, jslaby@suse.com, akpm@linux-foundation.org, jannh@google.com, keescook@chromium.org, jmorris@namei.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 5/18/17 9:31 AM, Greg KH wrote:
> On Fri, May 05, 2017 at 07:20:18PM -0400, Matt Brown wrote:
>> This introduces the tiocsti_restrict sysctl, whose default is controlled via
>> CONFIG_SECURITY_TIOCSTI_RESTRICT. When activated, this control restricts
>> all TIOCSTI ioctl calls from non CAP_SYS_ADMIN users.
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
>>
>> Possible effects on userland:
>>
>> There could be a few user programs that would be effected by this
>> change.
>> See: <https://codesearch.debian.net/search?q=ioctl%5C%28.*TIOCSTI>
>> notable programs are: agetty, csh, xemacs and tcsh
>>
>> However, I still believe that this change is worth it given that the
>> Kconfig defaults to n. This will be a feature that is turned on for the
>> same reason that people activate it when using grsecurity. Users of this
>> opt-in feature will realize that they are choosing security over some OS
>> features like unprivileged TIOCSTI ioctls, as should be clear in the
>> Kconfig help message.
>>
>> Threat Model/Patch Rational:
>>
>> >From grsecurity's config for GRKERNSEC_HARDEN_TTY.
>>
>>  | There are very few legitimate uses for this functionality and it
>>  | has made vulnerabilities in several 'su'-like programs possible in
>>  | the past.  Even without these vulnerabilities, it provides an
>>  | attacker with an easy mechanism to move laterally among other
>>  | processes within the same user's compromised session.
>>
>> So if one process within a tty session becomes compromised it can follow
>> that additional processes, that are thought to be in different security
>> boundaries, can be compromised as a result. When using a program like su
>> or sudo, these additional processes could be in a tty session where TTY file
>> descriptors are indeed shared over privilege boundaries.
>>
>> This is also an excellent writeup about the issue:
>> <http://www.halfdog.net/Security/2012/TtyPushbackPrivilegeEscalation/>
>>
>> When user namespaces are in use, the check for the capability
>> CAP_SYS_ADMIN is done against the user namespace that originally opened
>> the tty.
>>
>> Acked-by: Serge Hallyn <serge@hallyn.com>
>> Reviewed-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Matt Brown <matt@nmatt.com>
>> ---
>>  Documentation/sysctl/kernel.txt | 21 +++++++++++++++++++++
>>  drivers/tty/tty_io.c            |  6 ++++++
>>  include/linux/tty.h             |  2 ++
>>  kernel/sysctl.c                 | 12 ++++++++++++
>>  security/Kconfig                | 13 +++++++++++++
>>  5 files changed, 54 insertions(+)
>>
>> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
>> index bac23c1..f7985cf 100644
>> --- a/Documentation/sysctl/kernel.txt
>> +++ b/Documentation/sysctl/kernel.txt
>> @@ -89,6 +89,7 @@ show up in /proc/sys/kernel:
>>  - sysctl_writes_strict
>>  - tainted
>>  - threads-max
>> +- tiocsti_restrict
>>  - unknown_nmi_panic
>>  - watchdog
>>  - watchdog_thresh
>> @@ -987,6 +988,26 @@ available RAM pages threads-max is reduced accordingly.
>>  
>>  ==============================================================
>>  
>> +tiocsti_restrict:
>> +
>> +This toggle indicates whether unprivileged users are prevented
>> +from using the TIOCSTI ioctl to inject commands into other processes
>> +which share a tty session.
>> +
>> +When tiocsti_restrict is set to (0) there are no restrictions(accept
>> +the default restriction of only being able to injection commands into
>> +one's own tty). When tiocsti_restrict is set to (1), users must
>> +have CAP_SYS_ADMIN to use the TIOCSTI ioctl.
>> +
>> +When user namespaces are in use, the check for the capability
>> +CAP_SYS_ADMIN is done against the user namespace that originally
>> +opened the tty.
>> +
>> +The kernel config option CONFIG_SECURITY_TIOCSTI_RESTRICT sets the
>> +default value of tiocsti_restrict.
>> +
>> +==============================================================
>> +
>>  unknown_nmi_panic:
>>  
>>  The value in this file affects behavior of handling NMI. When the
>> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
>> index c276814..fe68d14 100644
>> --- a/drivers/tty/tty_io.c
>> +++ b/drivers/tty/tty_io.c
>> @@ -2297,11 +2297,17 @@ static int tty_fasync(int fd, struct file *filp, int on)
>>   *	FIXME: may race normal receive processing
>>   */
>>  
>> +int tiocsti_restrict = IS_ENABLED(CONFIG_SECURITY_TIOCSTI_RESTRICT);
>> +
>>  static int tiocsti(struct tty_struct *tty, char __user *p)
>>  {
>>  	char ch, mbz = 0;
>>  	struct tty_ldisc *ld;
>>  
>> +	if (tiocsti_restrict && !ns_capable(tty->owner_user_ns,CAP_SYS_ADMIN)) {
>> +		pr_warn_ratelimited("TIOCSTI ioctl call blocked for non-privileged process\n");
>> +		return -EPERM;
> 
> Always follow the proper kernel coding style rules, as I don't want to
> have someone else have to come along and fix up the error you have added
> here :(
> 
> checkpatch.pl is your friend, really...
> 

My bad. Will fix these issues in v7.

> And why not do a warning with the device that caused the problem to
> happen?  dev_warn has a ratelimit I think right?  "raw" printk messages
> like this don't help in trying to track down what/who caused the issue.
> 

yes <linux/device.h> has dev_warn_ratelimited. I will use that in 7v.

> And finally, can userspace see the namespace for the tty?  Doesn't
> things like checkpoint/restore need that in order to properly set the
> tty connection back up when moving processes?

This seems like we would need to expose the owner_user_ns of the tty in procfs
somewhere. Section 1.7 Documentation/filesystems/proc.txt describes the
following files in /proc/tty:

Table 1-11: Files in /proc/tty
..............................................................................
 File          Content
 drivers       list of drivers and their usage
 ldiscs        registered line disciplines
 driver/serial usage statistic and status of single tty lines
..............................................................................

The drivers file is the one that gives the most information that we are
interested in.

However, the current layout combines information about multiple ttys by driver.
As I understand it, a single driver may have ttys that span across different
owner_user_ns. would it make sense to add a file /proc/tty/ns that would
contain the different tty to user namespace mappings? Or is there a better way
to do this? I would appreciate any feedback/ideas you have on this.

> 
> v7?  :)

v7 will be on its way soon. I'm not currently sure how to address the concern
of giving things like checkpoint/restore in userland a way to get the
owner_user_ns.

> 
> thanks,
> 
> greg k-h
> 

Thanks for the feedback,

Matt Brown
