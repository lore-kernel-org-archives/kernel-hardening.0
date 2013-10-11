Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <20131011044232.11545.qmail@science.horizon.com>
	<525875DB.9030300@gmail.com>
Date: Fri, 11 Oct 2013 15:37:32 -0700
In-Reply-To: <525875DB.9030300@gmail.com> (Ryan Mallon's message of "Sat, 12
	Oct 2013 09:04:11 +1100")
Message-ID: <87d2nba0yb.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
To: Ryan Mallon <rmallon@gmail.com>
Cc: George Spelvin <linux@horizon.com>, joe@perches.com, akpm@linux-foundation.org, dan.j.rosenberg@gmail.com, eldad@fogrefinery.com, jgunthorpe@obsidianresearch.com, jkosina@suse.cz, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, rusty@rustcorp.com.au
List-ID: <kernel-hardening.lists.openwall.com>

Ryan Mallon <rmallon@gmail.com> writes:

> The only remaining problem is kernel/module.c:module_sect_show() which
> is used to write the sysfs files in /sys/module/<modname>/sections/.
> Those files are actually are really good target for leaking %pK values
> via setuid binaries. The problem is that the module_sect_show() function
> isn't passed information about who opened the sysfs file. I don't think
> this information is available in general for sysfs files either. Also,
> I can't actually see how module_sect_show() gets called?
>
> I'm a bit stuck on how to solve this. Any ideas?

I haven't yet had a chance to review the patches but there are patches
to make sysfs files seq files in Greg's driver core tree.

Eric
