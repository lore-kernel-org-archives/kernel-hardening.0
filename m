Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 15 Oct 2013 13:51:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20131015135113.ffdbeb97b73db061040904c9@linux-foundation.org>
In-Reply-To: <525C7278.3090200@gmail.com>
References: <525C7278.3090200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4] vsprintf: Check real user/group id for %pK
To: Ryan Mallon <rmallon@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, George Spelvin <linux@horizon.com>, Joe Perches <joe@perches.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>, Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 15 Oct 2013 09:38:48 +1100 Ryan Mallon <rmallon@gmail.com> wrote:

> Some setuid binaries will allow reading of files which have read
> permission by the real user id. This is problematic with files which
> use %pK because the file access permission is checked at open() time,
> but the kptr_restrict setting is checked at read() time. If a setuid
> binary opens a %pK file as an unprivileged user, and then elevates
> permissions before reading the file, then kernel pointer values may be
> leaked.
> 
> This happens for example with the setuid pppd application on Ubuntu 12.04:
> 
>   $ head -1 /proc/kallsyms
>   00000000 T startup_32
> 
>   $ pppd file /proc/kallsyms
>   pppd: In file /proc/kallsyms: unrecognized option 'c1000000'
> 
> This will only leak the pointer value from the first line, but other
> setuid binaries may leak more information.
> 
> Fix this by adding a check that in addition to the current process
> having CAP_SYSLOG, that effective user and group ids are equal to the
> real ids. If a setuid binary reads the contents of a file which uses
> %pK then the pointer values will be printed as NULL if the real user
> is unprivileged.
> 
> Update the sysctl documentation to reflect the changes, and also
> correct the documentation to state the kptr_restrict=0 is the default.
> 
> This is a only temporary solution to the issue. The correct solution
> is to do the permission check at open() time on files, and to replace
> %pK with a function which checks the open() time permission. %pK uses
> in printk should be removed since no sane permission check can be
> done, and instead protected by using dmesg_restrict.

I grabbed this and queued it for 3.13-rc1, marked for backporting into
-stable.  Given the amount of churn on this one I think it would be
imprudent to put it into mainline immediately.

I haven't been following the discussion very closely, so if anyone
thinks it should be ungrabbed, please speak up.
