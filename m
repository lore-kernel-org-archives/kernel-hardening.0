From: Matt Brown <matt@nmatt.com>
Date: Mon, 29 May 2017 17:37:58 -0400
Message-Id: <20170529213800.29438-1-matt@nmatt.com>
Subject: [kernel-hardening] [PATCH v7 0/2] security: tty: make TIOCSTI ioctl require CAP_SYS_ADMIN
To: gregkh@linuxfoundation.org, serge@hallyn.com, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


This patchset introduces the tiocsti_restrict sysctl, whose default is
controlled via CONFIG_SECURITY_TIOCSTI_RESTRICT. When activated, this
control restricts all TIOCSTI ioctl calls from non CAP_SYS_ADMIN users.

This patch was inspired from GRKERNSEC_HARDEN_TTY.

This patch would have prevented
https://bugzilla.redhat.com/show_bug.cgi?id=1411256 under the following
conditions:
* non-privileged container
* container run inside new user namespace

Possible effects on userland:

There could be a few user programs that would be effected by this
change.
See: <https://codesearch.debian.net/search?q=ioctl%5C%28.*TIOCSTI>
notable programs are: agetty, csh, xemacs and tcsh

However, I still believe that this change is worth it given that the
Kconfig defaults to n. This will be a feature that is turned on for the
same reason that people activate it when using grsecurity. Users of this
opt-in feature will realize that they are choosing security over some OS
features like unprivileged TIOCSTI ioctls, as should be clear in the
Kconfig help message.

Threat Model/Patch Rational:

    From grsecurity's config for GRKERNSEC_HARDEN_TTY.


 | There are very few legitimate uses for this functionality and it
 | has made vulnerabilities in several 'su'-like programs possible in
 | the past.  Even without these vulnerabilities, it provides an
 | attacker with an easy mechanism to move laterally among other
 | processes within the same user's compromised session.

So if one process within a tty session becomes compromised it can follow
that additional processes, that are thought to be in different security
boundaries, can be compromised as a result. When using a program like su
or sudo, these additional processes could be in a tty session where TTY file
descriptors are indeed shared over privilege boundaries.

This is also an excellent writeup about the issue:
<http://www.halfdog.net/Security/2012/TtyPushbackPrivilegeEscalation/>

When user namespaces are in use, the check for the capability
CAP_SYS_ADMIN is done against the user namespace that originally opened
the tty.

# Integration with CRIU:
* The CRIU dev team was contacted about any possible issues that 
  restrict_tiocsti might cause for the CRIU program. Their response was that
  CRIU currently does not utilize the tiocsti ioctl, so it doesn't affect
  them at the moment. They do wish in the future to do checks against
  owner_user_ns, so we will work together on a way to make this information
  available to userspace. In the mean time, The CRIU team is OK with this
  patch moving forward as is.

# Changes since v6:
* fixed style issues
* changed error message to use dev_warn_ratelimited

# Changes since v5:
* added acks/reviews

# Changes since v4:
* fixed typo

# Changes since v3:
* use get_user_ns and put_user_ns to take and drop references to the owner
  user namespace because CONFIG_USER_NS is an option

# Changes since v2:
* take/drop reference to user namespace on tty struct alloc/free to prevent
  use-after-free.

# Changes since v1:
* added owner_user_ns to tty_struct to enable capability checks against
  the namespace that created the tty.
* rewording in different places to make patchset purpose clear
* Added Documentation
