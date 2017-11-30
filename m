Date: Thu, 30 Nov 2017 03:05:58 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Message-ID: <20171130020558.GA729@wotan.suse.de>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-3-git-send-email-tixxdz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511803118-2552-3-git-send-email-tixxdz@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v5 next 2/5] modules:capabilities: add
 cap_kernel_module_request() permission check
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 06:18:35PM +0100, Djalal Harouni wrote:
> +/* Determine whether a module auto-load operation is permitted. */
> +int may_autoload_module(char *kmod_name, int required_cap,
> +			const char *kmod_prefix);
> +

While we are reviewing a general LSM for this, it has me wondering if an LSM or
userspace feed info may every want to use other possible context we could add for
free to make a determination.

For instance since all request_module() calls are in header files, we could 
for add for free THIS_MODULE as context to may_autoload_module() as well, so
struct module. The LSM could in theory then also help ensure only specific
modules are allowed to request a module load. Perhaps userspace could say
only built-in code could request certain modules.

Just a thought.

  Luis
