Date: Mon, 29 May 2017 23:26:40 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170529232640.16211960@alans-desktop>
In-Reply-To: <20170529213800.29438-3-matt@nmatt.com>
References: <20170529213800.29438-1-matt@nmatt.com>
	<20170529213800.29438-3-matt@nmatt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI ioctl require
 CAP_SYS_ADMIN
To: Matt Brown <matt@nmatt.com>
Cc: gregkh@linuxfoundation.org, serge@hallyn.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 29 May 2017 17:38:00 -0400
Matt Brown <matt@nmatt.com> wrote:

> This introduces the tiocsti_restrict sysctl, whose default is controlled
> via CONFIG_SECURITY_TIOCSTI_RESTRICT. When activated, this control
> restricts all TIOCSTI ioctl calls from non CAP_SYS_ADMIN users.

Which is really quite pointless as I keep pointing out and you keep
reposting this nonsense.

> 
> This patch depends on patch 1/2
> 
> This patch was inspired from GRKERNSEC_HARDEN_TTY.
> 
> This patch would have prevented
> https://bugzilla.redhat.com/show_bug.cgi?id=1411256 under the following
> conditions:
> * non-privileged container
> * container run inside new user namespace

And assuming no other ioctl could be used in an attack. Only there are
rather a lot of ways an app with access to a tty can cause mischief if
it's the same controlling tty as the higher privileged context that
launched it.

Properly written code allocates a new pty/tty pair for the lower
privileged session. If the code doesn't do that then your change merely
modifies the degree of mayhem it can cause. If it does it right then your
patch is pointless.

> Possible effects on userland:
> 
> There could be a few user programs that would be effected by this
> change.

In other words, it's yet another weird config option that breaks stuff.


NAK v7.

Alan
