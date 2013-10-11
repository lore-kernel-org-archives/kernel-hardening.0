Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1381469341.14017.39.camel@joe-AO722>
From: Joe Perches <joe@perches.com>
Date: Thu, 10 Oct 2013 22:29:01 -0700
In-Reply-To: <52578A4D.2000300@gmail.com>
References: <20131011044232.11545.qmail@science.horizon.com>
	 <52578A4D.2000300@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
To: Ryan Mallon <rmallon@gmail.com>
Cc: George Spelvin <linux@horizon.com>, ebiederm@xmission.com, akpm@linux-foundation.org, dan.j.rosenberg@gmail.com, eldad@fogrefinery.com, jgunthorpe@obsidianresearch.com, jkosina@suse.cz, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2013-10-11 at 16:19 +1100, Ryan Mallon wrote:
> Yeah, that is probably the best solution. I'll try to put together a
> patch series doing this. It will obviously be more involved though, so I
> think it is still worth merging the original patch in the interm.

I just submitted a patch neatening and shrinking
the original code without the cred changes.

Maybe build on that?
