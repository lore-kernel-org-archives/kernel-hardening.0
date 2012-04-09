Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 9 Apr 2012 13:48:37 +1000 (EST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <20120406142846.fd8dea70.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.2.02.1204091348060.16214@tundra.namei.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org> <alpine.LRH.2.02.1203301010310.11201@tundra.namei.org> <20120406142846.fd8dea70.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v17 00/15] seccomp_filter: BPF-based syscall filtering
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, Oleg Nesterov <oleg@redhat.com>, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.orgOleg Nesterov <oleg@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 6 Apr 2012, Andrew Morton wrote:

> > I've offered to take this via my tree -- if anyone else wants to merge it 
> > via theirs instead, holler.
> 
> OK by me, especially if it means that you'll carefully (re)review it!  I
> had some minor quibbles with v17.

Sure.

> 
> It would be good if Oleg could take a look at the signal changes, if he
> has not yet done so?
> 

-- 
James Morris
<jmorris@namei.org>
