Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <e80f32ef-d6cf-48cc-9ddb-75d95bc9581e@email.android.com>
References: <alpine.LFD.2.02.1203231926000.2542@ionos>
	<20120323190855.GA27213@www.outflux.net>
	<CAFLxGvzPVPyXPwjay4a01q1vx4K4Ht56bHjzswYrr1wvB_1dYw@mail.gmail.com>
	<87pq7935w2.fsf@xmission.com>
	<CAFLxGvz0reQS=zfWeTz4a4xZVFeeu80VnP-efy7zCiPZVWzH-g@mail.gmail.com>
	<20120803110247.GB11952@moon>
	<501BC62A.4090308@parallels.com>
	<e80f32ef-d6cf-48cc-9ddb-75d95bc9581e@email.android.com>
Date: Fri, 3 Aug 2012 10:16:50 -0700
Message-ID: <CAGXu5j+Cfhs8TqG59uJHf-4WFG8BD2i9EJDvSsTrpPyLUNTMzw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2] futex: mark get_robust_list as deprecated
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, richard -rw- weinberger <richard.weinberger@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>, Darren Hart <dvhart@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "spender@grsecurity.net" <spender@grsecurity.net>
List-ID: <kernel-hardening.lists.openwall.com>

Right, I'm satisfied with the ptrace_may_access check that was added.
The deprecation was suggested as an additional change. I'm okay
keeping the syscall if someone actually needs it. :)

-Kees

On Fri, Aug 3, 2012 at 5:58 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> The permissions on the syscall were fixed them withR ptrace_may_access.
>
> We have identified two legitimate use cases.
>
> It looks like it is time for someone to generate the path to remove the depreciation.
>
> Who is up for writing and testing that patch?
>
> Eric
>



-- 
Kees Cook
Chrome OS Security
