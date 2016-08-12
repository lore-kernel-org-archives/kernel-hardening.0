Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1608121044120.22028@cbobk.fhfr.pm>
References: <1470952169-39061-1-git-send-email-thgarnie@google.com>
 <alpine.LNX.2.00.1608120800100.22028@cbobk.fhfr.pm> <alpine.LNX.2.00.1608121044120.22028@cbobk.fhfr.pm>
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 12 Aug 2016 09:03:05 -0700
Message-ID: <CAJcbSZHG3ULCATigD0hhzOEXWi+GiDhtiBQdgaTiYnkP3k2fHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1] x86/power/64: Restore processor state before using
 per-cpu variables
To: Jiri Kosina <jikos@kernel.org>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Linux PM list <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bpetkov@suse.de>, Yinghai Lu <yinghai@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 12, 2016 at 2:23 AM, Jiri Kosina <jikos@kernel.org> wrote:
> On Fri, 12 Aug 2016, Jiri Kosina wrote:
>
> That's pretty nasty, as turning LOCKDEP on has sideffects on the code
> that'd normally not be expected to be run at all (tracepoint off).
>
> Oh well.

Thanks for the analysis, I didn't got that far so I had no idea how
everything was connected.

> Thanks again,

Thanks you and Borislav for finding it.
