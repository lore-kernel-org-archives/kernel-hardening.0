Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1475788788.1820.4.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Thu, 06 Oct 2016 14:19:48 -0700
In-Reply-To: <CAGXu5jJsj=4=j1R6aUYiDvdWqY916pJbBdXCEbQFFoyQ0QP4Yw@mail.gmail.com>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
	 <20161006133147.GA20206@infradead.org>
	 <476DC76E7D1DF2438D32BFADF679FC561CD14651@ORSMSX103.amr.corp.intel.com>
	 <20161006135612.GA21342@infradead.org>
	 <CAGXu5jJsj=4=j1R6aUYiDvdWqY916pJbBdXCEbQFFoyQ0QP4Yw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] printk: introduce kptr_restrict level 3
To: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@infradead.org>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "corbet@lwn.net" <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2016-10-06 at 14:00 -0700, Kees Cook wrote:

> And based on my read of this thread, we all appear to be in violent
> agreement. :) "always protect %p" is absolutely the goal, and we can
> figure out the best way to get there.

I proposed emitting pointers from the const and text sections by default
and using NULL for data pointers.

https://lkml.org/lkml/2016/8/5/380
