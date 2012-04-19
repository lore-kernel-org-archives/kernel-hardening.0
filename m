Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 19 Apr 2012 13:40:25 +1000 (EST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <20120416185645.GA13667@www.outflux.net>
Message-ID: <alpine.LRH.2.02.1204191340020.563@tundra.namei.org>
References: <20120416185645.GA13667@www.outflux.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: Re: [kernel-hardening] [PATCH] Yama: add additional ptrace scopes
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>, Randy Dunlap <rdunlap@xenotime.net>, John Johansen <john.johansen@canonical.com>, linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 16 Apr 2012, Kees Cook wrote:

> This expands the available Yama ptrace restrictions to include two more
> modes. Mode 2 requires CAP_SYS_PTRACE for PTRACE_ATTACH, and mode 3
> completely disables PTRACE_ATTACH (and locks the sysctl).
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next


-- 
James Morris
<jmorris@namei.org>
