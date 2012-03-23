Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.LFD.2.02.1203231926000.2542@ionos>
References: <20120323175855.GA23668@www.outflux.net>
	<alpine.LFD.2.02.1203231926000.2542@ionos>
Date: Fri, 23 Mar 2012 12:08:38 -0700
Message-ID: <CAGXu5j+BLTA4nvNWHJbjWeOzQpjJRss=L4FP4drPcF4dwb8cGQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH] futex: mark get_robust_list as deprecated
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, kernel-hardening@lists.openwall.com, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 23, 2012 at 11:27 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 23 Mar 2012, Kees Cook wrote:
>
>> Notify get_robust_list users that the syscall is going away.
>
> That want's an entry in Documentation/feature-removal-schedule.txt as
> well.

Ah! Yes, I will send a v2.

> That's on top of your previous one, right ?

Yup. :)

-Kees

-- 
Kees Cook
ChromeOS Security
