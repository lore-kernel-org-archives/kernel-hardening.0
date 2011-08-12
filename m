Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 12 Aug 2011 15:05:04 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110812110504.GA4115@albatros>
References: <20110812102954.GA3496@albatros>
 <20110812105824.GA7141@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812105824.GA7141@openwall.com>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for
 libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 12, 2011 at 14:58 +0400, Solar Designer wrote:
> On Fri, Aug 12, 2011 at 02:29:54PM +0400, Vasiliy Kulikov wrote:
> > As a
> > result, it makes it impossible to change the return address on the stack
> > to the address of some library function (e.g. system(3)).
> 
> JFYI, this statement is too strong.
[...]

You're right.  I was thinking about a single overflow for ret2lib with
1+ argument(s).  In general, my statement is wrong, sure.

Thank you!

-- 
Vasiliy
