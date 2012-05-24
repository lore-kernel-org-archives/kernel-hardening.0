Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 25 May 2012 09:40:18 +1000 (EST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <1337875681-20717-1-git-send-email-wad@chromium.org>
Message-ID: <alpine.LRH.2.02.1205250932270.26644@tundra.namei.org>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk> <1337875681-20717-1-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC PATCH 0/3] move the secure_computing call
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, mcgrathr@google.com, hpa@zytor.com, indan@nul.nu, netdev@parisplace.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, viro@zeniv.linux.org.uk
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 24 May 2012, Will Drewry wrote:

> As is, the biggest benefit of this change is just setting consistent
> expectations in what the ptrace/seccomp interactions should be.  The
> current ability for ptrace to "bypass" secure computing (by remapping
> allowed system calls) is not necessarily a problem, but it is not
> necessarily intuitive behavior.

Indeed -- while the purpose of seccomp is to reduce the attack surface of 
the syscall interface, if a user allows ptrace, attackers will definitely 
see that as an attack vector, if it allows them to increase that attack 
surface.

It at least needs to be well-documented.

-- 
James Morris
<jmorris@namei.org>
