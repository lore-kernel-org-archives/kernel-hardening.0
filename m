Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <m1fwczvuph.fsf@fess.ebiederm.org>
References: <20120323190855.GA27213@www.outflux.net>
	<m1fwczvuph.fsf@fess.ebiederm.org>
Date: Fri, 23 Mar 2012 15:10:43 -0700
Message-ID: <CAGXu5j+ONS_zw3=SXwQsuSSQ4GemA2UQ84_9U7ytyUFH3vRFRg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2] futex: mark get_robust_list as deprecated
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Darren Hart <dvhart@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, spender@grsecurity.net, Linux Containers <containers@lists.linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 23, 2012 at 3:06 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Kees Cook <keescook@chromium.org> writes:
>
>> Notify get_robust_list users that the syscall is going away.
>
> Has anyone asked the question if the folks working on checkpoint/restart
> are going to need this.
>
> This seems like important information to know if you want to checkpoint
> a process.

Hm, that might be true. But, I guess that's why it's lucky it's a
separate patch. :) The first patch is still desirable, IMO.

-Kees

-- 
Kees Cook
ChromeOS Security
