Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 7 May 2015 12:37:51 +0300
From: Vasily Kulikov <segoon@openwall.com>
Message-ID: <20150507093751.GA18746@cachalot>
References: <CADOUnBK=jW36v6X2Q6EXLL35Wxqait7cWJR-adCFwRaMJtucPQ@mail.gmail.com>
 <20150502125329.GA6820@openwall.com>
 <20150507093639.GA4522@cachalot>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150507093639.GA4522@cachalot>
Subject: [kernel-hardening] Re: Linux kernel pointer poisoning (was: CVE request for a fixed bug
 existed in all versions of linux kernel from KeenTeam)
To: Solar Designer <solar@openwall.com>
Cc: Wen Xu <hotdog3645@gmail.com>, oss-security@lists.openwall.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 07, 2015 at 12:36 +0300, Vasily Kulikov wrote:
> b) how to check for an insane POISON_POINTER() arg in case of
> TIMER_ENTRY_STATIC (and such)?  The current implementation of
> POISON_POINTER() fails as following:
> 
> mm/page_alloc.c: In function 'free_pages_prepare':
> mm/page_alloc.c:840:23: error: call to '__compiletime_assert_840' declared with attribute error: BUILD_BUG_ON failed: 0x0111400 >= POISON_AREA_SIZE

Sorry, I've copied a wrong error message.  The right one is as
following:

kernel/irq/spurious.c:23:8: error: braced-group within expression allowed only inside a function

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
