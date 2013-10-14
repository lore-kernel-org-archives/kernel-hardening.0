Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1381791216.16896.8.camel@joe-AO722>
From: Joe Perches <joe@perches.com>
Date: Mon, 14 Oct 2013 15:53:36 -0700
In-Reply-To: <525C7278.3090200@gmail.com>
References: <525C7278.3090200@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4] vsprintf: Check real user/group id for %pK
To: Ryan Mallon <rmallon@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, George Spelvin <linux@horizon.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>, Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2013-10-15 at 09:38 +1100, Ryan Mallon wrote:
> This is a temporary solution only, but fixes a minor security hole when
> kptr_restrict=1. I am working to fix this properly, but there is still
> some discussion around how to achieve this, see here:

Glad you changed your mind.
