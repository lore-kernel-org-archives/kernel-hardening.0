Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1475788788.1820.4.camel@perches.com>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
 <20161006133147.GA20206@infradead.org> <476DC76E7D1DF2438D32BFADF679FC561CD14651@ORSMSX103.amr.corp.intel.com>
 <20161006135612.GA21342@infradead.org> <CAGXu5jJsj=4=j1R6aUYiDvdWqY916pJbBdXCEbQFFoyQ0QP4Yw@mail.gmail.com>
 <1475788788.1820.4.camel@perches.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 6 Oct 2016 14:25:57 -0700
Message-ID: <CAGXu5jL5R+roHcChEfq8PBJV+hcZNR8Z19pWrpJU9Kg8tfb_ew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] printk: introduce kptr_restrict level 3
To: Joe Perches <joe@perches.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Roberts, William C" <william.c.roberts@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "corbet@lwn.net" <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 6, 2016 at 2:19 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2016-10-06 at 14:00 -0700, Kees Cook wrote:
>
>> And based on my read of this thread, we all appear to be in violent
>> agreement. :) "always protect %p" is absolutely the goal, and we can
>> figure out the best way to get there.
>
> I proposed emitting pointers from the const and text sections by default
> and using NULL for data pointers.
>
> https://lkml.org/lkml/2016/8/5/380

Leaks of const and text (while not useful for write-attacks) can leak
KASLR offset (though yes, yes, there are many existing leaks -- but we
should avoid adding a new one regardless).

I think the logic of "is this destined for userspace" is likely the
cleanest approach. There still may be many things this breaks, though.
(I expect perf. Everything breaks perf. ;)

-Kees

-- 
Kees Cook
Nexus Security
