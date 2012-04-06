Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 6 Apr 2012 12:55:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20120406125517.77133b4e.akpm@linux-foundation.org>
In-Reply-To: <1333051320-30872-2-git-send-email-wad@chromium.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-2-git-send-email-wad@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v17 01/15] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent
 execve from granting privs
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, jmorris@namei.org, Andy Lutomirski <luto@amacapital.net>, linux-man@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 29 Mar 2012 15:01:46 -0500
Will Drewry <wad@chromium.org> wrote:

> From: Andy Lutomirski <luto@amacapital.net>
> 
> With this set, a lot of dangerous operations (chroot, unshare, etc)
> become a lot less dangerous because there is no possibility of
> subverting privileged binaries.

The changelog doesn't explain the semantics of the new syscall. 
There's a comment way-down-there which I guess suffices, if you hunt
for it.

And the changelog doesn't explain why this is being added.  Presumably
seccomp_filter wants/needs this feature but whowhatwherewhenwhy?  Spell
it all out, please.

The new syscall mode will be documented in the prctl manpage.  Please
cc linux-man@vger.kernel.org and work with Michael on getting this
done?

>
> ...
>
