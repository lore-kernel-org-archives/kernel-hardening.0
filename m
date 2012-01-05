Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 5 Jan 2012 09:30:08 -0500
From: Nick Bowler <nbowler@elliptictech.com>
Message-ID: <20120105143008.GA31728@elliptictech.com>
References: <20120104201800.GA2587@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104201800.GA2587@www.outflux.net>
Subject: [kernel-hardening] Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2012-01-04 12:18 -0800, Kees Cook wrote:
> A long-standing class of security issues is the symlink-based
> time-of-check-time-of-use race, most commonly seen in world-writable
> directories like /tmp. The common method of exploitation of this flaw
> is to cross privilege boundaries when following a given symlink (i.e. a
> root process follows a symlink belonging to another user). For a likely
> incomplete list of hundreds of examples across the years, please see:
> http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp
> 
> The solution is to permit symlinks to only be followed when outside
> a sticky world-writable directory, or when the uid of the symlink and
> follower match, or when the directory owner matches the symlink's owner.
[...]
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 5f4c45d..26ede24 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -278,3 +278,19 @@ source "fs/nls/Kconfig"
>  source "fs/dlm/Kconfig"
>  
>  endmenu
> +
> +config PROTECTED_STICKY_SYMLINKS
> +	bool "Protect symlink following in sticky world-writable directories"
> +	default y
[...]

Why do we need a config option for this?  What's wrong with just using
the sysctl?

Why have you made this option "default y", when enabling it clearly
makes user-visible changes to kernel behaviour?

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
