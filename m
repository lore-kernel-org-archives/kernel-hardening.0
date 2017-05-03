MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170425041512.13189-1-matt@nmatt.com>
References: <20170425041512.13189-1-matt@nmatt.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 3 May 2017 12:30:11 -0700
Message-ID: <CAGXu5jLzrCXSsc3rOteRO6bxRg7oon3qtzR+q--oj_iXb736yA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 0/2] security: tty: make TIOCSTI ioctl require CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>, Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 24, 2017 at 9:15 PM, Matt Brown <matt@nmatt.com> wrote:
> This patchset introduces the tiocsti_restrict sysctl, whose default is
> controlled via CONFIG_SECURITY_TIOCSTI_RESTRICT. When activated, this
> control restricts all TIOCSTI ioctl calls from non CAP_SYS_ADMIN users.
>
> This patch was inspired from GRKERNSEC_HARDEN_TTY.
>
> This patch would have prevented
> https://bugzilla.redhat.com/show_bug.cgi?id=1411256 under the following
> conditions:
> * non-privileged container
> * container run inside new user namespace
>
> Possible effects on userland:
>
> There could be a few user programs that would be effected by this
> change.
> See: <https://codesearch.debian.net/search?q=ioctl%5C%28.*TIOCSTI>
> notable programs are: agetty, csh, xemacs and tcsh
>
> However, I still believe that this change is worth it given that the
> Kconfig defaults to n. This will be a feature that is turned on for the
> same reason that people activate it when using grsecurity. Users of this
> opt-in feature will realize that they are choosing security over some OS
> features like unprivileged TIOCSTI ioctls, as should be clear in the
> Kconfig help message.
>
> Threat Model/Patch Rational:
>
> From grsecurity's config for GRKERNSEC_HARDEN_TTY.
>
>  | There are very few legitimate uses for this functionality and it
>  | has made vulnerabilities in several 'su'-like programs possible in
>  | the past.  Even without these vulnerabilities, it provides an
>  | attacker with an easy mechanism to move laterally among other
>  | processes within the same user's compromised session.
>
> So if one process within a tty session becomes compromised it can follow
> that additional processes, that are thought to be in different security
> boundaries, can be compromised as a result. When using a program like su
> or sudo, these additional processes could be in a tty session where TTY file
> descriptors are indeed shared over privilege boundaries.
>
> This is also an excellent writeup about the issue:
> <http://www.halfdog.net/Security/2012/TtyPushbackPrivilegeEscalation/>
>
> When user namespaces are in use, the check for the capability
> CAP_SYS_ADMIN is done against the user namespace that originally opened
> the tty.

This looks like it's ready to go. Greg, can you include this in your
tree? That seems like the best place, even though it touches a few
areas.

Please consider it:

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees


>
> # Changes since v4:
> * fixed typo
>
> # Changes since v3:
> * use get_user_ns and put_user_ns to take and drop references to the owner
>   user namespace because CONFIG_USER_NS is an option
>
> # Changes since v2:
> * take/drop reference to user namespace on tty struct alloc/free to prevent
>   use-after-free.
>
> # Changes since v1:
> * added owner_user_ns to tty_struct to enable capability checks against
>   the namespace that created the tty.
> * rewording in different places to make patchset purpose clear
> * Added Documentation



-- 
Kees Cook
Pixel Security
