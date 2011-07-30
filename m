Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 30 Jul 2011 22:43:29 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110730184329.GA4447@albatros>
References: <20110723162251.GA11485@openwall.com>
 <20110730183830.GA4314@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110730183830.GA4314@albatros>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sat, Jul 30, 2011 at 22:38 +0400, Vasiliy Kulikov wrote:
> This is a patch, which should solve the problem.  Note that the default
> base address allocation policy for the mainline is top-down, so
> 0x00110000 was not considered even in x86-32.  Now it should work for
> both 32-bit systems and 32-bit tasks in 64-bit systems.

One note: if watch for ldd output, approx. every 20th output shows that
some library gets 0xffAABBCC address.  If watch for the real task's maps
(via /proc/pid/maps), all libs are located before 0x01AABBCC.

I don't know for sure how ldd allocated memory, but I suspect it wastes
too much 0x00AABBCC addresses, so sometimes there is no place for them.

So, I don't think it is an issue.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
