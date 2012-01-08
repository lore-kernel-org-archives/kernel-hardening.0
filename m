Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 8 Jan 2012 04:44:07 -0700
From: Matthew Wilcox <matthew@wil.cx>
Message-ID: <20120108114407.GA22056@parisc-linux.org>
References: <20120107185548.GA30748@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120107185548.GA30748@outflux.net>
Subject: [kernel-hardening] Re: [PATCH v2012.2] fs: symlink restrictions on sticky directories
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jan 07, 2012 at 10:55:48AM -0800, Kees Cook wrote:
> v2012.2:
>  - Change sysctl mode to 0600, suggested by Ingo Molnar.
>  - Rework CONFIG logic to split code from default behavior.
>  - Renamed sysctl to have a "sysctl_" prefix, suggested by Andrew Morton.

All the sysctl / CONFIG logic seems very complex.  Why not make it
a module parameter instead?  It can be easily changed at boot time
(specify kernel.insecure_symlinks=1 on the kernel command line) and,
with a mode of 0600, can be modified at runtime too.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
