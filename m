Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: markus@google.com
In-Reply-To: <20120406124921.5754e941.akpm@linux-foundation.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
 <1333051320-30872-2-git-send-email-wad@chromium.org> <20120406124921.5754e941.akpm@linux-foundation.org>
From: Markus Gutschke <markus@chromium.org>
Date: Fri, 6 Apr 2012 13:47:12 -0700
Message-ID: <CAE6n16m3v4BghY7GGwHCy2t-7-vmRpyOV6swap9GrMQnmGLroA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v17 01/15] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve
 from granting privs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com, coreyb@linux.vnet.ibm.com, keescook@chromium.org, jmorris@namei.org, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 6, 2012 at 12:49, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 29 Mar 2012 15:01:46 -0500
> Will Drewry <wad@chromium.org> wrote:
>> From: Andy Lutomirski <luto@amacapital.net>
>> With this set, a lot of dangerous operations (chroot, unshare, etc)
>> become a lot less dangerous because there is no possibility of
>> subverting privileged binaries.

I don't want to derail things. So, tell me to go away, if I can't have
what I want.

Having said that, it would be great if NO_NEW_PRIVS also gave access
to the restricted clone() flags. Such as CLONE_NEWIPC, CLONE_NEWNET
and CLONE_NEWPID.


Markus
