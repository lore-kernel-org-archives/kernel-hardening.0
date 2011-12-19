Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Dec 2011 11:33:10 +1100 (EST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <1324017197-3292-3-git-send-email-keescook@chromium.org>
Message-ID: <alpine.LRH.2.00.1112191130530.22702@tundra.namei.org>
References: <1324017197-3292-1-git-send-email-keescook@chromium.org> <1324017197-3292-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: Re: [kernel-hardening] [PATCH 2/2] security: Yama LSM
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Roland McGrath <roland@hack.frob.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 15 Dec 2011, Kees Cook wrote:

> +#ifdef CONFIG_SECURITY_YAMA
> +	ns->ptrace_scope = parent_pid_ns->ptrace_scope;
> +#endif
> +

I'd like to see this implemented as an LSM hook, something like 
security_ptrace_set_scope().



- James
-- 
James Morris
<jmorris@namei.org>
