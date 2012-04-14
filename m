Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 14 Apr 2012 11:45:08 +1000 (EST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <1334267284-19166-1-git-send-email-wad@chromium.org>
Message-ID: <alpine.LRH.2.02.1204141143001.29389@tundra.namei.org>
References: <1334267284-19166-1-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v18 01/15] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve
 from granting privs
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-man@vger.kernel.org, linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

I applied the patchset to:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

Please test, and make any further updates against that branch.


- James
-- 
James Morris
<jmorris@namei.org>
