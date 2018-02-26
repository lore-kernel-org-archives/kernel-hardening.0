Date: Mon, 26 Feb 2018 11:12:35 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/7] genalloc: selftest
Message-ID: <20180226191235.GA24087@bombadil.infradead.org>
References: <20180223144807.1180-1-igor.stoppa@huawei.com>
 <20180223144807.1180-3-igor.stoppa@huawei.com>
 <76b3d858-b14e-b66d-d8ae-dbd0b307308a@gmail.com>
 <a7b47f45-5929-ae07-1a10-46a02f6db078@huawei.com>
 <45087800-218a-7ff5-22c0-d0a5bfea5001@gmail.com>
 <20249e10-4a13-8084-bcf2-0f98497a755f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20249e10-4a13-8084-bcf2-0f98497a755f@huawei.com>
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: J Freyensee <why2jjj.linux@gmail.com>, david@fromorbit.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 26, 2018 at 08:00:26PM +0200, Igor Stoppa wrote:
> On 26/02/18 19:46, J Freyensee wrote:
> > That's a good question.  Based upon those articles, 'yes'.  But it seems 
> > like a 'darned-if-you-do, darned-if-you-don't' question as couldn't you 
> > also corrupt a mounted filesystem by crashing the kernel, yes/no?
> 
> The idea is to do it very early in the boot phase, before early init,
> when the kernel has not gotten even close to any storage device.
> 
> > If you really want a system crash, maybe just do a panic() like 
> > filesystems also use?
> 
> ok, if that's a more acceptable way to halt the kernel, I do not mind.

panic() halts the kernel
BUG_ON() kills the thread
WARN_ON() just prints messages

Now, if we're at boot time and we're still executing code from the init
thread, killing init is equivalent to halting the kernel.

The question is, what is appropriate for test modules?  I would say
WARN_ON is not appropriate because people ignore warnings.  BUG_ON is
reasonable for development.  panic() is probably not.

Also, calling BUG_ON while holding a lock is not a good idea; if anything
needs to acquire that lock to shut down in a reasonable fashion, it's
going to hang.

And there's no need to do something like BUG_ON(!foo); foo->wibble = 1;
Dereferencing a NULL pointer already produces a nice informative splat.
In general, we assume other parts of the kernel are sane and if they pass
us a NULL pool, it's no good returning -EINVAL, we may as well just oops
and let somebody else debug it.
